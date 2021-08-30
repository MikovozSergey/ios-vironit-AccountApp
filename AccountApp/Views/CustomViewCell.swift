import UIKit

final class CustomViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Open methods
    func setup() {
        loginLabel.text = "Привет"
    }
}
