//
//  DetailViewController.swift
//  NewBrightonMurals
//
//  Created by Joseph Dobos on 12/12/2022.
//

import UIKit




class DetailViewController: UIViewController {
    
    
    
    
    // sets the url to the image of the correct mural
    let urls = URL(string:"https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm_images/" + selectedMurals.5)
        
    // Label outlets for
    @IBOutlet weak var muralImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads image
        muralImage.load(url: urls!)
        
        //sets all the labels to the correct mural data 
        nameLabel.text = "Mural Name: " + selectedMurals.1
        infoLabel.text = "Mural Info: " + selectedMurals.2
        artistLabel.text = "Artist: " + selectedMurals.3
        

        // Do any additional setup after loading the view.
    }
    
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


