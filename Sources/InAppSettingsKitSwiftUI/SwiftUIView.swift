import SwiftUI
import InAppSettingsKit

public struct IASKView: UIViewControllerRepresentable {
//    private var showDoneButton: Bool
    
    public init() {
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = IASKAppSettingsViewController()
        viewController.showDoneButton = true
        viewController.showDoneButton = true
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
