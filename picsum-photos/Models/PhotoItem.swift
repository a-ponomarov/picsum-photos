//
//  PhotoItem.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 10.12.2022.
//

import Foundation
import UIKit.UIImage

final class PhotoItem {
    let photo: Photo
    var image: UIImage?
    
    init(photo: Photo, image: UIImage? = nil) {
        self.photo = photo
        self.image = image
    }
    
    func update(image: UIImage?) {
        self.image = image
    }
    
}

extension PhotoItem: Hashable {
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(photo.id)
    }
    
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        lhs.photo.id == rhs.photo.id
    }
    
}
