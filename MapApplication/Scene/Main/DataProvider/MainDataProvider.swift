//
//  MainDataProvider.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit

class MainDataProvider: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.isPagingEnabled = true
            collectionView.alwaysBounceVertical = false
            collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.className)
        }
    }
    
    var venues: [VenueAnnotation]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.venues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.className, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: self.venues?[indexPath.row])
        return cell
    }
    
}

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
