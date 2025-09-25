import UIKit
import Sentry

// MARK: - NewShopViewController
// This view controller is now in the WhiteLabel framework
// Sentry will exclude it from UI load span tracking because it's not in the main app bundle

public class NewShopViewController: UIViewController {
    
    private var cartButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCartButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Shop"
        
        // Add some content to make the view more realistic
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add sample content
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to Anthropologie"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Discover unique clothing, accessories, and home decor"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        let shopTileButton = UIButton(type: .system)
        shopTileButton.setTitle("Browse Products", for: .normal)
        shopTileButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        shopTileButton.backgroundColor = UIColor(red: 0.0196078, green: 0.447059, blue: 0.54902, alpha: 1.0)
        shopTileButton.setTitleColor(.white, for: .normal)
        shopTileButton.layer.cornerRadius = 8
        shopTileButton.addTarget(self, action: #selector(shopTileButtonTapped), for: .touchUpInside)
        shopTileButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shopTileButton)
        
        let testButton = UIButton(type: .system)
        testButton.setTitle("Test UI Load Spans Issue", for: .normal)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        testButton.backgroundColor = UIColor.systemRed
        testButton.setTitleColor(.white, for: .normal)
        testButton.layer.cornerRadius = 8
        testButton.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(testButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            shopTileButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            shopTileButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shopTileButton.widthAnchor.constraint(equalToConstant: 200),
            shopTileButton.heightAnchor.constraint(equalToConstant: 50),
            
            testButton.topAnchor.constraint(equalTo: shopTileButton.bottomAnchor, constant: 20),
            testButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 250),
            testButton.heightAnchor.constraint(equalToConstant: 44),
            testButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupCartButton() {
        // Create cart button similar to Anthropologie's implementation
        cartButton = UIButton(type: .system)
        cartButton.setTitle("🛒", for: .normal)
        cartButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        cartButton.backgroundColor = UIColor(red: 0.0196078, green: 0.447059, blue: 0.54902, alpha: 1.0)
        cartButton.layer.cornerRadius = 22
        cartButton.accessibilityIdentifier = "cartButton" // Match the identifier from logs
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            cartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cartButton.widthAnchor.constraint(equalToConstant: 44),
            cartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func shopTileButtonTapped() {
        let shopTileViewController = ShopTileViewController()
        navigationController?.pushViewController(shopTileViewController, animated: true)
    }
    
    @objc private func testButtonTapped() {
        let customViewController = CustomViewController()
        navigationController?.pushViewController(customViewController, animated: true)
    }
    
    @objc private func cartButtonTapped() {
        // Simulate the cart button press that triggers the error in logs
        print("Cart button tapped")
        
        // Simulate network request that might fail with TOKEN_CART_NOT_VALID
        simulateCartRequest()
        
        // Present cart view controller
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showCart()
        }
    }
    
    private func simulateCartRequest() {
        // Simulate the API call that results in TOKEN_CART_NOT_VALID error
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Simulate the error from the logs
            let error = NSError(
                domain: "URBNApiServices.ApiServiceError",
                code: 5,
                userInfo: [
                    NSLocalizedDescriptionKey: "serverResponseError(httpStatusCode: URBNApiServices.HttpStatusCode.preconditionFailed, response: URBNApiServices.ServerResponseError(code: Optional(\"TOKEN_CART_NOT_VALID\"), message: Optional(\"\"), existingResourceId: nil, field_errors: nil)) (Code: 5)"
                ]
            )
            
            // Capture the error with Sentry (this should generate the UI load spans)
            _ = SentrySDK.capture(error: error)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This should trigger UI load spans in Sentry, but won't because it's in a framework
        print("WhiteLabel.NewShopViewController appeared")
    }
}
