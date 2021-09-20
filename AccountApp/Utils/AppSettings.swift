import UIKit

class AppSettings: Codable, SettingsManageable {

    static var shared = AppSettings()
    
    // MARK: - Properties Representing Settings
    
    var language = "en"
    var darkTheme = false
    
    // MARK: - Init
    
    private init() {
        
    }
    
}
