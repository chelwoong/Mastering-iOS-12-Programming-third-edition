//
//  ContactCollectionViewCell.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 03/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }

}
