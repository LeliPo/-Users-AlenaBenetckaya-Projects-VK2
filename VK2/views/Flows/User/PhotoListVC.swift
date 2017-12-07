//
//  PhotoListVC.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit

class PhotoListVC: UICollectionViewController {
    
    var userId = 0
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    
    lazy var photoService = PhotoService(container: collectionView!)
    
    lazy var userService: UserService? = {
        guard let tabsVC = navigationController?.tabBarController as? TabsVC else { return nil}
        let userService = UserService(environment: EnvironmentImp.Debug(), token: tabsVC.token)
        return userService
    }()
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUPhoto()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        
        cell.photoView.image = photoService.photo(atIndexpath: indexPath, byUrl: photos[indexPath.row].url)
    
        return cell
    }
    
    func showUPhoto() {
        userService?.downloadPhoto(forUser: userId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView?.reloadData()
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
