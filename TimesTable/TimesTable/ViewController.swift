//
//  ViewController.swift
//  SimpleTableExample
//  Created by Joseph Dobos on 10/10/2022.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var intNumber = 5
    var hideTableBool = true
    
    
    
    @IBAction func goButton(_ sender: Any){
        
        
        self.UserInput.resignFirstResponder()
        let userNumber = UserInput.text!
        intNumber = Int(userNumber)!
        myTable.reloadData()
        hideTableBool = false
        
        
        
        
    }
    
    @IBOutlet weak var UserInput: UITextField!
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.isHidden = true
        
        if hideTableBool == false{
            tableView.isHidden = false
        }
        
        
        
        if indexPath.section == 0{
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            var content = UIListContentConfiguration.cell()
            let intOutput = (intNumber) * (indexPath.row + 1)
            let outputString = "\(intNumber) * \(indexPath.row + 1) = \(intOutput)"
            content.text = String(outputString)
        
            aCell.contentConfiguration = content
            return aCell
        }
        else{
            let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            var content = UIListContentConfiguration.cell()
            let intOutput = Double((intNumber)) / Double((indexPath.row + 1))
            let fourDPResult = String(format: "%.4f", intOutput)
            let outputString = "\(intNumber) / \(indexPath.row + 1) = \(fourDPResult)"
            content.text = String(outputString)
            
            aCell.contentConfiguration = content
            return aCell
            
            
            
            
            
        }
        
    }
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


