import RxFlow
import RxSwift
import RxCocoa
import UIKit

class SettingsFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingsStep else { return .none }
        
        switch step {
        case .initialStep:
            return navigateToSettingsScreen()
        case .changeLanguageStep:
            return navigateToChangeLanguageScreen()
        case .changeUserNameAndPasswordStep:
            return navigateToChangeUserNameAndPasswordScreen()
        case .logoutStep:
            return .end(forwardToParentFlowWithStep: AppStep.logoutStep)
        case .changeThemeStep:
            return navigateToChangeThemeScreen()
        case .backStep:
            rootViewController.dismiss(animated: true, completion: nil)
            return .none
        }
    }

    private func navigateToSettingsScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "SettingsScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return .none }
        let viewModel = SettingsViewModel()
        vc.configure(viewModel: viewModel)
        self.rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.gold]
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToChangeLanguageScreen() -> FlowContributors {
        let switchLanguageFlow = SwitchLanguageFlow()
        Flows.use(switchLanguageFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.present(flowRoot, animated: true, presentationStyle: .fullScreen)
        })
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: switchLanguageFlow,
                                                                withNextStepper: OneStepper(withSingleStep: SwitchLanguageStep.initialStep)))
    }
    
    private func navigateToChangeUserNameAndPasswordScreen() -> FlowContributors {
        let changeProfileFlow = ChangeProfileFlow()
        Flows.use(changeProfileFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.present(flowRoot, animated: true, presentationStyle: .fullScreen)
        })
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: changeProfileFlow,
                                                                withNextStepper: OneStepper(withSingleStep: ChangeProfileStep.initialStep)))
    }
    
    private func navigateToChangeThemeScreen() -> FlowContributors {
        let switchThemeFlow = SwitchThemeFlow()
        Flows.use(switchThemeFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.present(flowRoot, animated: true, presentationStyle: .fullScreen)
        })
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: switchThemeFlow,
                                                                withNextStepper: OneStepper(withSingleStep: SwitchThemeStep.initialStep)))
    }
}
