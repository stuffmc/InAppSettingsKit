import SwiftUI
import InAppSettingsKit

struct IASKView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> IASKAppSettingsViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: IASKAppSettingsViewController, context: Context) {
    }
}
