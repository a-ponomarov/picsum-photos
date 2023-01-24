//
//  Photo.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation
import UIKit

struct Photo: Decodable, Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    
    func path(size: CGSize) -> String {
        let width = Int(size.width) < width ? Int(size.width) : width
        let height = Int(size.height) < height ? Int(size.height) : height
        return "/id/\(id)/\(width)/\(height).webp"
    }

}
