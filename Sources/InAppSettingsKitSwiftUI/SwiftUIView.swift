import SwiftUI
import InAppSettingsKit

@available(iOS 13.0, *)
public struct IASKView<HeaderFooter: View>: UIViewControllerRepresentable {
    private var showDoneButton: Bool?
    public let viewController = IASKAppSettingsViewController()
    private let delegate: SettingsDelegate<HeaderFooter>?

    public init(
        showDoneButton: Bool? = nil,
        delegate: IASKSettingsDelegate? = nil,
        header: ((IASKSpecifier) -> HeaderFooter)? = nil,
        footer: ((IASKSpecifier) -> HeaderFooter)? = nil
    ) {
        self.showDoneButton = showDoneButton
        if let delegate {
            viewController.delegate = delegate
            self.delegate = nil
            if header != nil || footer != nil {
                assertionFailure("When you specify a delegate, header or footer will be ignored and need to be implemented via the delegate methods.")
            }
        } else {
            self.delegate = SettingsDelegate(header: header, footer: footer)
            viewController.delegate = self.delegate
        }
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

@available(iOS 13.0, *)
class SettingsDelegate<HeaderFooter: View>: NSObject, IASKSettingsDelegate {
    let viewForFooter: ((IASKSpecifier) -> HeaderFooter)?
    let viewForHeader: ((IASKSpecifier) -> HeaderFooter)?

    init(header: ((IASKSpecifier) -> HeaderFooter)?, footer: ((IASKSpecifier) -> HeaderFooter)?) {
        self.viewForFooter = footer
        self.viewForHeader = header
    }

    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) {
        settingsViewController.dismiss(animated: true)
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, heightForHeaderInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        settingsViewController.tableView.rowHeight
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, heightForFooterInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        settingsViewController.tableView.rowHeight
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForHeaderInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        guard let header = viewForHeader?(specifier) else { return UIView() }
        return UIHostingController(rootView: header).view
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForFooterInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        guard let footer = viewForFooter?(specifier) else { return UIView() }
        return UIHostingController(rootView: footer).view
    }
}
