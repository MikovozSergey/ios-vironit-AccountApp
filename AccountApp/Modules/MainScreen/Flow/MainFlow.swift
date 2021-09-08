import Foundation
import UIKit
import RxFlow

class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .mainStep:
            return navigateToMain()
        case .logoutStep:
            return .end(forwardToParentFlowWithStep: step)
        default:
            return .none
        }
        
    }

    private func navigateToMain() -> FlowContributors {

        let firstFlow = FirstFlow()
        let listOfAccountsFlow = ListOfAccountsFlow()
        let settingsFlow = SettingsFlow()

        Flows.use(firstFlow, listOfAccountsFlow, settingsFlow, when: .created) { [unowned self] (firstRoot: UINavigationController, listOfAccountsRoot: UINavigationController, settingsRoot: UINavigationController) in
            
            let firstTabBar = UITabBarItem(title: L10n.empty, image: nil, selectedImage: nil)
        //    firstTabBar.barTintColor = Theme.currentTheme.backgroundColor
            let listOfAccountsTabBar = UITabBarItem(title: L10n.list, image: nil, selectedImage: nil)
            let settingsTabBar = UITabBarItem(title: L10n.settings, image: nil, selectedImage: nil)
            firstRoot.tabBarItem = firstTabBar
            listOfAccountsRoot.tabBarItem = listOfAccountsTabBar
            settingsRoot.tabBarItem = settingsTabBar

            self.rootViewController.setViewControllers([firstRoot, listOfAccountsRoot, settingsRoot], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: firstFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FirstStep.initialStep)),
                                            .contribute(withNextPresentable: listOfAccountsFlow,
                                                        withNextStepper: OneStepper(withSingleStep: ListOfAccountsStep.initialStep)),
                                            .contribute(withNextPresentable: settingsFlow,
                                                        withNextStepper: OneStepper(withSingleStep: SettingsStep.initialStep))])
    }
}
