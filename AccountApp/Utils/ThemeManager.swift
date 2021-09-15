import SkyFloatingLabelTextField
import UIKit

final public class ThemeManager {

    static func setupThemeForNavigationAndView(navigation: UINavigationController, view: UIView) {
        navigation.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        navigation.navigationBar.isTranslucent = false
        navigation.view.tintColor = Colors.gold
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    static func setupThemeForSwitchAndTableView(themeSwitch: UISwitch? = nil, tableView: UITableView? = nil) {
        themeSwitch?.tintColor = Theme.currentTheme.accentColor
        themeSwitch?.onTintColor = Theme.currentTheme.accentColor
        tableView?.backgroundColor = Theme.currentTheme.backgroundColor
        tableView?.separatorColor = Theme.currentTheme.separatorColor
        tableView?.layoutMargins = UIEdgeInsets.zero
        tableView?.separatorInset = UIEdgeInsets.zero
    }
    
    static func setupThemeForTextFields(loginTextField: SkyFloatingLabelTextField, passwordTextField: SkyFloatingLabelTextField, newLoginTextField: SkyFloatingLabelTextField? = nil, newPasswordTextField: SkyFloatingLabelTextField? = nil) {
        [loginTextField, passwordTextField, newLoginTextField, newPasswordTextField].forEach {
            $0?.textColor = Theme.currentTheme.textColor
        }
    }
    
    static func setupThemeForLabels(changeThemeLabel: UILabel? = nil, switchLanguageLabel: UILabel? = nil) {
        [changeThemeLabel, switchLanguageLabel].forEach {
            $0?.textColor = Theme.currentTheme.textColor
        }
    }
    
    static func setupThemeForButtons(logInButton: UIButton? = nil, registrationButton: UIButton? = nil, saveButton: UIButton? = nil, switchLanguageButton: UIButton? = nil, changeLanguageButton: UIButton? = nil, changeThemeButton: UIButton? = nil) {
        [logInButton, registrationButton, saveButton, changeLanguageButton, changeThemeButton, switchLanguageButton].forEach {
            $0?.setTitleColor(Theme.currentTheme.textColor, for: .normal)
        }
    }
    
    static func setupThemeForSearchBar(searchBar: UISearchBar) {
        searchBar.barTintColor = Theme.currentTheme.backgroundColor
        searchBar.setImage(Theme.currentTheme.searchImage, for: UISearchBar.Icon.search, state: UIControl.State.normal)
        searchBar.setImage(Theme.currentTheme.crossImage, for: UISearchBar.Icon.clear, state: UIControl.State.normal)
        searchBar.tintColor = Colors.gold
        searchBar.searchTextField.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = true
        let textFieldInSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInSearchBar?.backgroundColor = Theme.currentTheme.backgroundColor
        textFieldInSearchBar?.textColor = Theme.currentTheme.textColor
        textFieldInSearchBar?.layer.borderWidth = 1.5
        textFieldInSearchBar?.layer.cornerRadius = 10
        textFieldInSearchBar?.layer.borderColor = Theme.currentTheme.textColor.cgColor
    }
}
