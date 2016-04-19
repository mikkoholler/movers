//
//  FeedTableViewCell.swift
//  Movers
//
//  Created by Michael Holler on 01/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    var feedid = Int()
    var avatarView = UIImageView()
    var nameLabel = UILabel()
    var sportLabel = UILabel()
    var dateLabel = UILabel()
    var moodLabel = UILabel()
    var descLabel = UILabel()
    var actionLabel = UILabel()
    var cheerLabel = UILabel()
    var commentLabel = UILabel()
    
    var weightLabel = UILabel()
    var separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sportLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moodLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(actionLabel)
        contentView.addSubview(cheerLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(separator)
        
        // style
        avatarView.backgroundColor = UIColor.lightGrayColor()
        avatarView.contentMode = .ScaleAspectFill
        avatarView.clipsToBounds = true

        nameLabel.font = nameLabel.font.fontWithSize(12)
        sportLabel.font = sportLabel.font.fontWithSize(14)
        moodLabel.font = moodLabel.font.fontWithSize(12)
        dateLabel.font = dateLabel.font.fontWithSize(12)
        descLabel.font = descLabel.font.fontWithSize(12)
        descLabel.numberOfLines = 0
        actionLabel.font = .boldSystemFontOfSize(12)
        actionLabel.textColor = .darkGrayColor()

        cheerLabel.font = cheerLabel.font.fontWithSize(12)
        cheerLabel.numberOfLines = 0
        commentLabel.font = cheerLabel.font.fontWithSize(12)
        commentLabel.numberOfLines = 0

        weightLabel.font = weightLabel.font.fontWithSize(24)
        separator.backgroundColor = UIColor.lightGrayColor()

        actionLabel.text = "Double tap to cheer"

        // layout
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 3).active = true
        avatarView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true
        avatarView.widthAnchor.constraintEqualToConstant(48).active = true
        avatarView.heightAnchor.constraintEqualToConstant(48).active = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraintEqualToAnchor(avatarView.topAnchor).active = true
        nameLabel.leftAnchor.constraintEqualToAnchor(avatarView.rightAnchor, constant: 3).active = true

        sportLabel.translatesAutoresizingMaskIntoConstraints = false
        sportLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 1).active = true
        sportLabel.leftAnchor.constraintEqualToAnchor(avatarView.rightAnchor, constant: 3).active = true

        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        moodLabel.centerYAnchor.constraintEqualToAnchor(sportLabel.centerYAnchor).active = true
        moodLabel.leftAnchor.constraintEqualToAnchor(sportLabel.rightAnchor, constant: 3).active = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraintEqualToAnchor(sportLabel.bottomAnchor, constant: 1).active = true
        dateLabel.leftAnchor.constraintEqualToAnchor(avatarView.rightAnchor, constant: 3).active = true

        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraintEqualToAnchor(avatarView.bottomAnchor, constant: 3).active = true
        descLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true
        descLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -3).active = true

        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.topAnchor.constraintEqualToAnchor(descLabel.bottomAnchor, constant: 3).active = true
        actionLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true
        actionLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -3).active = true

        cheerLabel.translatesAutoresizingMaskIntoConstraints = false
        cheerLabel.topAnchor.constraintEqualToAnchor(actionLabel.bottomAnchor).active = true
        cheerLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true
        cheerLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -3).active = true

        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraintEqualToAnchor(cheerLabel.bottomAnchor).active = true
        commentLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: 3).active = true
        commentLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -3).active = true
        
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        weightLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraintEqualToAnchor(commentLabel.bottomAnchor, constant: 3).active = true
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
