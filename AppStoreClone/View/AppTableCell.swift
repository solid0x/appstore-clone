import UIKit

class AppTableCell: UITableViewCell {
    
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    
    func setup(icon: String, name: String, subtitle: String) {
        let bundle = Bundle(for: type(of: self))
        iconView.image = UIImage(named: icon, in: bundle, with: nil)
        
        iconView.layer.cornerRadius = iconView.bounds.width / 4
        iconView.layer.borderWidth = 1
        iconView.layer.borderColor = CGColor(gray: 0.9, alpha: 1)
        
        nameLabel.text = name
        subtitleLabel.text = subtitle
    }
}
