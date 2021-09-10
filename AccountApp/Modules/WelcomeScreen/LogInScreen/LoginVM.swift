import RxCocoa
import RxSwift
import UIKit

struct LoginInput {
    let logInEvent: ControlEvent<Void>
    let loginText: Driver<String?>
    let passwordText: Driver<String?>
}

struct LoginOutput {
    let loginState: Driver<LoginState>
    let disposable: Disposable
}

public enum LoginState {
    case allIsGood(user: User)
    case emptyFields
    case invalidValidation
}

class LoginViewModel: AppStepper {
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let loginState = BehaviorRelay<LoginState>(value: .emptyFields)
    private var state: LoginState {
        let loginValue = self.loginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        switch (ValidationManager.isValidLogin(login: self.loginValue), ValidationManager.isValidPassword(password: self.passwordValue)) {
        case (true, true):
            return .allIsGood(user: User(login: loginValue, password: passwordValue))
        default:
            return loginValue.isEmpty || passwordValue.isEmpty ? .emptyFields : .invalidValidation
        }
    }
    
    public func bind(input: LoginInput) -> LoginOutput {
        let disposable = Disposables.create(
            input.loginText.drive(self.loginValue),
            input.passwordText.drive(self.passwordValue),
            input.logInEvent.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginState.accept(self.state)
                }
            )
        )
        return LoginOutput(loginState: loginState.asDriver(), disposable: disposable)
    }
}
