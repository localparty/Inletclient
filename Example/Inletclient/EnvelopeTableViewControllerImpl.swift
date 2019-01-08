import UIKit
import Inletclient

class EnvelopeTableViewControllerImpl: UITableViewController, EnvelopeDataSource {
    
    enum StoryBoardReusableCellIdentifier: String {
        case `default` = "default"
    }
    
    let inletController: EnvelopeController = EnvelopeController()
    
    var uiTableViewDatasource: UITableViewDataSource?
    
    func orElse(error: Error){
        let errorDatasource: UITableViewDataSource = MemoDataSource(
            reusableCellIdentifier: StoryBoardReusableCellIdentifier.default.rawValue,
            text: error.localizedDescription,
            detail: String(describing: error))
        uiTableViewDatasource = errorDatasource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressDatasource: UITableViewDataSource = MemoDataSource(
            reusableCellIdentifier: StoryBoardReusableCellIdentifier.default.rawValue,
            text: "loading...",
            detail: "Inlet API")
        uiTableViewDatasource = progressDatasource
        
        inletController.getEnvelope(
            withEnvelopeId: "EV:10000271587",
            andThen: {(envelope) in
                let envelopeDatasource: UITableViewDataSource = envelope.asUITableViewDataSource(datasourceDelegate: self)
                self.uiTableViewDatasource = envelopeDatasource
        },
            orElse: orElse)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return uiTableViewDatasource!.numberOfSections!(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiTableViewDatasource!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return uiTableViewDatasource!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // MARK: - EnvelopeDataSource
    
    func getReusableCellIdentifier(forTypeName: String) -> String {
        return StoryBoardReusableCellIdentifier.default.rawValue
    }
    
}


