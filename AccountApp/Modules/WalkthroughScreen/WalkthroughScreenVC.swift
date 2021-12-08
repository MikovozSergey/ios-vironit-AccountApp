import UIKit

class WalkthroughViewController: UIPageViewController {

    // MARK: - Variables
    
    private var pages = [UIViewController]()
    private let pageControl = UIPageControl()
    private let initialPage = 0
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel: WalkthroughViewModel?
    private var isRegistrationFlow: Bool?

    // MARK: - Constraints
    
    private var pageControlBottomAnchor: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
    
    public func configure(viewModel: WalkthroughViewModel, isRegistrationFlow: Bool) {
        self.viewModel = viewModel
        self.isRegistrationFlow = isRegistrationFlow
    }
    
    // MARK: - Setup
    
    private func setup() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

        let page1 = OnboardingViewController(imageName: "iconVideoGold",
                                             titleText: setupStringForFirstVC()[0],
                                             subtitleText: setupStringForFirstVC()[1])
        let page2 = OnboardingViewController(imageName: "iconListGold",
                                             titleText: setupStringForSecondVC()[0],
                                             subtitleText: setupStringForSecondVC()[1])
        let page3 = OnboardingViewController(imageName: "iconSettingsGold",
                                             titleText: setupStringForThirdVC()[0],
                                             subtitleText: setupStringForThirdVC()[1])
       // let page4 = LoginViewController()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
       // pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Colors.gold
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    private func layout() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // for animations
        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
        
        pageControlBottomAnchor?.isActive = true
    }
    
    private func setupStringForFirstVC() -> [String] {
        return [L10n.empty, L10n.walkthroughFirstVCSubtitle]
    }
    
    private func setupStringForSecondVC() -> [String] {
        return [L10n.list, L10n.walkthroughSecondVCSubtitle]
    }
    
    private func setupStringForThirdVC() -> [String] {
        return [L10n.settings, L10n.walkthroughThirdVCSubtitle]
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStringForFirstVC()
            self?.setupStringForSecondVC()
            self?.setupStringForThirdVC()
        }
    }
    
    // MARK: - Actions
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        animateControlsIfNeeded()
    }
}

// MARK: - DataSource and Delegates

extension WalkthroughViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            guard let registrationFlow = isRegistrationFlow else { return nil }
            if registrationFlow {
                viewModel?.steps.accept(WalkthroughStep.skipStepForRegistration)
            } else {
                viewModel?.steps.accept(WalkthroughStep.skipStepForSettings)
            }
            return nil              // wrap first
        }
    }
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
    }
    
    private func animateControlsIfNeeded() {
        showControls()

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func showControls() {
        pageControlBottomAnchor?.constant = 16
    }
}
