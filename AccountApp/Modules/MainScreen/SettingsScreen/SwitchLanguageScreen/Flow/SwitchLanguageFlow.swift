import RxFlow
import RxSwift
import RxCocoa
import UIKit

class SwitchLanguageFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let viewModel = SwitchLanguageViewModel()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SwitchLanguageStep else { return .none }

        switch step {
        case .initialStep:
            return navigateToChangeLanguageScreen()
        case .backStep:
            return .end(forwardToParentFlowWithStep: SettingsStep.backStep)
        }
    }

    private func navigateToChangeLanguageScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "SwitchLanguageScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "SwitchLanguageViewController") as? SwitchLanguageViewController else { return .none }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: viewModel.titleForNavigation, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
        vc.navigationItem.leftBarButtonItem = backButton
        vc.configure(viewModel: viewModel)
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    @objc func backAction() {
        viewModel.steps.accept(SwitchLanguageStep.backStep)
    }
}
