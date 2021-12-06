import RxCocoa
import RxSwift
import UIKit

struct CellOutput {
    let mainEvent: ControlEvent<Void>
}

struct SettingsInput {
    let changeLanguage: ControlEvent<Void>
    let changeTheme: ControlEvent<Void>
    let showWalkthrough: ControlEvent<Void>
}

struct SettingsOutput {
    let disposable: Disposable
}

class SettingsViewModel: AppStepper {
    
    public func bind(input: SettingsInput) -> SettingsOutput {
        let changeLanguageDisposable = input.changeLanguage.subscribe(onNext: { _ in
            self.steps.accept(SettingsStep.changeLanguageStep)
        })
        
        let changeThemeDisposable = input.changeTheme.subscribe(onNext: { _ in
            self.steps.accept(SettingsStep.changeThemeStep)
        })
        
        let showWalkthroughDisposable = input.showWalkthrough.subscribe { _ in
            self.steps.accept(SettingsStep.showWalkthroughStep)
        }
        
        return SettingsOutput(disposable: Disposables.create(changeLanguageDisposable, changeThemeDisposable, showWalkthroughDisposable))
    }
}
