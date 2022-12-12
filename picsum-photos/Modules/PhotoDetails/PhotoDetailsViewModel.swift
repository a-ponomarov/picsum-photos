//
//  PhotoDetailsViewModel.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 09.12.2022.
//

import Foundation
import UIKit

@MainActor
final class PhotoDetailsViewModel: ObservableObject, ErrorHandler {
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    
    private let photo: Photo
    private let imagesAPI: ImagesAPI
    
    private var task: Task<(), Never>?
    
    var autorText: String {
        photo.author
    }
    
    init(photo: Photo, imagesAPI: ImagesAPI = ImagesAPI()) {
        self.photo = photo
        self.imagesAPI = imagesAPI
    }
    
    deinit {
        task?.cancel()
    }
    
    func loadImage(size: CGSize, grayscale: Bool = false, blur: Int? = nil) {
        let path = photo.path(size: size)
        task = Task { [weak self] in
            self?.isLoading = true
            do { image = try await self?.imagesAPI.image(path: path, grayscale: grayscale, blur: blur) }
            catch { self?.handleError(error: error) }
            self?.isLoading = false
        }
    }

}
