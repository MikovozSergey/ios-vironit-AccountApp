import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    var root: Presentable {
        return self.rootWindow
    }

    private var transition: CATransition {
        let transition = CATransition()
        transition.type = .fade
        return transition
    }
    
    private let rootWindow: UIWindow
    
//    private lazy var rootViewController: UINavigationController = {
//        let viewController = UINavigationController()
//        viewController.setNavigationBarHidden(true, animated: false)
//        return viewController
//    }()
    
    init(window: UIWindow) {
        self.rootWindow = window
        if let defaultVC = UIStoryboard.init(name: "LaunchScreen", bundle: Bundle.main).instantiateInitialViewController() {
            self.rootWindow.rootViewController = defaultVC
        }
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .mainStep:
            return navigationToTabBar()
        case .authStep, .logoutStep:
            return navigateToWelcomeScreen()
        }
    }
    
    private func navigationToTabBar() -> FlowContributors {
        
        let mainFlow = MainFlow()
        let sessionManager = SessionManager()
        sessionManager.startTimer()
        Flows.use(mainFlow, when: .ready, block: { [weak self] flowRoot in
            guard let self = self else { return }
            self.rootWindow.set(rootViewController: flowRoot, withTransition: self.transition)
        })
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.mainStep)))
    }

    private func navigateToWelcomeScreen() -> FlowContributors {

        let authFlow = AuthFlow()

        Flows.use(authFlow, when: .created) { [weak self] root in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.rootWindow.set(rootViewController: root, withTransition: self.transition)
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: authFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AuthStep.initialStep)))
    }
}
