import Foundation
import UIKit
import RxFlow

class RegistrationFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UINavigationController()
    let viewModel = RegistrationViewModel()
    
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
        let storyboard = UIStoryboard(name: "RegistrationScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return .none }
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
        viewModel.steps.accept(RegistrationStep.backStep)
    }
}
