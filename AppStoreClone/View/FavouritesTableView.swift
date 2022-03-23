import UIKit

@IBDesignable class FavouritesTableView: UITableView {
    
    typealias app = (name: String, subtitle: String)
    
    var isClipped = false
    
    private let cellId = "AppTableCell"
    private let apps: [app] = [
        ("Apple Music", "90 million songs, all ad-free."),
        ("Home", "Lifestyle"),
        ("Shortcuts", "Do more with your apps"),
        ("Stocks", "Finance"),
        ("Apple TV", "The home of Apple TV+"),
        ("Find My", "Utilities"),
        ("Notes", "Take note of almost anything"),
        ("FaceTime", "Social Networking")
    ]
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        let cellNib = UINib(nibName: cellId, bundle: bundle)
        register(cellNib, forCellReuseIdentifier: cellId)
        
        dataSource = self
        delegate = self
    }
}

extension FavouritesTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isClipped ? 4 : apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellId) as! AppTableCell
        let app = apps[indexPath.row]
        let icon = app.name.replacingOccurrences(of: " ", with: "") + "Icon"
        cell.setup(icon: icon, name: app.name, subtitle: app.subtitle)
        let endIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == endIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        }
        return cell
    }
}

extension FavouritesTableView: UITableViewDelegate {
    
}
