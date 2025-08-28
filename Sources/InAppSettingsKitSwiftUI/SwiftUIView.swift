import SwiftUI
import InAppSettingsKit

@available(iOS 13.0, *)
public struct IASKView: UIViewControllerRepresentable {
    private var showDoneButton: Bool?
    public let viewController = IASKAppSettingsViewController()
    private var delegate: IASKSettingsDelegate?

    public init(
        showDoneButton: Bool? = nil,
        buttonTapped: ((IASKSpecifier) -> Void)? = nil,
        @ViewBuilder header: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() },
        @ViewBuilder footer: @escaping (Int, IASKSpecifier) -> any View = { _, _ in EmptyView() }
    ) {
        self.init(showDoneButton: showDoneButton)
        delegate = SettingsDelegate(header: header, footer: footer, buttonTapped: buttonTapped)
    }

    public init(showDoneButton: Bool? = nil, delegate: IASKSettingsDelegate) {
        self.init(showDoneButton: showDoneButton)
        self.delegate = delegate
    }

    public init(showDoneButton: Bool? = nil) {
        self.showDoneButton = showDoneButton
        if let showDoneButton {
            viewController.showDoneButton = showDoneButton
        }
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        viewController.delegate = delegate
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
        viewForHeaderInSection?(section, specifier).ui?.height(for: settingsViewController.tableView.bounds.width) ?? 0
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, heightForFooterInSection section: Int, specifier: IASKSpecifier) -> CGFloat {
        viewForFooterInSection?(section, specifier).ui?.height(for: settingsViewController.tableView.bounds.width) ?? 0
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForHeaderInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        viewForHeaderInSection?(section, specifier).ui
    }

    func settingsViewController(_ settingsViewController: any UITableViewController & IASKViewController, viewForFooterInSection section: Int, specifier: IASKSpecifier) -> UIView? {
        viewForFooterInSection?(section, specifier).ui
    }
}

@available(iOS 13.0, *)
extension View {
    var ui: UIView? {
        let view = UIHostingController(rootView: self).view
        view?.backgroundColor = .clear
        return view
    }
}

extension UIView {
    func height(for width: CGFloat) -> CGFloat {
        systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
}
