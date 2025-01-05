//
//  QuoteTableViewCell.swift
//  InspoQuotes
//
//  Created by Omar Assidi on 05/01/2025.
//  Copyright © 2025 London App Brewery. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCellWithItem(quote: String) {
        textLabel?.text = quote
        textLabel?.numberOfLines = 0
        textLabel?.textColor = .white
        accessoryType = .none
    }

}
