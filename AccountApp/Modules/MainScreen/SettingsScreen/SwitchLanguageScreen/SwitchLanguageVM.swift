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
                self.tryAppSettings()
            } else {
                self.resetSettings()
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
            }
        }
        )
        return SwitchLanguageOutput(disposable: switchDisposable)
    }
    
    private func tryAppSettings() {
        
        AppSettings.shared.language = "ru"
        
        if AppSettings.shared.update() {
            if let dictionary = AppSettings.shared.toDictionary() {
                print(dictionary.compactMapValues { $0 })
            }
        }
    }
    
    private func resetSettings() {
        
        AppSettings.shared.language = "en"
        
        if AppSettings.shared.update() {
            if let dictionary = AppSettings.shared.toDictionary() {
                print(dictionary.compactMapValues { $0 })
            }
        }    }
}
