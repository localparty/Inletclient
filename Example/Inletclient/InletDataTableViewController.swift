import UIKit
import Inletclient
import RxCocoa
import RxSwift

public class InletDataTableViewController:
    MirroringTableViewController, MirrorControllerDelegate {
    
    var subscription: Disposable?
    
    func mirrorSubjectFromSelf(_ subject: Any) {
        mirror(subject, usingDelegate: self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mirrorSubjectFromSelf((
            "status",
            "⚡️ loading data now..."))
        
        subscription = loadData()
            .asObservable()
            .subscribe(
                onNext: mirrorSubjectFromSelf,
                onError: mirrorSubjectFromSelf
            )
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear from– \(self)")
        subscription?.dispose()
    }
    
    public func instanciateProxyViewController() -> ProxyTableViewController {
        let storyboard: UIStoryboard = UIStoryboard(uiStoryboardName: .main)
        let viewControllerInstance: UIViewController =
            storyboard.instantiateViewController(
            withControlerStoryboardIdentifier: .tableController)
        if let viewControllerInstance = viewControllerInstance as? ProxyTableViewController {
            return viewControllerInstance
        } else {
            print("didn't get the expected type– \(ProxyTableViewController.self)" +
                "but– \(type(of: viewControllerInstance))")
            return viewControllerInstance as! ProxyTableViewController
        }
    }
    
    public func sourceController() -> UIViewController {
        return self
    }
    
    func loadData() -> InletDataSingle {
        /*
         let username = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
         let password = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
         let restClient = RESTClient(username: username, password: password)
         */
        
        let restClient = RESTClient()
        
        let minConfidenceLevel: Int = 10
        let inletCustomer: InletCustomer = InletCustomer.WFTEST111918A
        let clientParameters =
            ClientParameters(
                inletCustomer: inletCustomer,
                minConfidenceLevel: minConfidenceLevel,
                partnerChannelId: partnerChannelId)
        
        return
            InletController(
                restClient: restClient,
                clientParameters: clientParameters)
                .loadData()
    }
    
}



