import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    
    private var isPresenting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let statusBarFrame = windowScene?.statusBarManager?.statusBarFrame {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let statusBarView = UIVisualEffectView(effect: blurEffect)
            statusBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            statusBarView.frame = statusBarFrame
            self.view.addSubview(statusBarView)
        }
        
        for subview in contentView.subviews {
            if let cardView = subview as? CardView {
                cardView.delegate = self
            }
        }
    }
}

extension TodayViewController: CardViewDelegate {
    
    func cardView(_ cardView: CardView, touchesEnded: Set<UITouch>, with event: UIEvent?) {
        let detailsVC = UIStoryboard.main.instantiateViewController(withIdentifier: "CardDetailsViewController")
        let embeddedView = UINib(nibName: cardView.embeddedView, bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        embeddedView.frame = detailsVC.view.bounds
        detailsVC.view.addSubview(embeddedView)
        detailsVC.view.sendSubviewToBack(embeddedView)
        detailsVC.modalPresentationStyle = .custom
        detailsVC.transitioningDelegate = CardTransitionManager.shared.with(cardView)
        present(detailsVC, animated: true, completion: nil)
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

class CardTransitionManager: NSObject {
    
    static let shared = CardTransitionManager()
    
    private var cardView: CardView!
    private var isPresenting = false
    
    
    func with(_ cardView: CardView) -> CardTransitionManager {
        self.cardView = cardView
        return self
    }
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let transitionDuration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                  return
        }
        
        let cardFrame = cardView.superview!.convert(cardView.frame, to: nil)
        if isPresenting {
            guard let sourceController = (fromViewController as? UITabBarController)?.selectedViewController else {
                return
            }
            let tabBarController = sourceController.tabBarController!
            let tabBarFrame = tabBarController.tabBar.frame
            let cardViewCopy = CardView(frame: cardFrame, embeddedView: cardView.embeddedView, clip: false)
            cardView.isHidden = true
            containerView.addSubview(cardViewCopy)
            cardViewCopy.layoutIfNeeded()
            
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
                tabBarController.tabBar.frame = tabBarFrame.offsetBy(dx: 0, dy: tabBarController.tabBar.frame.height)
                cardViewCopy.frame = containerView.bounds
                cardViewCopy.layoutIfNeeded()
            } completion: { _ in
                tabBarController.tabBar.frame = tabBarFrame
                cardViewCopy.removeFromSuperview()
                containerView.addSubview(toViewController.view)
                self.cardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        } else {
            guard let targetController = (toViewController as? UITabBarController)?.selectedViewController else {
                return
            }
            let tabBarController = targetController.tabBarController!
            let tabBarFrame = tabBarController.tabBar.frame
            tabBarController.tabBar.frame = tabBarFrame.offsetBy(dx: 0, dy: tabBarController.tabBar.frame.height)
            
            let cardContainer = targetController.view!
            let cardViewCopy = CardView(frame: cardContainer.bounds, embeddedView: cardView.embeddedView, clip: false)
            cardView.isHidden = true
            cardContainer.addSubview(cardViewCopy)
            fromViewController.view.removeFromSuperview()
            cardViewCopy.layoutIfNeeded()
            
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
                tabBarController.tabBar.frame = tabBarFrame
                cardViewCopy.frame = cardFrame
                cardViewCopy.layoutIfNeeded()
            } completion: { _ in
                cardViewCopy.removeFromSuperview()
                self.cardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
}
