import SwiftUI
import InAppSettingsKit
import InAppSettingsKitSwiftUI

@main
struct IASKSwiftUISample: App {
    var body: some Scene {
        WindowGroup {
            Tabs()
        }
    }
}

struct Tabs: View {
    @State private var showingSheet = false
    @State private var showingModal = false
    private let settingsDelegate = SettingsDelegate()
    @State private var appDelegate: AppDelegate?

    var body: some View {
        TabView {
            Tab("Feature", systemImage: "star") {
                NavigationStack {
                    VStack(spacing: 30) {
                        NavigationLink(.showSettingsPush) {
                            iask(showDoneButton: nil)
                        }
                        Button(.showSettingsModal) {
                            showingModal.toggle()
                        }
                        .sheet(isPresented: $showingModal) { iask() }
                    }
                    .bold()
                    .navigationTitle(Text(.swiftUIIaskSample))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button(.settings) {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) { iask() }
                    }
                }
            }
            Tab("Settings", systemImage: "gearshape.2.fill") {
                iask(showDoneButton: false)
                    .edgesIgnoringSafeArea(.top)
            }
        }
    }

    private func iask(showDoneButton: Bool? = true) -> some View {
        let iaskView = IASKView(showDoneButton: showDoneButton, delegate: settingsDelegate)
        return iaskView
            .navigationTitle(.settings)
            .onAppear {
                appDelegate = AppDelegate(iaskView.viewController)
            }
    }
}

class AppDelegate: NSObject {
    private var viewController: IASKAppSettingsViewController

    public init(_ viewController: IASKAppSettingsViewController) {
        self.viewController = viewController
        super.init()
        updateHiddenKeys()
        NotificationCenter.default.addObserver(self, selector: #selector(settingDidChange(notification:)), name: Notification.Name.IASKSettingChanged, object: nil)
    }

    @objc func settingDidChange(notification: Notification?) {
        updateHiddenKeys()
    }

    func updateHiddenKeys() {
        var hiddenKeys = Set<String>()
        if UserDefaults.standard.bool(forKey: "AutoConnect") {
            hiddenKeys.formUnion(["AutoConnectLogin", "AutoConnectPassword", "loginOptions"])
        }
        if !UserDefaults.standard.bool(forKey: "ShowAccounts") {
            hiddenKeys.insert("accounts")
        }
        viewController.setHiddenKeys(hiddenKeys, animated: true)
    }
}

private class SettingsDelegate: NSObject, IASKSettingsDelegate {
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) {
        settingsViewController.dismiss(animated: true)
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, heightForHeaderInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        switch specifier.key {
        case "IASKLogo":
            return UIImage(named: "Icon.png")?.size.height ?? 0 + 25
        case "IASKCustomHeaderStyle":
            return 55
        default:
            return 0
        }
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, heightForFooterInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        switch specifier.key {
        case "IASKLogo":
            return UIImage(named: "Icon.png")?.size.height ?? 0 + 25
        default:
            return 0
        }
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, viewForFooterInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        switch specifier.key {
        case "IASKLogo":
            let imageView = UIImageView(image: UIImage(named: "Icon.png"))
            imageView.contentMode = .center
            return imageView
        default:
            return nil
        }
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, viewForHeaderInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        switch specifier.key {
        case "IASKLogo":
            let imageView = UIImageView(image: UIImage(named: "Icon.png"))
            imageView.contentMode = .center
            return imageView
        case "IASKCustomHeaderStyle":
            let label = UILabel()
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.textColor = .red
            label.shadowColor = .white
            label.shadowOffset = CGSize(width: 0, height: 1)
            label.numberOfLines = 0
            label.font = .boldSystemFont(ofSize: 16)
            label.text = settingsViewController.settingsReader?.title(forSection: section)
            return label
        default:
            return nil
        }
    }

}

#Preview {
    Tabs()
}
