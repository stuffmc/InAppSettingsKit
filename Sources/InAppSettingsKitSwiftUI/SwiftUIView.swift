import SwiftUI
import InAppSettingsKit

@available(iOS 13.0, *)
public struct IASKView: UIViewControllerRepresentable {
    private var showDoneButton: Bool?
    public let viewController = IASKAppSettingsViewController()
    private var delegate: SettingsDelegate?

    public init(
        showDoneButton: Bool? = nil,
        buttonTapped: ((IASKSpecifier) -> Void)? = nil,
        @ViewBuilder header: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() },
        @ViewBuilder footer: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() }
    ) {
        self.init(showDoneButton: showDoneButton)
        delegate = SettingsDelegate(header: header, footer: footer, buttonTapped: buttonTapped)
        viewController.delegate = delegate
    }

    public init(showDoneButton: Bool? = nil, delegate: IASKSettingsDelegate) {
        self.init(showDoneButton: showDoneButton)
        viewController.delegate = delegate
    }

    public init(showDoneButton: Bool? = nil) {
        self.showDoneButton = showDoneButton
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
class SettingsDelegate: NSObject, IASKSettingsDelegate {
    let viewForHeaderInSection: ((Int, IASKSpecifier) -> any View)?
    let viewForFooterInSection: ((Int, IASKSpecifier) -> any View)?
    let buttonTapped: ((IASKSpecifier) -> Void)?

    init(
        @ViewBuilder header: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() },
        @ViewBuilder footer: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() },
        buttonTapped: ((IASKSpecifier) -> Void)?
    ) {
        self.viewForFooterInSection = footer
        self.viewForHeaderInSection = header
        self.buttonTapped = buttonTapped
    }

    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) {
        settingsViewController.dismiss(animated: true)
    }

    func settingsViewController(_: IASKAppSettingsViewController, buttonTappedFor specifier: IASKSpecifier) {
        buttonTapped?(specifier)
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, heightForHeaderInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        settingsViewController.tableView.rowHeight
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, heightForFooterInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        settingsViewController.tableView.rowHeight
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForHeaderInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        guard let header = viewForHeaderInSection?(section, specifier) else { return UIView() }
        if header is EmptyView { return nil }
        return UIHostingController(rootView: AnyView(header)).view
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForFooterInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        guard let footer = viewForFooterInSection?(section, specifier) else { return UIView() }
        if footer is EmptyView { return nil }
        return UIHostingController(rootView: AnyView(footer)).view
    }
}
