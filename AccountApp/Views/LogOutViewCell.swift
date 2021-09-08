import AMPopTip
import RxCocoa
import RxSwift
import UIKit

final class LogOutViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var viewForPopTip: UIView!
    @IBOutlet private weak var informationButton: UIButton!
    
    // MARK: - Variables
    
    private let popTip = PopTip()
    private let direction = PopTipDirection.down
    private var navigator: UINavigationController?
    private let languageHandler = LanguageNotificationHandler()
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        handleLanguage()
        setupBinding()
    }
    
    // MARK: - Methods
    
    private func setupBinding() {
        logOutButton.rx.tap.subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            guard let navigator = self.navigator else { return }
            navigator.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        informationButton.rx.tap.subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            if self.popTip.isVisible {
                self.popTip.hide()
            } else {
                self.configurePopTip(sender: self.informationButton)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setup() {
        setupStrings()
        logOutButton.layer.cornerRadius = 10
        logOutButton.layer.borderWidth = 1.5
        logOutButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
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
        informationButton.setImage(Theme.currentTheme.questionImage, for: .normal)
        viewForPopTip.backgroundColor = Theme.currentTheme.backgroundColor
        logOutButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
        contentView.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    private func configurePopTip(sender: UIButton) {
        popTip.bubbleColor = UIColor(red: 0.73, green: 0.91, blue: 0.55, alpha: 0)
        popTip.show(attributedText: setupAtributedText(), direction: direction, maxWidth: 200, in: viewForPopTip, from: sender.frame)
    }
    
    func configure(navigator: UINavigationController) {
        setup()
        self.navigator = navigator
    }
    
    func bind() -> CellOutput {
        return CellOutput(mainEvent: logOutButton.rx.tap)
    }
    
    private func setupStrings() {
        logOutButton.setTitle(L10n.settingsProfileVCLogOutButton, for: .normal)
    }
    
    private func setupAtributedText() -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        return NSMutableAttributedString(string: L10n.settingsVCLogOutPopTipSentenses, attributes: attributes)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
            self?.setupAtributedText()
        }
    }
    
}
