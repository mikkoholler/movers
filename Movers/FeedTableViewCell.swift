//
//  FeedTableViewCell.swift
//  Movers
//
//  Created by Michael Holler on 01/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    var dateLabel = UILabel()
    var weightLabel = UILabel()
    var separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(separator)
        
        // style
        dateLabel.font = weightLabel.font.fontWithSize(14)
        weightLabel.font = weightLabel.font.fontWithSize(24)
        separator.backgroundColor = UIColor.lightGrayColor()

        // layout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        dateLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true

        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        weightLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        separator.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
        separator.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(3).active = true

    }

    // what should one do with this mess?
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
