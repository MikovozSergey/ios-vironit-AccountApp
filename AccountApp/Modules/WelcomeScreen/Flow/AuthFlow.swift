import Foundation
import UIKit
import RxFlow

class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        print("Step = \(step)")
        
        if let step = step as? AuthStep {
            switch step {
            case .initialStep:
                return navigateToWelcome()
            case .loginStep:
                return navigateToLogin()
            case .registrationStep:
                return navigateToRegistration()
            case .completeStep:
                return .end(forwardToParentFlowWithStep: AppStep.mainStep)
            case .backStep:
                rootViewController.dismiss(animated: true, completion: nil)
                return .none
            }
        }
        return .none
    }

    private func navigateToWelcome() -> FlowContributors {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "WelcomeViewController") as? WelcomeViewController else { return .none }
        let viewModel = WelcomeViewModel()
        vc.configure(viewModel: viewModel)
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let loginFlow = LoginFlow(isLogin: true)
        Flows.use(loginFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.present(flowRoot, animated: true, presentationStyle: .fullScreen)
        })
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: loginFlow,
                                                                withNextStepper: OneStepper(withSingleStep: LoginStep.initialStep)))
    }
    
    private func navigateToRegistration() -> FlowContributors {
        let registrationFlow = RegistrationFlow(isLogin: false)
        Flows.use(registrationFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootViewController.present(flowRoot, animated: true, presentationStyle: .fullScreen)
        })
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: registrationFlow,
                                                                withNextStepper: OneStepper(withSingleStep: RegistrationStep.initialStep)))
    }
}
