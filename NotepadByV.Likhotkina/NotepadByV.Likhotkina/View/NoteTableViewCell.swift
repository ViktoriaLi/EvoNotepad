//
//  NoteTableViewCell.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/9/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteTimeLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
}
