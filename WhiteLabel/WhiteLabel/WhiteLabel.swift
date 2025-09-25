import Foundation
import UIKit

// MARK: - WhiteLabel Framework
// This framework contains the main view controllers for the sample app
// Sentry will exclude these from UI load span tracking because they're not in the main app bundle

public class WhiteLabel {
    public static let shared = WhiteLabel()
    
    private init() {}
    
    public func initialize() {
        print("WhiteLabel framework initialized")
    }
}
