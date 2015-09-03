//
//  CustomRepoCell.swift
//  GithubDemo
//
//  Created by Nguyen Xuan Gieng on 9/3/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class CustomRepoCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbFork: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func parseRepoData(repo: GithubRepo) {
        lbName.text = repo.name!
        lbDescription.text = repo.description!
        lbOwner.text = repo.ownerHandle!
        lbFork.text = "\(repo.forks!)"
        lbStar.text = "\(repo.stars!)"
        
        // get avatar
        var avatarURL = NSURL(string: repo.ownerAvatarURL!)
        var request = NSURLRequest(URL: avatarURL!)
        var placeHolderImage = UIImage(named: "placeHolder")
        
        avatar.setImageWithURLRequest(request,
            placeholderImage: placeHolderImage,
            success:
            { (request: NSURLRequest!,
                respone: NSHTTPURLResponse!,
                image: UIImage!) -> Void in
            self.avatar.image = image
        
            }, failure: nil)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
