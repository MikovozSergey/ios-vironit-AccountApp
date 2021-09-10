import RxCocoa
import RxSwift
import UIKit

struct WelcomeInput {
    let loginEvent: ControlEvent<Void>
    let registrationEvent: ControlEvent<Void>
}

struct WelcomeOutput {
    let disposable: Disposable
}

class WelcomeViewModel: AppStepper {
    
    public func bind(input: WelcomeInput) -> WelcomeOutput {
        let loginDisposable = input.loginEvent.subscribe(onNext: { _ in
            self.steps.accept(AuthStep.loginStep)
        })
        
        let registrationDisposable = input.registrationEvent.subscribe(onNext: { _ in
            self.steps.accept(AuthStep.registrationStep)
        })
        return WelcomeOutput(disposable: Disposables.create(loginDisposable, registrationDisposable))
    }
}
