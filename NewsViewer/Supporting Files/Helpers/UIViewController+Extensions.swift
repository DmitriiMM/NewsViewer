import UIKit

extension UIViewController {
    func presentErrorDialog(message: String?) {
        let errorDialog = UIAlertController(title: "all_modules.error_dialog.error".localized, message: message, preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "all_modules.error_dialog.ok".localized, style: .default))
        present(errorDialog, animated: true)
    }
}
