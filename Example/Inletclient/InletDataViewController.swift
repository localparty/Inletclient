import UIKit
import Inletclient
import RxCocoa
import RxSwift

public class InletDataViewController:
    UIViewController, UITableViewDelegate,
UITableViewDataSource, MirrorControllerDelegate {
    
    public let customersPool: [InletCustomer] = [
        .WFTEST011019A,
        .WFTEST011019B,
        .WFTEST011019C,
        .WFTEST011019D
    ]
    
    
    @IBAction func onLoadActivated(_ sender: UIBarButtonItem) {
        retrieveData(sender)
    }
    
    @IBAction func onSelectionActivated(_ sender: UIBarButtonItem) {
        toggleSwitches()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var subscription: Disposable?
    
    func onNext(data: Any) {
        DispatchQueue.main.async {
            let viewController = self.instanciateProxyViewController()
            if let viewController = viewController as? MirroringTableViewController {
                viewController.mirror(data, usingDelegate: self)
                self.navigationController!.show(viewController, sender: self)
            }
        }
    }
    
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
                    dataQuery.append(customersPool[index])
                }
            }
        }
        
        guard dataQuery.count > 0 else {
            return
        }
        
        let dataSingles = dataQuery.map { (inletCustomer) in
            return loadDataOf(customer: inletCustomer).asObservable()
        }
        
        subscription = Observable
            .zip(dataSingles)
            .asObservable()
            .subscribe(onNext: onNext, onError: onError)
    }
    
    func retrieveDataBackup(_ sender: UIBarButtonItem) {
        
        subscription?.dispose()
        
        subscription = brandId(customer: InletCustomer.WFTEST011019A)
            .asObservable()
            .subscribe(onNext: onNext, onError: onError)
    }
    
    
    public func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func loadDataOf(customer: InletCustomer) -> InletDataSingle {
        
        let minConfidenceLevel: Int = 10
        let clientParameters =
            ClientParameters(
                inletCustomer: customer,
                minConfidenceLevel: minConfidenceLevel,
                partnerChannelId: partnerChannelId)
        
        let dataDirectoryModeIsTrue = false
        guard dataDirectoryModeIsTrue else {
            
            let username = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
            let password = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
            
            let restClient: RESTClient = RESTClient(
                username: username, password: password)
            
            return
                InletController(
                    restClient: restClient,
                    clientParameters: clientParameters)
                    .loadData()
        }
        // local data mode
        //let dataDirectory = "mono-brand"
        
        
        let dataDirectory = "chris"
        let bundle = Bundle.main
        let restClient: RESTClient = RESTClient(
            dataDirectory: dataDirectory,
            bundle: bundle
        )
        
        return
            InletController(
                restClient: restClient,
                clientParameters: clientParameters)
                .loadData()
        
    }
    
    func brandId(customer: InletCustomer) -> Single<[BrandProfile]> {
        
        let minConfidenceLevel: Int = 10
        let clientParameters =
            ClientParameters(
                inletCustomer: customer,
                minConfidenceLevel: minConfidenceLevel,
                partnerChannelId: partnerChannelId)
        
        let template = InletCredentials()
        
        let restClient: RESTClient = RESTClient(
            username: template.username, password: template.password)
        
        let brandId = "BB:10000001203"
        
        return
            InletController(
                restClient: restClient,
                clientParameters: clientParameters)
                .getProfileSingle(ofBrandWithId: brandId)
        
    }
    
    private func getAppSetting () -> Bool {
        
        let mainBundleIdentifier: String = Bundle.main.bundleIdentifier!
        let suiteName: String = "group.\(mainBundleIdentifier)"
        return UserDefaults(suiteName: suiteName)!
            .bool(forKey: PreferenceItemIdentifier.online.rawValue)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customersPool.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inletCustomer:InletCustomer = customersPool[indexPath.row]
        
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(
                withReuseIdentifier: .customer, cellForRowAt: indexPath)
        
        if let cell = cell as? InletCustomerTableViewCell {
            
            let title = "\(inletCustomer.rawValue)– \(inletCustomer.brand.rawValue)"
            let subtitle = "\(inletCustomer.brand.attributes.name)– \(inletCustomer.brand.attributes.connectionParametersDescription)"
            
            cell.titleCell.text = title
            cell.subtitleCell.text = subtitle
            cell.switch.isOn = false
            cell.toggleMaskColor()
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
    
    func getBackgroundColor(switchState: Bool) -> CGColor {
        return switchState ?
        CGColor.crayons.cantaloupe :
        CGColor.crayons.honeydew
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
                    cellBackground.layer.backgroundColor =
                        self.getBackgroundColor(switchState: self.`switch`.isOn)
            })
        }
        
    }
    
}


