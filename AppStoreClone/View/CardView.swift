import UIKit

protocol CardViewDelegate {
    func cardView(_ cardView: CardView, touchesEnded: Set<UITouch>, with event: UIEvent?)
}

protocol ClippableView: UIView {
    var isClipped: Bool { get }
    func clip()
}

@IBDesignable class CardView: UIView {
    
    @IBInspectable var embeddedView: String!
    
    var delegate: CardViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, embeddedView: String, clip: Bool = true) {
        super.init(frame: frame)
        self.embeddedView = embeddedView
        setup(clipEmbeddedView: clip)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup(clipEmbeddedView: Bool = true) {
        guard let embeddedView = embeddedView else {
            return
        }
        
        backgroundColor = .clear
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2

        let borderView = UIView(frame: bounds)
        borderView.frame = bounds
        borderView.backgroundColor = .green
        borderView.layer.cornerRadius = 10
        borderView.clipsToBounds = true
        borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(borderView)

        let bundle = Bundle(for: type(of: self))
        let innerView = UINib(nibName: embeddedView, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! UIView
        if clipEmbeddedView, let clippableView = innerView as? ClippableView {
            clippableView.clip()
        }
        innerView.frame = borderView.bounds
        innerView.isUserInteractionEnabled = false
        borderView.addSubview(innerView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.cardView(self, touchesEnded: touches, with: event)
    }
}
