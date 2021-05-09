//
//  Movie.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import UIKit
import AlamofireImage

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.contentMode = .scaleAspectFill
        // Initialization code
    }
    
    func setImage(path: String) {
        let urlString = WebServices.imagesUrl + path
        posterImageView.image = nil
        if let url = URL(string: urlString) {
            posterImageView.af.setImage(withURL: url , placeholderImage: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
}
