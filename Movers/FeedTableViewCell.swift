//
//  FeedTableViewCell.swift
//  Movers
//
//  Created by Michael Holler on 01/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var sportLabel = UILabel()
    var nameLabel = UILabel()
    
    var weightLabel = UILabel()
    var separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sportLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(separator)
        
        // style
        titleLabel.font = titleLabel.font.fontWithSize(18)
        dateLabel.font = dateLabel.font.fontWithSize(12)
        sportLabel.font = sportLabel.font.fontWithSize(12)
        nameLabel.font = nameLabel.font.fontWithSize(12)
        weightLabel.font = weightLabel.font.fontWithSize(24)
        separator.backgroundColor = UIColor.lightGrayColor()

        // layout
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        nameLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 1).active = true
        titleLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true

        sportLabel.translatesAutoresizingMaskIntoConstraints = false
        sportLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 1).active = true
        sportLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraintEqualToAnchor(sportLabel.bottomAnchor).active = true
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
