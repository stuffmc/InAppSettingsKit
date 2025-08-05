import SwiftUI
import InAppSettingsKit

public struct IASKView: UIViewControllerRepresentable {
    public init() {
    }
    
    public func makeUIViewController(context: Context) -> IASKAppSettingsViewController {
        .init()
    }
    
    public func updateUIViewController(_ uiViewController: IASKAppSettingsViewController, context: Context) {
    }
}
