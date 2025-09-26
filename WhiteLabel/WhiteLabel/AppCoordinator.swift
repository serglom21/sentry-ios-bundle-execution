import UIKit

// MARK: - AppCoordinator
// This coordinator is now in the WhiteLabel framework
// It manages the view controllers that are also in the framework

public class AppCoordinator {
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        // Create the full app structure using framework view controllers
        setupMainInterface()
    }
    
    private func setupMainInterface() {
        // Create the main tab bar controller (hidden for clean UI)
        let tabBarController = TabBarController()
        
        // Create the main shop navigation controller
        let shopViewController = NewShopViewController()
        let shopNavigationController = NewShopNavigationController(rootViewController: shopViewController)
        
        // Set up the tab bar controller with the shop view
        tabBarController.setViewControllers([shopNavigationController], animated: false)
        
        // Set the tab bar controller as the root view controller
        window.rootViewController = tabBarController
    }
    
    public func showCart() {
        // Create cart navigation controller using framework view controllers
        let cartNavigationController = NavigationController()
        let cartViewController = CartViewController()
        let basketViewController = BasketViewController()
        
        cartNavigationController.setViewControllers([cartViewController, basketViewController], animated: false)
        
        // Present cart modally from the current top view controller
        if let rootViewController = window.rootViewController {
            var topViewController = rootViewController
            while let presented = topViewController.presentedViewController {
                topViewController = presented
            }
            topViewController.present(cartNavigationController, animated: true)
        }
    }
}
