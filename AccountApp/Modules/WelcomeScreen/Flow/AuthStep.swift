import RxFlow

enum AuthStep: Step {
    case initialStep
    case loginStep
    case registrationStep
    case completeStep
    case backStep
}
