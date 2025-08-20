import SwiftUI
import InAppSettingsKit

public struct IASKView: UIViewControllerRepresentable {
    private var showDoneButton: Bool?
    private let viewController = IASKAppSettingsViewController()
    
    public init(showDoneButton: Bool? = nil, delegate: IASKSettingsDelegate? = nil) {
        self.showDoneButton = showDoneButton
        viewController.delegate = delegate
        if let showDoneButton {
            viewController.showDoneButton = showDoneButton
        }
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        return if showDoneButton == nil {
            viewController
        } else {
            UINavigationController(rootViewController: viewController)
        }
    }
    
    public func updateUIViewController(_ viewController: UIViewController, context: Context) {
    }
}
