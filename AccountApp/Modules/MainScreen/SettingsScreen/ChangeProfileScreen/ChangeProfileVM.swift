import RxCocoa
import RxSwift
import UIKit

struct ChangeProfileInput {
    let saveEvent: ControlEvent<Void>
    let loginText: Driver<String?>
    let newLoginText: Driver<String?>
    let passwordText: Driver<String?>
    let newPasswordText: Driver<String?>
}

struct ChangeProfileOutput {
    let changeProfileState: Driver<ChangeProfileState>
    let disposable: Disposable
}

public enum ChangeProfileState {
    case allIsGood(user: User)
    case emptyFields
    case invalidValidation
}

class ChangeProfileViewModel: AppStepper {
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let newLoginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let newPasswordValue = BehaviorRelay<String?>(value: "")
    private let changeProfileState = BehaviorRelay<ChangeProfileState>(value: .emptyFields)
    private var state: ChangeProfileState {
        let loginValue = self.loginValue.value ?? ""
        let newLoginValue = self.newLoginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        let newPasswordValue = self.newPasswordValue.value ?? ""
        switch (ValidationManager.isValidLogin(login: self.loginValue), ValidationManager.isValidPassword(password: self.passwordValue), ValidationManager.isValidLogin(login: self.newLoginValue), ValidationManager.isValidPassword(password: self.newPasswordValue)) {
        case (true, true, true, true):
            return .allIsGood(user: User(login: loginValue, password: passwordValue))
        default:
            return loginValue.isEmpty || passwordValue.isEmpty || newLoginValue.isEmpty || newPasswordValue.isEmpty ? .emptyFields : .invalidValidation
        }
    }
    
    public func bind(input: ChangeProfileInput) -> ChangeProfileOutput {
        let disposable = Disposables.create(
            input.loginText.drive(self.loginValue),
            input.passwordText.drive(self.passwordValue),
            input.newLoginText.drive(self.newLoginValue),
            input.newPasswordText.drive(self.newPasswordValue),
            input.saveEvent.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.changeProfileState.accept(self.state)
                }
            )
        )
        return ChangeProfileOutput(changeProfileState: changeProfileState.asDriver(), disposable: disposable)
    }
}
