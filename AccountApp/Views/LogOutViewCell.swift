import UIKit

final class LogOutViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var logOutLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Open methods
    func setup() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 1.5
        cellView.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        self.selectionStyle = .none
    }
}
