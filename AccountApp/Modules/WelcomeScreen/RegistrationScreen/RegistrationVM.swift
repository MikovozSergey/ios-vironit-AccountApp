import RxCocoa
import RxSwift
import UIKit

struct RegistrationInput {
    let saveEvent: ControlEvent<Void>
    let loginText: Driver<String?>
    let passwordText: Driver<String?>
}

struct RegistrationOutput {
    let registrationState: Driver<RegistrationState>
    let disposable: Disposable
}

public enum RegistrationState {
    case allIsGood(user: User)
    case emptyFields
    case invalidValidation
}


class RegistrationViewModel {
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let registrationState = BehaviorRelay<RegistrationState>(value: .emptyFields)
    private let disposeBag = DisposeBag()
    private var state: RegistrationState {
        let loginValue = self.loginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        switch (ValidationManager.isValidLogin(login: self.loginValue), ValidationManager.isValidPassword(password: self.passwordValue)) {
        case (true, true):
            return .allIsGood(user: User(login: loginValue, password: passwordValue))
        default:
            return loginValue.isEmpty && passwordValue.isEmpty ? .emptyFields : .invalidValidation
        }
    }
    
    public func bind(input: RegistrationInput) -> RegistrationOutput {
        let disposable = Disposables.create(
            input.loginText.drive(self.loginValue),
            input.passwordText.drive(self.passwordValue),
            input.saveEvent.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.registrationState.accept(self.state)
                }
            )
        )
        return RegistrationOutput(registrationState: registrationState.asDriver(), disposable: disposable)
    }
}
