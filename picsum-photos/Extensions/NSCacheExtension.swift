//
//  NSCacheExtension.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation

extension NSCache where KeyType == NSURL, ObjectType == ImageCacheObject {
    
    subscript(_ url: URL) -> ImageCacheObject.Entity? {
        get {
            object(forKey: url as NSURL)?.entity
        }
        set {
            newValue == nil ? removeObject(forKey: url as NSURL) :
            setObject(ImageCacheObject(entity: newValue!), forKey: url as NSURL)
        }
    }

}
