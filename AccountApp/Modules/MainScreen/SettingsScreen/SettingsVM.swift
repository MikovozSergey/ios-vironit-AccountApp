import RxCocoa
import RxSwift
import UIKit

struct SettingsInput {
    let logInEvent: ControlEvent<Void>
    let loginText: Driver<String?>
    let passwordText: Driver<String?>
}

struct SettingsOutput {
    let settingsState: Driver<SettingsState>
    let disposable: Disposable
}

public enum SettingsState {
    case allIsGood
    case emptyFields
    case invalidValidation
}

class SettingsViewModel {
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let settingsState = BehaviorRelay<SettingsState>(value: .emptyFields)
    private let disposeBag = DisposeBag()
    private var state: SettingsState {
        let loginValue = self.loginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        return .allIsGood
//        switch (isValidLogin(), isValidPassword()) {
//        case (true, true):
//            return .allIsGood(user: User(login: loginValue, password: passwordValue))
//        default:
//            return loginValue.isEmpty || passwordValue.isEmpty ? .emptyFields : .invalidValidation
//        }
    }
    
    public func bind(input: SettingsInput) -> SettingsOutput {
        let disposable = Disposables.create(
            input.loginText.drive(self.loginValue),
            input.passwordText.drive(self.passwordValue),
            input.logInEvent.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.settingsState.accept(self.state)
                }
            )
        )
        return SettingsOutput(settingsState: settingsState.asDriver(), disposable: disposable)
    }
}
