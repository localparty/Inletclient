import UIKit
import Inletclient

class EnvelopeTableViewControllerImpl: UITableViewController {
    
    
    enum StoryBoardReusableCellIdentifier: String {
        case `default` = "default"
    }
    
    let inletController: EnvelopeController = EnvelopeController()
    
    var uiTableViewHelper: UITableViewHelper?
    
    func orElse(error: Error){
        let errorDatasource: UITableViewHelper = MemoDatasource(
            reusableCellIdentifier: StoryBoardReusableCellIdentifier.default.rawValue,
            text: error.localizedDescription,
            detail: String(describing: error))
        uiTableViewHelper = errorDatasource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressDatasource: UITableViewHelper = MemoDatasource(
            reusableCellIdentifier: StoryBoardReusableCellIdentifier.default.rawValue,
            text: "loading...",
            detail: "Inlet API")
        uiTableViewHelper = progressDatasource
        
        inletController.getEnvelope(
            withEnvelopeId: "EV:10000271587",
            andThen: {(envelope) in
                let envelopeDatasource: UITableViewHelper = envelope.asUITableViewHelper(reusableCellIdentifier: "default")
                self.uiTableViewHelper = envelopeDatasource
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        },
            orElse: orElse)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return uiTableViewHelper!.numberOfSections!(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiTableViewHelper!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return uiTableViewHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        uiTableViewHelper?.tableView?(tableView, didSelectRowAt: didSelectRowAt)
    }
    
    // MARK: - EnvelopeDataSource
    
    func getReusableCellIdentifier(forTypeName: String) -> String {
        return StoryBoardReusableCellIdentifier.default.rawValue
    }
    
}


