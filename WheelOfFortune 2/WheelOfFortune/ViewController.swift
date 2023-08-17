//
//  ViewController.swift
//  WheelOfFortune
//
//  Created by Joseph Dobos on 25/10/2022.
//

import UIKit
var highScores = defaults.stringArray(forKey: "HighScoresArray") ?? [String]()
let defaults = UserDefaults.standard



class ViewController: UIViewController, UICollectionViewDelegate,
                      UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // Global Variables that are used throughout.
    var chosenWord = ""
    var genres = ""
    var wordArray = [String]()
    var lowerWord = [String]()
    var noSpaces = [String]()
    var noMatch = 0
    var youWon = 0
    var rewardNumbers = [1, 2, 5, 10, 20]
    var rewardValue = 0
    var score = 0
    
    // This function selects a random word
    func randomword() -> (String, String, [String]){
        // Selects a random word from the JSONData and sets to varibles
        let (theGamePhrases, theGameGenre) = getJSONDataIntoArray()
        let word = theGamePhrases.randomElement()!
        let genre = theGameGenre
        
        //Turns phrase and genre lowercase
        chosenWord = word.lowercased()
        genres = genre.lowercased()
        
        print(chosenWord) // Prints to console
        
        //Sets Array to empty String
        wordArray = [String]()
        
        //Randomly picks the reward value from an array and shows on Reward Label
        rewardValue = rewardNumbers.randomElement()!
        rewardLabel.text = String(rewardValue)
        
        
        // loops through each letter in chosen word
        for letter in chosenWord{
            // appends each letter to an array
            wordArray.append(String(letter))
            
            //If charactor != " " then it is appended to an array. Is used to check if user has guessed all valid letters.
            if letter == " "{
            }
            else{
                noSpaces.append(String(letter))
            }
        }
        // This function the randomn phrase, genre and the chosen phrase an an array
        return (word, genre, wordArray)
    }
    
        
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returns the number of sections the Colection view has as the legnth of the word array
        return wordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Goes through the wordArray and displays the letter as image in cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for:
        indexPath) as! myCVCell
        cell.theImage.image = UIImage(named: wordArray[indexPath.row])
        
        
       return cell
        
        
    }
    
    //Function to reset all values back to defult when game is over or new game is selected
    func reloadGame(){
        let (w,g,a) = randomword()
        chosenWord  = w
        genres = g
        wordArray = a
        noMatch = 0
        youWon = 0
        score = 0
        debugLabel.text = "                               "
        wrongGuesses.text = "0"
        wordOutput.reloadData()
    }
    
    //new game button that calls reload game to reset values
    @IBAction func newGame(_ sender: Any) {
        noSpaces.removeAll() // removes all data from the array no spaces
        reloadGame()
      
        

    }
     // Lables for output
    @IBOutlet weak var EnterGuess: UITextField!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var isCorrect: UILabel!
    @IBOutlet weak var wrongGuesses: UILabel!
    
    // a Segue to provude data for the table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toScore"{
            let ScoreViewController = segue.destination as! ScoreViewController
            ScoreViewController.highScores = highScores
        }
    }
    
    //Guess button
    @IBAction func submitButton(_ sender: Any) {
        ValidLetter.text = " "
        
        let userGuess = EnterGuess.text! //sets users input to let value
        
        //loops through array of chosen word and compares to the users gues s
        if String(chosenWord).contains(userGuess){
            //keeps label empty
            ValidLetter.text = " "
            
        }
        else{
            // increments the number of incorrect guesses
            noMatch += 1
            ValidLetter.text = "Try Again"
            wrongGuesses.text = String(noMatch)
        }
        
        //loops thorugh each index of array
        for (n, word) in wordArray.enumerated(){
            if userGuess == String(word){
                youWon += 1 //incriments the number of correct guesses
                wordArray[n] = String(userGuess.uppercased()) //turns the letter uppercase so that the collection view will reconise this as an asset
                wordOutput.reloadData() // reloads the colletion view
                score += rewardValue // updates the users score
            }
        }
        
        //if amount of correct guesses == the number of letters in phrase without spaces
        if youWon == (noSpaces.count){
            highScores.append(String(score)) // the score is appended to array
            
            // persistant storage - will store this value regardless if app is closed or not
            UserDefaults.standard.set(highScores, forKey: "myKey")
            defaults.set(highScores, forKey: "HighScoresArray")
            
            // Output label tells user that they have won and their score
            debugLabel.text = "YOU WON YOUR SCORE IS: " + String(score)
        }
        
        // If the user has 10 wrong guesses
        if noMatch == 10{
            ValidLetter.text = " " // removes the label
            debugLabel.text = "YOU LOST CLICK NEW GAME" // outputs that you have won
        }
        }
        
        
    // opens the high score tab when you click the button
    @IBAction func toHighScores(_ sender: Any) {
        performSegue(withIdentifier: "toScore", sender: nil)
    }
    @IBOutlet weak var ValidLetter: UILabel!
    
    // allows you to change details regarding the collectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let theSize = CGSize(width: 25.0, height: 47.0)
        return theSize
    }
    

    @IBOutlet weak var wordOutput: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        (_,_,_) = randomword() // calls random word function

        
        // Do any additional setup after loading the view.
    }

func getFilesInBundleFolder(named fileOrFolderName:String,
    withExt: String) -> [URL] {
            var fileURLs = [URL]() //the retrieved file-based URLs will be placed here
            let path = Bundle.main.url(forResource: fileOrFolderName,
    withExtension: withExt)
            //get the URL of the item from the Bundle (in this case a folder
            //whose name was passed as an argument to this function)
            do {// Get the directory contents urls (including subfolders urls)
                fileURLs = try
    FileManager.default.contentsOfDirectory(at: path!,
    includingPropertiesForKeys: nil, options: [])
            } catch {
                print(error.localizedDescription)
            }
            return fileURLs
        }
        
func getJSONDataIntoArray() -> ([String],String) {
    var theGamePhrases = [String]() //empty array which will evenutally hold our phrases
            //and which we will use to return as part of the result of thisfunction.
            var theGameGenre = ""
            //get the URL of one of the JSON files from the JSONdatafiles folder, at random
            let aDataFile = getFilesInBundleFolder(named:
    "JSONdatafiles",withExt: "").randomElement()
            do {
                let theData = try Data(contentsOf: aDataFile!) //get the contents of that file as data
                do {
                    let jsonResult = try
    JSONSerialization.jsonObject(with: theData,options:
    JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    let theTopicData = (jsonResult as? NSDictionary)
                    let gameGenre = theTopicData!["genre"] as! String
                    theGameGenre = gameGenre //copied so we can see the var outside of this block
                    let tempArray = theTopicData!["list"]
                    let gamePhrases = tempArray as! [String]
                    //compiler complains if we just try to assign this String array to a standard Swift one
                    //so instead, we extract individual strings and add them to our larger scope var
                    for aPhrase in gamePhrases { //done so we can see the var outside of this block
                        theGamePhrases.append(aPhrase)
                    }
                } catch {
                    print("couldn't decode JSON data")
                }
            } catch {
                print("couldn't retrieve data from JSON file")
            }
            return (theGamePhrases,theGameGenre) //tuple composed ofArray of phrase Strings and genre
        }

}

