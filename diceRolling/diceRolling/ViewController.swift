//
//  ViewController.swift
//  diceRolling
//
//  Created by Joseph Dobos on 05/10/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var guessBox: UITextField!
    
    
    @IBOutlet weak var outputMessage: UILabel!
    
    
    @IBAction func guessButton(_ sender: Any) {
        
        
        self.guessBox.resignFirstResponder()    
        
        let diceRoll = Int.random(in:2...12)
        let userGuess = guessBox.text!
        let userGuessInt = Int(userGuess)
        let diceRollString = String(diceRoll)
        
        if(userGuessInt == diceRoll){
            let outputString = "Correct The Number Was " + diceRollString
            outputMessage.text = outputString
        }
        else{
            let outputString = "Incorrect The Number Was " + diceRollString
            outputMessage.text = outputString
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

