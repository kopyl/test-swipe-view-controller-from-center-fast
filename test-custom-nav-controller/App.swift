import UIKit

/// Source: https://stackoverflow.com/questions/32914006/swipe-to-go-back-only-works-on-edge-of-screen

class MainViewController: UIViewController {
    let button = UIButton()
    
    override func loadView() {
        view = UIView()
        view.addSubview(button)
        button.setTitle("Push VC", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
    }
    
    @objc func pushViewController() {
        navigationController?.pushViewController(SecondaryViewController(), animated: true)
    }
}

class SecondaryViewController: UIViewController {
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
    }
}

class SwipeNavigationController: UINavigationController {

      private var interactiveTransition: UIPercentDrivenInteractiveTransition?

      override func viewDidLoad() {
          super.viewDidLoad()

          delegate = self

          let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleNavigationTransition(_:)))
          panGesture.delegate = self
          view.addGestureRecognizer(panGesture)

          interactivePopGestureRecognizer?.isEnabled = false
      }

      @objc private func handleNavigationTransition(_ gesture: UIPanGestureRecognizer) {
          let translation = gesture.translation(in: view)
          let progress = max(0, min(1, translation.x / view.bounds.width))

          switch gesture.state {
          case .began:
              interactiveTransition = UIPercentDrivenInteractiveTransition()
              popViewController(animated: true)

          case .changed:
              interactiveTransition?.update(progress)

          case .ended, .cancelled:
              let velocity = gesture.velocity(in: view)
              if progress > 0.3 || velocity.x > 500 {
                  interactiveTransition?.finish()
              } else {
                  interactiveTransition?.cancel()
              }
              interactiveTransition = nil

          default:
              break
          }
      }
  }

extension SwipeNavigationController: UIGestureRecognizerDelegate {
      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
          guard viewControllers.count > 1,
                let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }

          let velocity = pan.velocity(in: view)
          return velocity.x > 0 && abs(velocity.x) > abs(velocity.y)
      }
  }

extension SwipeNavigationController: UINavigationControllerDelegate {

      func navigationController(_ navigationController: UINavigationController,
                                animationControllerFor operation: UINavigationController.Operation,
                                from fromVC: UIViewController,
                                to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          operation == .pop ? PopAnimator() : nil
      }

      func navigationController(_ navigationController: UINavigationController,
                                interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
          interactiveTransition
      }
  }

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.3 }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
          return transitionContext.completeTransition(false)
      }

      let container = transitionContext.containerView
      let width = container.bounds.width

      toView.frame = container.bounds.offsetBy(dx: -width * 0.3, dy: 0)
      container.insertSubview(toView, belowSubview: fromView)

      UIView.animate(withDuration: 0.3) {
          fromView.frame.origin.x = width
          toView.frame.origin.x = 0
      } completion: { _ in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
  }
}

@main
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SwipeNavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
    }
}
