import RxCocoa
import RxSwift
import UIKit

class RegistrationViewModel {
    
    private let loginValue = BehaviorRelay<String?>(value: "")
    private let passwordValue = BehaviorRelay<String?>(value: "")
    private let registrationState = BehaviorRelay<RegistrationState>(value: .emptyFields)
    private let disposeBag = DisposeBag()
    private var state: RegistrationState {
        let loginValue = self.loginValue.value ?? ""
        let passwordValue = self.passwordValue.value ?? ""
        switch (isValidLogin(), isValidPassword()) {
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
    
    func isValidLogin() -> Bool {
        guard let login = loginValue.value, login.count >= 3 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[А-Яа-яA-Za-z])(?=.*\\d)[А-Яа-яA-Za-z\\d]{3,}$")
        return predicateTest.evaluate(with: login)
    }
    
    func isValidPassword() -> Bool {
        guard let password = passwordValue.value, password.count >= 8 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[а-яa-z])(?=.*[А-ЯA-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-яA-Za-z\\d$@$!%*?&#]{8,}$")
        return predicateTest.evaluate(with: password)
    }
    
    func validateLogin(_ text: Driver<String?>) -> Driver<Bool> {
        return text.compactMap { text in
            guard let text = text, text.count >= 3 else { return false }
            let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[А-Яа-яA-Za-z])(?=.*\\d)[А-Яа-яA-Za-z\\d]{3,}$")
            return predicateTest.evaluate(with: text)
        }
    }
    
    func validatePassword(_ text: Driver<String?>) -> Driver<Bool> {
        return text.compactMap { text in
            guard let text = text, text.count >= 8 else { return false }
            let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[а-яa-z])(?=.*[А-ЯA-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-яA-Za-z\\d$@$!%*?&#]{8,}$")
            return predicateTest.evaluate(with: text)
        }
    }
}

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

extension ObservableType {
    
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return map { _ in value }
    }
}

extension Observable {
    public func void() -> Observable<Void> {
        return self.mapTo(Void())
    }
}
