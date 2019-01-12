import UIKit
import Inletclient
import RxCocoa
import RxSwift

public enum ReuseIndentifier: String {
    case `default` = "default"
    case hyperTable = "hyper table"
    case tableController = "table controller"
}

public enum UIStoryboardName: String {
    case main = "Main"
}

public enum ControllerStoryboardIdentifier: String {
    case tableController = "table controller"
}

extension UITableView {
    public func dequeueReusableCell(withReuseIdentifier: ReuseIndentifier, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: withReuseIdentifier.rawValue, for: indexPath)
    }
}

extension UIStoryboard {
    public convenience init (uiStoryboardName: UIStoryboardName, bundle: Bundle? = nil) {
        self.init(name: uiStoryboardName.rawValue, bundle: bundle)
    }
    public func instantiateViewController(withControlerStoryboardIdentifier: ControllerStoryboardIdentifier) -> UIViewController{
        return instantiateViewController(withIdentifier: withControlerStoryboardIdentifier.rawValue);
    }
}

public class MirroringTableController: UITableViewController {
    
    var uiTableViewHelper: UITableViewHelper?
    
    typealias ControllerData = (DiscoveryConsents)
    
    func loadSubject(_ subject: Any) {
        let datasource = MirroringDatasource(reflectionOf: subject, showingController: self)
        self.uiTableViewHelper = datasource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return uiTableViewHelper!.numberOfSections!(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiTableViewHelper!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return uiTableViewHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        uiTableViewHelper?.tableView?(tableView, didSelectRowAt: didSelectRowAt)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadSubject(["status": "⚡️ loading local data..."])
        _ = getLocalData()
            .asObservable()
            .subscribe(
                onNext: loadSubject,
                onError: loadSubject
        )
    }
    
    let datasource: UITableViewDataSource? = TextDetailDatasource(
        reusableCellIdentifier: "default",
        text: "loading data now...",
        detail: "Inlet REST API"
    )
    
    typealias BrandProfilesSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile, mailbox: Mailbox, brandProfiles: [(ResultMatch, BrandProfile)])>
    
    func getLocalData() -> BrandProfilesSingle {
        /*
         
         let username = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
         let password = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
         let restClient = RESTClient(username: username, password: password)
         */
        
        // the local configuration
        let restClient = RESTClient()
        
        let minConfidenceLevel: Int = 10
        let inletCustomer: InletCustomer = InletCustomer.WFTEST111918A
        let clientParameters = ClientParameters(inletCustomer: inletCustomer, minConfidenceLevel: minConfidenceLevel, partnerChannelId: partnerChannelId)
        
        return InletController(restClient: restClient, clientParameters: clientParameters).getLocalData()
    }
    
}



