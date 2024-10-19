//
//  CardViewCell.swift
//  Digidex
//
//  Created by riswan ardiansah on 15/10/24.
//

import UIKit

class CardViewCell: UICollectionViewCell {
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var labelCardView: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    cardView.layer.cornerRadius = 10
    cardView.clipsToBounds = true
    
    imageView.isHidden = true
  }
  
  func setImage(from url: String) {
    imageView.isHidden = false
    imageView.loadImage(from: URL(string: url)!)
  }
}
