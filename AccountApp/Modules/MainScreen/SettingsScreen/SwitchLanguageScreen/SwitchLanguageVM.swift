import RxCocoa
import RxSwift
import UIKit

struct SwitchLanguageInput {
    let switchEvent: ControlEvent<Void>
}

struct SwitchLanguageOutput {
    let switchState: Driver<SwitchLanguageState>
    let disposable: Disposable
}

public enum SwitchLanguageState {
    case allIsGood
}

class SwitchLanguageViewModel {
    
    private let switchLanguageState = BehaviorRelay<SwitchLanguageState>(value: .allIsGood)
    private let disposeBag = DisposeBag()
    private var state: SwitchLanguageState {
        return .allIsGood
    }
    
    public func bind(input: SwitchLanguageInput) -> SwitchLanguageOutput {
        let disposable = Disposables.create {
            input.switchEvent.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.switchLanguageState.accept(self.state)
                }
            )
        }
        return SwitchLanguageOutput(switchState: switchLanguageState.asDriver(), disposable: disposable)
    }
}
