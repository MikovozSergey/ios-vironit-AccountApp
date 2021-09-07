import UIKit

extension Xib {
    func nib() -> UINib {
        return UINib(nibName: self.rawValue, bundle: Bundle.main)
    }
    
    func firstView() -> UIView {
        return nib().instantiate(withOwner: nil, options: nil).first as! UIView
    }
}

extension UITableView {
    func register(xib: Xib) {
        self.register(xib.nib(), forCellReuseIdentifier: xib.rawValue)
    }
}
