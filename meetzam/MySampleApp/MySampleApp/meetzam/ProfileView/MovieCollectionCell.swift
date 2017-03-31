//
//  MovieCollectionCell.swift
//  MySampleApp
//
//  Created by 孟琦 on 2/28/17.
//
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func prepareForReuse() {
        movieImage.image = nil
        movieTitleLabel.text = nil
    }
}
