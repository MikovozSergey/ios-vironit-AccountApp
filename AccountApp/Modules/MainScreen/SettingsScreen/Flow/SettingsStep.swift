import RxFlow

enum SettingsStep: Step {
    case initialStep
    case changeUserNameAndPasswordStep
    case changeLanguageStep
    case logoutStep
    case changeThemeStep
    case backStep
}
