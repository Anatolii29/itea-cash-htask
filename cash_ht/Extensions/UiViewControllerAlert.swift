import UIKit

extension UIViewController {
    
    func presentWarningOneAction(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
}
