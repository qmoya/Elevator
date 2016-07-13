import UIKit

final class App {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let navigationController: UINavigationController

    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        let elevatorViewController = navigationController.viewControllers[0] as! ElevatorViewController
        
        elevatorViewController.didTapShowStories = showStories
    }
    
    func showStories() {
        let storiesNavigationController = storyboard.instantiateViewControllerWithIdentifier("StoriesNavigationController") as! UINavigationController
        let storiesViewController = storiesNavigationController.viewControllers[0] as! StoriesViewController
        storiesViewController.didTapCancel = cancel
        navigationController.presentViewController(storiesNavigationController, animated: true, completion: nil)
    }
    
    func cancel() {
        navigationController.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
