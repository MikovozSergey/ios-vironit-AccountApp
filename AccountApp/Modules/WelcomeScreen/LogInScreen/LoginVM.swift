import RxCocoa
import RxSwift
import UIKit
import KeychainSwift


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
    
    private let keychain = KeychainSwift()
    private let dataBase = DataBase()
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let loginState = BehaviorRelay<LoginState>(value: .emptyFields)
    private let disposeBag = DisposeBag()
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
                //self.loginState.accept(self.state)
                switch self.state {
                case .allIsGood(let user):
//                    if self.dataBase.arrayOfLogins.contains(user.login) && user.password == self.keychain.get(user.login) {
                        self.steps.accept(LoginStep.completeStep)
//                        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
//                        guard let viewController = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
//                        self.navigationController?.pushViewController(viewController, animated: true)
                 //   }
//                    else {
//                        self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorPasswordMessage)
//                    }
                case .emptyFields:
                    break
//                    self.setupStyleForTestFields(title: L10n.alertErrorTitle, titleColor: .red)
//                    self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorEmptyFieldsMessage)
                case .invalidValidation:
                    break
//                    self.setupStyleForTestFields(title: L10n.alertWrongTitle, titleColor: .red)
//                    self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertRecommendationForFieldsMessage)
                    }

                }
            )
        )
        return LoginOutput(loginState: loginState.asDriver(), disposable: disposable)
    }
}
