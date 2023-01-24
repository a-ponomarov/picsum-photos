//
//  SceneDelegate.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let storyboard = UIStoryboard(name: AppConstants.Storyboard.photos, bundle: .main)
        let identifier = String(describing: PhotosViewController.self)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        let viewModel = PhotosViewModel()
        (viewController as? PhotosViewController)?.viewModel = viewModel
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

