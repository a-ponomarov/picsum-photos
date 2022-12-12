//
//  PhotoDetailsViewController.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 09.12.2022.
//

import UIKit
import Combine

class PhotoDetailsViewController: UIViewController {
    
    var viewModel: PhotoDetailsViewModel!
    
    private var cancellableSet = Set<AnyCancellable>()

    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var autorLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var imageSize: CGSize {
        return imageView.frame.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadImage(size: imageView.frame.size)
    }
    
    private func setup() {
        autorLabel.text = viewModel.autorText
        cancellableSet.insert(viewModel.$image
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: imageView))
        cancellableSet.insert(viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.activityIndicator.isHidden = !isLoading
                self?.segmentedControl.isEnabled = !isLoading
                self?.slider.isEnabled = !isLoading
            }))
    }

    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        viewModel.loadImage(size: imageSize, blur: Int(sender.value))
    }
    
    @IBAction private func segmentChanged(_ sender: UISegmentedControl) {
        guard let segment = Segment(rawValue: sender.selectedSegmentIndex) else { return }
        switch segment {
        case .normal:
            viewModel.loadImage(size: imageSize)
        case .grayscale:
            viewModel.loadImage(size: imageSize, grayscale: true)
        case .blur:
            viewModel.loadImage(size: imageSize, blur: Int(slider.value))
        }
        slider.isHidden = segment != .blur
    }
    
    @IBAction private func dismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private enum Segment: Int {
        case normal, grayscale, blur
    }

}
