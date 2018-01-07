//
//  DetailViewControllerTableCell.swift
//  aquti
//
//  Created by Wout Bauwens on 31/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import Foundation
import UIKit

class DetailViewControllerTableCell: UITableViewCell {
    
    
    @IBOutlet weak var Info: UILabel!
    @IBOutlet weak var Value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
