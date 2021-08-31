import UIKit

final class CustomViewForEditCredentialsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Open methods
    func setup() {
        loginLabel.text = "Изменить логин и пароль?"
        self.selectionStyle = .none
    }
}
