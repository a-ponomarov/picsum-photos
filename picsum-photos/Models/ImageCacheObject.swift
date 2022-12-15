//
//  ImageCacheObject.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation
import UIKit

final class ImageCacheObject {
    
    enum Entity {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    let entity: Entity
    init(entity: Entity) { self.entity = entity }
    
}
