//
//  PhotoCollectionViewCell.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PhotoCollectionViewCell.self)

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
