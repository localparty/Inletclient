//
//  InletCustomerTableViewCell.swift
//  Inletclient_Example
//
//  Created by Gee C on 1/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Inletclient

public class DataSelectionTableViewController: UITableViewController {
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InletCustomer.allCases.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inletCustomer:InletCustomer = InletCustomer.allCases[indexPath.row]
        
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(
                withReuseIdentifier: .customer, cellForRowAt: indexPath)
        
        if let cell = cell as? InletCustomerTableViewCell {
            
            let title = inletCustomer.rawValue
            let subtitle = inletCustomer.inletBrand.rawValue
            
            cell.titleCell.text = title
            cell.subtitleCell.text = subtitle
        }
        
        return cell
    }
}


public class DataSelectionTableViewDataSource: NSObject, UITableViewDataSource {
    
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
        }
        
        return cell
    }
}

class InletCustomerTableViewCell: UITableViewCell {

    @IBAction func switchActivated(_ sender: UISwitch) {
        toggleMaskColor()
    }
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var subtitleCell: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
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
