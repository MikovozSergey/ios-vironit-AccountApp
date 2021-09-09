import RxFlow
import RxSwift
import RxCocoa
import UIKit

class FirstFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FirstStep else { return .none }

        switch step {
        case .initialStep:
            return navigateToFirstScreen()
        }
    }
    
    private func navigateToFirstScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "FirstScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "FirstViewController") as? FirstViewController else { return .none }
        self.rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.gold]
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SettingsStep.initialStep)))
    }
}
