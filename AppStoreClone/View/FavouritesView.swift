import UIKit

class FavouritesView: UIView, ClippableView {
    
    var isClipped: Bool = false
    
    @IBOutlet private var favouritesTable: FavouritesTableView!
    
    
    func clip() {
        isClipped = false
        favouritesTable.isClipped = true
    }
}
