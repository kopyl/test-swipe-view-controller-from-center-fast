import UIKit

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

class SwipeNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullScreenSwipeBack()
    }

    private func setupFullScreenSwipeBack() {
        guard let interactivePopGestureRecognizer = interactivePopGestureRecognizer,
              let targets = interactivePopGestureRecognizer.value(forKey: "targets") as? [AnyObject] else { return }

        let panGesture = UIPanGestureRecognizer()
        panGesture.setValue(targets, forKey: "targets")
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1 else { return false }
        return true
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
