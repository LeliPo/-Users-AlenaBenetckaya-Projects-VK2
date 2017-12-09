//
//  GroupCell.swift
//  VK2
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
