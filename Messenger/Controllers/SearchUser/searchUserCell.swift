

import UIKit

class searchUserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 86/2

        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(red: 0.86, green: 0.45, blue: 0.67, alpha: 1.00).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
