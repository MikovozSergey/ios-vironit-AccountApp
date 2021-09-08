import RxFlow
import RxSwift
import RxCocoa
import UIKit

class ChangeProfileFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let viewModel = ChangeProfileViewModel()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ChangeProfileStep else { return .none }

        switch step {
        case .initialStep:
            return navigateToChangeProfileScreen()
        case .backStep:
            return .end(forwardToParentFlowWithStep: SettingsStep.backStep)
        }
    }

    private func navigateToChangeProfileScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "ChangeProfileScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ChangeProfileViewController") as? ChangeProfileViewController else { return .none }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: L10n.back, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
        vc.navigationItem.leftBarButtonItem = backButton
        vc.configure(viewModel: viewModel)
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    @objc func backAction() {
        viewModel.steps.accept(ChangeProfileStep.backStep)
    }
}
