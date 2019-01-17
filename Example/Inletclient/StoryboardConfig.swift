import UIKit

public enum ReuseIndentifier: String {
    case customer
    case proxy
    case mirror
}

public enum ControllerStoryboardIdentifier: String {
    case customer
    case proxy
    case mirror
}

public enum UIStoryboardName: String {
    case main = "Main"
}

extension UITableView {
    public func dequeueReusableCell(withReuseIdentifier: ReuseIndentifier, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: withReuseIdentifier.rawValue, for: indexPath)
    }
}

extension UIStoryboard {
    public convenience init (uiStoryboardName: UIStoryboardName, bundle: Bundle? = nil) {
        self.init(name: uiStoryboardName.rawValue, bundle: bundle)
    }
    public func instantiateViewController(withControlerStoryboardIdentifier: ControllerStoryboardIdentifier) -> UIViewController{
        return instantiateViewController(withIdentifier: withControlerStoryboardIdentifier.rawValue);
    }
}
