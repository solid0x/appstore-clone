import UIKit

@IBDesignable class AppCell: UIView {
    
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var button: UIButton!
    
    @IBInspectable private var color: UIColor!
    @IBInspectable private var nameColor: UIColor!
    @IBInspectable private var subtitleColor: UIColor!
    @IBInspectable private var buttonColor: UIColor!
    @IBInspectable private var icon: UIImage!
    @IBInspectable private var name: String!
    @IBInspectable private var subtitle: String!
    @IBInspectable private var downloaded: Bool = false
    @IBInspectable private var shrinked: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        let type = type(of: self)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: String(describing: type), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = color
        addSubview(view)
        
        iconView.image = self.icon
        iconView.layer.cornerRadius = iconView.bounds.width / 4
        
        nameLabel.text = name
        nameLabel.textColor = nameColor
        
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = subtitleColor
        
        if downloaded {
            var configuration = UIButton.Configuration.gray()
            configuration.title = "OPEN"
            configuration.cornerStyle = .capsule
            configuration.attributedTitle?.font = button.configuration!.attributedTitle!.font
            button.configuration = configuration
        }
        
        if shrinked {
            for constraint in view.constraints {
                if constraint.identifier == "Shrinkable" {
                    constraint.constant = 0
                }
            }
        }
    }
}
