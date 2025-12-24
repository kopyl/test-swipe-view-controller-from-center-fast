### Repo description

This repo is designed as exploration of possible implementations of full screen swipe back gesture in iOS apps.

### Challenges:

Initially I implemented a way for users to swipe back to a previous VC from anywhere on the screen. By default users can go back to a previous screen only by swiping from the left side of the screen (in the right direction).

The initial approach was based on this Stackoverflow answer: https://stackoverflow.com/questions/32914006/swipe-to-go-back-only-works-on-edge-of-screen .

The very basic implementation of it can be found here: https://github.com/kopyl/test-swipe-view-controller-from-center-fast/blob/4c7ae207927191f8b706e2a4097a69aff01fbb77/test-custom-nav-controller/App.swift#L36

But there was a problem with this approach:
When you swipe very fast (to go to the previous VC), the latest VC stays in place and for a brief moment you see the previous VC.

This behaviour can be seen on a UI XC test: https://github.com/kopyl/test-swipe-view-controller-from-center-fast/blob/4c7ae207927191f8b706e2a4097a69aff01fbb77/UITests/UITests.swift#L27
- Running `testPushViewControllerAndSwipeBackFromCenterWithGlitch` test triggers this glitch.
- Running `testPushViewControllerAndSwipeBackFromCenterNoGlitch` test does not trigger the glitch, because the swipe gesture is executed much slower.

With the help of Claude Code I was able to write a version of a full-screen navigation controller which does not have the glitch: https://github.com/kopyl/test-swipe-view-controller-from-center-fast/blob/47deaed7b01c7546b45a9de11aade69809dad4d9/test-custom-nav-controller/SwipeNavigationController.swift .
d895565

But the implementation does not ƒeel native and fluent in animations.

Stackoverflow answers:
- https://stackoverflow.com/questions/22244688/navigation-pop-view-when-swipe-right-like-instagram-iphone-app-how-i-achieve-thi/22244990#22244990
- https://stackoverflow.com/questions/32914006/swipe-to-go-back-only-works-on-edge-of-screen

Telegram implementation:
- Commit: 5e724b92eac51455c265cf9ae3d47ec1a63f5905
- submodules/Display/Display/InteractiveTransitionGestureRecognizer.swift
- submodules/Display/Display/Navigation/NavigationContainer.swift