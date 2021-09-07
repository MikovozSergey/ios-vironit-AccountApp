import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", comment: "")
    }
}
