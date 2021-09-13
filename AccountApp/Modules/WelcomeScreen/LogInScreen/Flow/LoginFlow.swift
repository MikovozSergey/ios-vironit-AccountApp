import Foundation
import UIKit
import RxFlow

class LoginFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()
    let viewModel = LoginViewModel()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        print("Step = \(step)")
        
        if let step = step as? LoginStep {
            switch step {
            case .initialStep:
                return navigateToLogin()
            case .completeStep:
                return .end(forwardToParentFlowWithStep: AuthStep.completeStep)
            case .backStep:
                return .end(forwardToParentFlowWithStep: AuthStep.backStep)
            }
        }
        return .none
    }
    
    private func navigateToLogin() -> FlowContributors {
        let storyboard = UIStoryboard(name: "LogInScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else { return .none }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
        backButton.image = UIImage(named: "iconBack")
        vc.navigationItem.leftBarButtonItem = backButton
        vc.configure(viewModel: viewModel)
        self.rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.gold]
        self.rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc,
                                                 withNextStepper: viewModel))
    }
    
    @objc func backAction() {
        viewModel.steps.accept(LoginStep.backStep)
    }
}
