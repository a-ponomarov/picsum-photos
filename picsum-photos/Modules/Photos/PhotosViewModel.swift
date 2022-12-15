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
    private var hideFooter: (() -> Void)?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    private var task: Task<(), Never>?
    
    private var items: [Photo] {
        dataSource.snapshot().itemIdentifiers
    }
    
    init(photosAPI: PhotosAPI = PhotosAPI(), imagesAPI: ImagesAPI = ImagesAPI()) {
        self.photosAPI = photosAPI
        self.imagesAPI = imagesAPI
    }
    
    deinit {
        task?.cancel()
    }
    
    func photoDetailsViewModel(index: Int) -> PhotoDetailsViewModel {
        PhotoDetailsViewModel(photo: items[index])
    }
    
    func willDisplay(_ index: Int) {
        guard index == dataSource.snapshot().numberOfItems - 1 else { return }
        fetch()
    }
    
    func fetch() {
        guard isNextPageExist, !isFetching else { return }
        task = Task { [weak self] in
            do {
                self?.isFetching = true
                guard let (newItems, isNext) = try await self?.photosAPI.photos(page: page) else { return }
                self?.isNextPageExist = isNext
                self?.page += 1
                self?.isFetching = false
                self?.appendToSnapshot(newItems: newItems)
                if !isNext {
                    self?.hideFooter?()
                }
            } catch {
                self?.isFetching = false
                self?.handleError(error: error)
            }
        }
    }
    
    func setupDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Photo) -> UICollectionViewCell? in
            let identifier = PhotoCollectionViewCell.reuseIdentifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                          for: indexPath) as! PhotoCollectionViewCell
            Task { [weak self] in
                let image = await self?.loadImage(index: indexPath.item, size: cell.frame.size)
                cell.imageView.image = image
            }
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems([])
        dataSource.apply(initialSnapshot, animatingDifferences: true)
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let reuseIdentifier = ActivityIndicatorView.reuseIdentifier
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                       withReuseIdentifier: reuseIdentifier,
                                                                       for: indexPath)
            return view
        }
        
        hideFooter = {
            let layout = collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout
            layout?.configuration = UICollectionViewCompositionalLayoutConfiguration()
        }
    }
    
    private func loadImage(index: Int, size: CGSize) async -> UIImage? {
        do {
            let path = items[index].path(size: size)
            let image = try await imagesAPI.image(path: path)
            return image
        } catch {
            handleError(error: error)
        }
        return nil
    }
    
    private func appendToSnapshot(newItems: [Photo]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private enum Section {
        case main
    }
    
}
