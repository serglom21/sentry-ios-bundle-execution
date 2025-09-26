import UIKit

// MARK: - NavigationController
// This view controller is now in the WhiteLabel framework
// Sentry will exclude it from UI load span tracking because it's not in the main app bundle

public class NavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Configure navigation bar appearance for cart
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = UIColor(red: 0.0196078, green: 0.447059, blue: 0.54902, alpha: 1.0)
        
        // Set modal presentation style
        modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.medium(), .large()]
            sheetPresentationController?.preferredCornerRadius = 16
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This should trigger UI load spans in Sentry, but won't because it's in a framework
        print("WhiteLabel.NavigationController appeared")
    }
}
