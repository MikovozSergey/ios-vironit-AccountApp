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
    case loginAlreadyExists
}

class RegistrationViewModel: AppStepper {
    
    private let dataBase = DataBase()
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let registrationState = BehaviorRelay<RegistrationState>(value: .emptyFields)
    private var state: RegistrationState {
        dataBase.fetchData()
        let loginValue = self.loginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        switch (ValidationManager.isValidLogin(login: self.loginValue), ValidationManager.isValidPassword(password: self.passwordValue), isLoginAlreadyExitsts(login: loginValue)) {
        case (true, true, false):
            return .allIsGood(user: User(login: loginValue, password: passwordValue))
        case (true, true, true):
            return .loginAlreadyExists
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
    
    private func isLoginAlreadyExitsts(login: String) -> Bool {
        if self.dataBase.arrayOfLogins.contains(login) {
            return true
        }
        return false
    }
}
