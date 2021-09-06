import UIKit

enum Language: String {
    case english
    case russian
    
    var languageShort: String {
        switch self {
        case .english:
            return "en"
        case .russian:
            return "ru"
        }
    }
    
    var reverseLanguage: String {
        switch self {
        case .english:
            return "ru"
        case .russian:
            return "en"
        }
    }
  
    public init?(_ string: String) {
        switch string {
        case "ru": self = .russian
        case "en": self = .english
        default: return nil
        }
    }
}
