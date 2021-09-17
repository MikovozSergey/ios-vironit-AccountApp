import Foundation
import UIKit
import RxFlow

class RegistrationFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()
    let isLogin: Bool
    let viewModel = RegistrationViewModel()
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        print("Step = \(step)")
        
        if let step = step as? RegistrationStep {
            switch step {
            case .initialStep:
                return navigateToRegistration()
            case .completeStep:
                return .end(forwardToParentFlowWithStep: AuthStep.completeStep)
            case .backStep:
                return .end(forwardToParentFlowWithStep: AuthStep.backStep)
            }
        }
        
        return .none
    }
    
    private func navigateToRegistration() -> FlowContributors {
        let storyboard = UIStoryboard(name: "LogInScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else { return .none }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
        backButton.image = UIImage(named: "iconBack")
        vc.navigationItem.leftBarButtonItem = backButton
        vc.configure(registrationVM: viewModel, isLogin: false)
        self.rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.gold]
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    @objc func backAction() {
        viewModel.steps.accept(RegistrationStep.backStep)
    }
}
