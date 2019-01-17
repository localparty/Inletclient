import UIKit
import Inletclient
import RxCocoa
import RxSwift

public class InletDataViewController:
    UIViewController, UITableViewDelegate,
UITableViewDataSource, MirrorControllerDelegate {
    
    
    @IBAction func onLoadActivated(_ sender: UIBarButtonItem) {
        retrieveData(sender)
    }
    
    @IBAction func onSelectionActivated(_ sender: UIBarButtonItem) {
        toggleSwitches()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var subscription: Disposable?
    
    func onNext(data: [BrandProfilesTuple]) {
        DispatchQueue.main.async {
            let viewController = self.instanciateProxyViewController()
            if let viewController = viewController as? MirroringTableViewController {
                viewController.mirror(data, usingDelegate: self)
                self.navigationController!.show(viewController, sender: self)
            }
        }
    }
    
    func onError(error: Error) {
        DispatchQueue.main.async {
            let viewController = self.instanciateProxyViewController()
            if let viewController = viewController as? MirroringTableViewController {
                viewController.mirror(error, usingDelegate: self)
                self.navigationController!.show(viewController, sender: self)
            }
        }
    }
    
    func toggleSwitches() {
        for index in 0 ... tableView(self.tableView, numberOfRowsInSection: 0) {
            let cellAtIndex =
                tableView.cellForRow(at: IndexPath(row: index, section: 0))
            if let cellAtIndex = cellAtIndex as? InletCustomerTableViewCell {
                cellAtIndex.switch.setOn(!cellAtIndex.switch.isOn, animated: true)
            }
        }
    }
    
    func retrieveData(_ sender: UIBarButtonItem) {
        
        subscription?.dispose()
        
        var dataQuery: [InletCustomer] = []
        for index in 0 ... tableView(self.tableView, numberOfRowsInSection: 0) {
            let cellAtIndex =
                tableView.cellForRow(at: IndexPath(row: index, section: 0))
            if let cellAtIndex = cellAtIndex as? InletCustomerTableViewCell {
                if cellAtIndex.switch.isOn {
                    dataQuery.append(InletCustomer.allCases[index])
                }
            }
        }
        
        guard dataQuery.count > 0 else {
            return
        }
        
        let username = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
        let password = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
        let restClient = RESTClient(username: username, password: password)
        //let restClient = RESTClient()
        
        let dataSingles = dataQuery.map { (inletCustomer) in
            return loadDataOf(customer: inletCustomer, withClient: restClient).asObservable()
        }
        
        subscription = Observable
            .zip(dataSingles)
            .asObservable()
            .subscribe(onNext: onNext, onError: onError)
    }
    
    
    public func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InletCustomer.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inletCustomer:InletCustomer = InletCustomer.allCases[indexPath.row]
        
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(
                withReuseIdentifier: .customer, cellForRowAt: indexPath)
        
        if let cell = cell as? InletCustomerTableViewCell {
            
            let title = inletCustomer.rawValue
            let subtitle = inletCustomer.inletBrand.rawValue
            
            cell.titleCell.text = title
            cell.subtitleCell.text = subtitle
            cell.switch.isOn = false
        }
        
        return cell
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        subscription?.dispose()
    }
    
    func loadDataOf(customer: InletCustomer, withClient: RESTClient) -> InletDataSingle {
        
        let minConfidenceLevel: Int = 10
        let clientParameters =
            ClientParameters(
                inletCustomer: customer,
                minConfidenceLevel: minConfidenceLevel,
                partnerChannelId: partnerChannelId)
        
        return
            InletController(
                restClient: withClient,
                clientParameters: clientParameters)
                .loadData()
    }
    
    public func instanciateProxyViewController() -> ProxyTableViewController {
        let storyboard: UIStoryboard = UIStoryboard(uiStoryboardName: .main)
        let viewControllerInstance: UIViewController =
            storyboard.instantiateViewController(
                withControlerStoryboardIdentifier: .mirror)
        if let viewControllerInstance = viewControllerInstance as? MirroringTableViewController {
            return viewControllerInstance
        } else {
            print("didn't get the expected type– \(MirroringTableViewController.self)" +
                "but– \(type(of: viewControllerInstance))")
            return viewControllerInstance as! MirroringTableViewController
        }
    }
    
    public func sourceController() -> UIViewController {
        return self
    }
    
    public func getReusableCellIdentifier() -> String {
        return ReuseIndentifier.mirror.rawValue
    }
    
}



public class InletCustomerTableViewCell: UITableViewCell {
    
    @IBAction func switchActivated(_ sender: UISwitch) {
        toggleMaskColor()
    }
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var subtitleCell: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func toggleMaskColor(){
        
        if let cellBackground = self.viewWithTag(1){
            
            
            
            
            UIView.animate(
                withDuration: 0.5, delay: 0,
                options: [
                    .curveEaseInOut,
                    .preferredFramesPerSecond30
                ],
                animations: {
                    
                    cellBackground.layer.backgroundColor = self.`switch`.isOn ?
                        CGColor.crayons.cantaloupe :
                        CGColor.crayons.honeydew
                    
            })
        }
        
    }
    
}


