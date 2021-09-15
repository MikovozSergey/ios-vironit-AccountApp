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

        Flows.use(firstFlow, listOfAccountsFlow, settingsFlow, when: .ready) { [unowned self] (firstRoot: UINavigationController, listOfAccountsRoot: UINavigationController, settingsRoot: UINavigationController) in
            
            let firstTabBar = UITabBarItem(title: nil, image: UIImage(named: "iconEmpty"), selectedImage: nil)
            firstTabBar.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
            let listOfAccountsTabBar = UITabBarItem(title: nil, image: UIImage(named: "iconList"), selectedImage: nil)
            listOfAccountsTabBar.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
            let settingsTabBar = UITabBarItem(title: nil, image: UIImage(named: "iconSettings"), selectedImage: nil)
            settingsTabBar.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
            firstRoot.tabBarItem = firstTabBar
            listOfAccountsRoot.tabBarItem = listOfAccountsTabBar
            settingsRoot.tabBarItem = settingsTabBar
            let topline = CALayer()
            topline.frame = CGRect(x: 0, y: 0, width: self.rootViewController.tabBar.frame.width, height: 1)
            topline.backgroundColor = UIColor(named: "separatorTabBarColor")?.cgColor
            self.rootViewController.tabBar.layer.addSublayer(topline)
            self.rootViewController.tabBar.isTranslucent = false
            self.rootViewController.tabBar.tintColor = Colors.gold
            self.rootViewController.tabBar.barTintColor = Theme.currentTheme.backgroundColor
            self.rootViewController.setViewControllers([firstRoot, listOfAccountsRoot, settingsRoot], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: firstFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FirstStep.initialStep)),
                                            .contribute(withNextPresentable: listOfAccountsFlow,
                                                        withNextStepper: OneStepper(withSingleStep: ListOfAccountsStep.initialStep)),
                                            .contribute(withNextPresentable: settingsFlow,
                                                        withNextStepper: OneStepper(withSingleStep: SettingsStep.initialStep))])
    }
    
    public func returnRootViewController() -> UITabBarController {
        return self.rootViewController
    }
}
