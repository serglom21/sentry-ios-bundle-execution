import UIKit

// MARK: - TabBarController
// This view controller is now in the WhiteLabel framework
// Sentry will exclude it from UI load span tracking because it's not in the main app bundle

public class TabBarController: UITabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Hide tab bar as per app design
        tabBar.isHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This should trigger UI load spans in Sentry, but won't because it's in a framework
        print("WhiteLabel.TabBarController appeared")
    }
}
