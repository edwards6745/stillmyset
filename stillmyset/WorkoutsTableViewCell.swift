import UIKit

class WorkoutsTableViewCell: UITableViewCell, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet var exerciseLabel: UILabel!
    @IBOutlet var swipeLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
