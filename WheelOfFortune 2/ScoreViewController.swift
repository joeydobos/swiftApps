//
//  ScoreViewController.swift
//  WheelOfFortune
//
//  Created by Joseph Dobos on 13/11/2022.
//

import UIKit




class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var highScores = defaults.stringArray(forKey: "HighScoresArray") ?? [String]()
    var intScores = [Int]()
    
    //This function turns an array of strings into an array of Int
    func stringToIntArray(){
        for number in highScores{
            intScores.append(Int(number)!)
        }
        return intScores.sort(by: >) // orders from higest to lowest
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stringToIntArray()
        let highScoresCount = intScores.count
        return highScoresCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content = UIListContentConfiguration.cell()

        content.text = "Score: " + String(intScores[indexPath.row]) // sets content of each idex of array as new cell in table
        cell.contentConfiguration = content // displays the content on a table
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
