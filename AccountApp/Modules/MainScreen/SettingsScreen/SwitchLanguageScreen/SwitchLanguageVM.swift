import RxCocoa
import RxSwift
import UIKit

struct SwitchLanguageInput {
    let switchEvent: ControlEvent<Void>
}

struct SwitchLanguageOutput {
    let disposable: Disposable
}

class SwitchLanguageViewModel: AppStepper {
    
    public func bind(input: SwitchLanguageInput) -> SwitchLanguageOutput {
        let switchDisposable = input.switchEvent.subscribe(onNext: { _ in
            let language = UserDefaults.standard.string(forKey: kLanguageApplication)
            if language ==  Language.english.languageShort {
                UserDefaults.standard.set(Language.russian.languageShort, forKey: kLanguageApplication)
                L10n.bundle = Bundle(path: Bundle.main.path(forResource: "ru", ofType: "lproj")!)
            } else {
                UserDefaults.standard.set(Language.english.languageShort, forKey: kLanguageApplication)
                L10n.bundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
            }
        }
        )
        return SwitchLanguageOutput(disposable: switchDisposable)
    }
}
