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
            let language = AppSettings.shared.language
            if language == Language.english.languageShort {
                self.tryAppSettings(language: Language.russian.languageShort)
            } else {
                self.tryAppSettings(language: Language.english.languageShort)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
            }
        }
        )
        return SwitchLanguageOutput(disposable: switchDisposable)
    }
    
    private func tryAppSettings(language: String) {
        
        AppSettings.shared.language = language
        
        if AppSettings.shared.update() {
            if let dictionary = AppSettings.shared.toDictionary() {
                print(dictionary.compactMapValues { $0 })
            }
        }
    }
}
