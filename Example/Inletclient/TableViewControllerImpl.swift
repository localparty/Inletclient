import UIKit
import Inletclient

class TableViewControllerImpl: UITableViewController, DatasourceDelegate {
    
    enum StoryBoardReusableCellIdentifier: String {
        case `default` = "default"
    }
    
    let inletController: InletController = InletController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        inletController.datasourceDelegate = self
    }
    
    convenience init() {
        self.init()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return inletController.datasource!.numberOfSections!(in: tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inletController.datasource!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inletController.datasource!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // MARK: - DatasourceDelegate
    
    func resetDataSource(with datasource: UITableViewDataSource){
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func setBrandContent(brand: InletBrand, cell: UITableViewCell) {
        cell.textLabel?.text = "displayName– \(String(describing: brand.displayName))"
        cell.detailTextLabel?.text = "description– \(String(describing: brand.description))"
    }
    
    func getReusableCellIdentifier() -> String {
        return StoryBoardReusableCellIdentifier.default.rawValue
    }

}
