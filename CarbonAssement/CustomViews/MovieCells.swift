//
//  MovieCells.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import UIKit


class MovieCells: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var moveImage: UIImageView!
    
  // @IBOutlet weak var view: UIButton!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var ratingStar: FloatRatingView!

    @IBOutlet weak var ratings: UILabel!
    
//   @IBOutlet weak var favourite: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingStar.backgroundColor = UIColor.clear

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        //floatRatingView.delegate = self
        ratingStar.contentMode = UIView.ContentMode.scaleAspectFit
        ratingStar.type = .halfRatings
    }
    override func prepareForReuse(){
            super.prepareForReuse()
    }
}
