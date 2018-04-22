import UIKit

class WaiterViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Waiter Profile"
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.layer.masksToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeVC))
    }
    
    @objc private func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
