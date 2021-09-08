import RxFlow
import RxSwift
import RxCocoa
import UIKit

class ListOfAccountsFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ListOfAccountsStep else { return .none }

        switch step {
        case .initialStep:
            return navigateToListOfAccountsScreen()
        }
    }

    private func navigateToListOfAccountsScreen() -> FlowContributors {
        let storyboard = UIStoryboard(name: "ListOfAccountsScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "ListOfAccountsViewController") as? ListOfAccountsViewController else { return .none }
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SettingsStep.initialStep)))
    }
}
