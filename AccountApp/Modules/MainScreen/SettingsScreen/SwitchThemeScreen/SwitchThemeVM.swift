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
    private let switchThemeState = BehaviorRelay<Bool>(value: AppSettings.shared.darkTheme)

    public func bind(input: SwitchThemeInput) -> SwitchThemeOutput {
        let switchDisposable = input.switchEvent.subscribe(onNext: { [weak self] value in
            self?.switchThemeState.accept(value)
            self?.tryAppSettings(value: value)
            }
        )
        return SwitchThemeOutput(switchThemeState: switchThemeState.asObservable(), disposable: switchDisposable)
    }
    
    private func tryAppSettings(value: Bool) {
        AppSettings.shared.darkTheme = value
        if AppSettings.shared.update() {
            if let dictionary = AppSettings.shared.toDictionary() {
                print(dictionary.compactMapValues { $0 })
            }
        }
    }
}
