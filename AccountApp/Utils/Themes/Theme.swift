import UIKit

public protocol ThemeProtocol {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var accentColor: UIColor { get }
    var separatorColor: UIColor { get }
    var questionImage: UIImage { get }
    var searchImage: UIImage { get }
    var crossImage: UIImage { get }
}

class Theme {
    static var currentTheme: ThemeProtocol = LightTheme()
}
