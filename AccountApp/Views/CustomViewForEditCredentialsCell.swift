import AMPopTip
import UIKit

final class CustomViewForEditCredentialsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var viewForPopTip: UIView!
    @IBOutlet private weak var changeLoginAndPasswordButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction private func tappedChangeLoginAndPasswordButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChangeProfileScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "ChangeProfileViewController") as? ChangeProfileViewController else { return }
        guard let navigator = self.navigator else { return }
        navigator.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func tappedInformationButton(_ sender: UIButton) {
        if popTip.isVisible {
            popTip.hide()
        } else {
            configurePopTip(sender: sender)
        }
    }
    
    // MARK: Variables
    
    private let popTip = PopTip()
    private let direction = PopTipDirection.up
    private var navigator: UINavigationController?
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        handleLanguage()
    }
    
    // MARK: - Open methods
    func setup() {
        setupStrings()
        changeLoginAndPasswordButton.layer.cornerRadius = 10
        changeLoginAndPasswordButton.layer.borderWidth = 1.5
        changeLoginAndPasswordButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        self.selectionStyle = .none
    
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.borderWidth = 1
        popTip.borderColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func configurePopTip(sender: UIButton) {
        popTip.bubbleColor = UIColor(red: 0.73, green: 0.91, blue: 0.55, alpha: 0)
        popTip.show(attributedText: setupAtributedText(), direction: direction, maxWidth: 200, in: viewForPopTip, from: sender.frame)
    }
    
    func configureNavigation(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    private func setupStrings() {
        changeLoginAndPasswordButton.setTitle(L10n.settingsProfileVCEditCredentialsTitle, for: .normal)
    }
    
    private func setupAtributedText() -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]
        return NSMutableAttributedString(string: L10n.settingsVCChangeLoginAndPassowrdPopTipSentenses, attributes: attributes)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
            self?.setupAtributedText()
        }
    }
}
