import RxFlow
import RxSwift
import RxCocoa
import UIKit

class WalkthroughFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let viewModel = WalkthroughViewModel()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? WalkthroughStep else { return .none }

        switch step {
        case .initialStep:
            return navigateToWalkthroughScreen()
        case .skipStep:
            return .end(forwardToParentFlowWithStep: SettingsStep.backStep)
        }
    }

    private func navigateToWalkthroughScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "WalkthroughScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController else { return .none }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: L10n.skip, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
        viewController.navigationItem.leftBarButtonItem = backButton
        viewController.configure(viewModel: viewModel)
        self.rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.gold]
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    @objc func backAction() {
        viewModel.steps.accept(WalkthroughStep.skipStep)
    }
}
