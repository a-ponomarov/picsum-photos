//
//  PhotosViewModel.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation
import UIKit

@MainActor
final class PhotosViewModel: ObservableObject, ErrorHandler {
    
    private var page = 1
    private let photosAPI: PhotosAPI
    private let imagesAPI: ImagesAPI
    private var isFetching = false
    private var isNextPageExist = true
    private var items: [PhotoItem] = []
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoItem>!
    
    private var task: Task<(), Never>?
    
    var count: Int {
        return items.count
    }
    
    init(photosAPI: PhotosAPI = PhotosAPI(), imagesAPI: ImagesAPI = ImagesAPI()) {
        self.photosAPI = photosAPI
        self.imagesAPI = imagesAPI
    }
    
    deinit {
        task?.cancel()
    }
    
    func photoDetailsViewModel(index: Int) -> PhotoDetailsViewModel {
        PhotoDetailsViewModel(photo: items[index].photo)
    }
    
    func fetch() {
        guard isNextPageExist, !isFetching else { return }
        isFetching = true
        task = Task { [weak self] in
            do {
                guard let (photos, isNext) = try await self?.photosAPI.photos(page: page) else { return }
                let newItems = photos.map { PhotoItem(photo: $0) }
                self?.items.append(contentsOf: newItems)
                self?.appendToSnapshot(newItems: newItems)
                self?.isNextPageExist = isNext
                self?.page += 1
            } catch {
                self?.handleError(error: error)
            }
            self?.isFetching = false
        }
    }
    
    func setupDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoItem>(collectionView: collectionView) { [unowned self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: PhotoItem) -> UICollectionViewCell? in
            let identifier = PhotoCollectionViewCell.reuseIdentifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                          for: indexPath) as! PhotoCollectionViewCell
            let item = self.items[indexPath.item]
            cell.imageView.image = item.image
            
            guard item.image == nil else { return cell }
            Task { [weak self] in
                let image = await self?.loadImage(index: indexPath.item, size: cell.frame.size)
                guard let image else { return }
                item.image = image
                self?.reloadSnapshot(items: [item])
            }
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, PhotoItem>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems([])
        dataSource.apply(initialSnapshot, animatingDifferences: true)
        
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let reuseIdentifier = ActivityIndicatorView.reuseIdentifier
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: reuseIdentifier,
                                                                       for: indexPath) as! ActivityIndicatorView
            view.indicator.isHidden = !self.isFetching
            return view
        }
    }
    
    private func loadImage(index: Int, size: CGSize) async -> UIImage? {
        do {
            let path = items[index].photo.path(size: size)
            let image = try await imagesAPI.image(path: path)
            return image
        } catch {
            handleError(error: error)
        }
        return nil
    }
    
    private func appendToSnapshot(newItems: [PhotoItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func reloadSnapshot(items: [PhotoItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(items)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private enum Section {
        case main
    }
    
}
