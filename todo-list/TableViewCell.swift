//
//  TableViewCell.swift
//  todo-list
//
//  Created by Joakim Hellgren on 2021-01-31.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!

    
    public func configure(text: String?) {
        guard let text = text else { return }
        label.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
