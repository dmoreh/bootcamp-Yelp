//
//  SwitchCell.swift
//  Yelp
//
//  Created by Daniel Moreh on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!

    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: .ValueChanged)
    }

    func switchValueChanged() {
        self.delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }
}
