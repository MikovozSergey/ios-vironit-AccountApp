import UIKit

class DarkTheme: ThemeProtocol {
    var backgroundColor: UIColor = UIColor(named: "backgroundDarkColor")!
    var textColor: UIColor = UIColor(named: "textLightColor")!
    var separatorColor: UIColor = UIColor(named: "separatorLightColor")!
    var accentColor: UIColor = UIColor(named: "accentLightColor")!
    var questionImage: UIImage = UIImage(named: "iconQuestionLight")!
    var searchImage: UIImage = UIImage(named: "iconSearchDark")!
    var crossImage: UIImage = UIImage(named: "iconCrossDark")!
}
