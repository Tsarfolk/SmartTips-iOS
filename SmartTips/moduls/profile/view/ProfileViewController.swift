import UIKit

class ProfileViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.layer.masksToBounds = true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
