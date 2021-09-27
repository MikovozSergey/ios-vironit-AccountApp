import Foundation
import RxSwift
import RxFlow
import RxCocoa

public struct NoneStep: Step, Equatable {}

open class AppStepper: RxFlow.Stepper {

    public let steps: PublishRelay<Step>
    private let sessionManager = SessionManager()

    public init() {
        steps = PublishRelay()
    }

    open var initialStep: Step {
        if UserDefaults.standard.object(forKey: "timeOfStartSession") == nil {
            return AppStep.authStep
        }
        if sessionManager.isEndOfSession(startOfSession: sessionManager.getStartOfSession()) {
            return AppStep.authStep
        } else {
            return AppStep.mainStep
        }
    }

    public func readyToEmitSteps() {
        guard (initialStep is NoneStep) else { return }
        self.steps.accept(initialStep)
    }

}
