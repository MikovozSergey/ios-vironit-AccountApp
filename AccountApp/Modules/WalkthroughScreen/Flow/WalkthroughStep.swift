import RxFlow

enum WalkthroughStep: Step {
    case initialStepAfterSettings
    case initialStepAfterRegistration
    case skipStepForSettings
    case skipStepForRegistration
}
