//
//  PhotosViewController.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: PhotosViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetch()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = CompositionalLayoutFactory.layout(.photos)
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.reuseIdentifier, bundle: .main),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.register(ActivityIndicatorView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: ActivityIndicatorView.reuseIdentifier)
        viewModel.setupDataSource(collectionView: collectionView)
    }
    
    private func fetch() {
        viewModel.fetch()
    }

}

extension PhotosViewController:  UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.willDisplay(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let nibName = String(describing: PhotoDetailsViewController.self)
        let viewController = PhotoDetailsViewController(nibName: nibName, bundle: .main)
        viewController.viewModel = viewModel.photoDetailsViewModel(index: indexPath.item)
        present(viewController, animated: true)
    }

}
