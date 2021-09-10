import RxCocoa
import RxSwift
import UIKit

struct SwitchThemeInput {
    let switchEvent: ControlEvent<Bool>
}

struct SwitchThemeOutput {
    let switchThemeState: Observable<Bool>
    let disposable: Disposable
}

class SwitchThemeViewModel: AppStepper {
    
    private let switchThemeState = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "DarkTheme"))

    public func bind(input: SwitchThemeInput) -> SwitchThemeOutput {
        let switchDisposable = input.switchEvent.subscribe(onNext: { [weak self] value in
            self?.switchThemeState.accept(value)
            UserDefaults.standard.set(value, forKey: "DarkTheme")
            }
        )
        return SwitchThemeOutput(switchThemeState: switchThemeState.asObservable(), disposable: switchDisposable)
    }
}
