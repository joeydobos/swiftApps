//
//  MuralViewCell.swift
//  NewBrightonMurals
//
//  Created by Joseph Dobos on 07/12/2022.
//

import UIKit



class MuralViewCell: UITableViewCell {

    
    //Sets labels and UIImageView for the custom cell
    @IBOutlet weak var muralImageView: UIImageView!
    @IBOutlet weak var muralDistance: UILabel!
    @IBOutlet weak var muralName: UILabel!

    @IBOutlet weak var myCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
