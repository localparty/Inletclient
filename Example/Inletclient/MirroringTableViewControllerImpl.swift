import UIKit
import Inletclient

class MirroringTableViewControllerImpl: UITableViewController {
    
    let inletController: EnvelopeController = EnvelopeController()
    var uiTableViewHelper: UITableViewHelper?
    
    func orElse(error: Error){
        let errorDatasource: UITableViewHelper = MemoDatasource(
            reusableCellIdentifier: "default",
            text: error.localizedDescription,
            detail: String(describing: error))
        self.uiTableViewHelper = errorDatasource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressDatasource: UITableViewHelper = MemoDatasource(
            reusableCellIdentifier: "default",
            text: "loading...",
            detail: "Inlet API")
        self.uiTableViewHelper = progressDatasource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        inletController.getEnvelope(
            withEnvelopeId: "EV:10000271587",
            andThen: {(envelope) in
                let mirroringDatasource = MirroringDatasource(reflectionOf: envelope, showingController: self)
                self.uiTableViewHelper = mirroringDatasource
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        },
            orElse: orElse)
    }
    
}


