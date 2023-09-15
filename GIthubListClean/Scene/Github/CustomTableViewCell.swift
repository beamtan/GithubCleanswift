//
//  CustomTableViewCell.swift
//  GIthubListClean
//
//  Created by A667243 A667243 on 31/8/2566 BE.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func likeButtonTapped(forCell cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var githubURL: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    weak var delegate: CustomTableViewCellDelegate?
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.likeButtonTapped(forCell: self)
    }
    
}
