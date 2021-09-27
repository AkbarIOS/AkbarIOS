//
//  MainRootView.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit
import SnapKit
import MapKit
protocol MainRootViewIxResponder: AnyObject {
    func onCollectionScroll(row: Int)
}
class MainRootView: UIView {
    
    weak var map: MKMapView!
    weak var collectionView: UICollectionView!
    weak var ixResponder: MainRootViewIxResponder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = .blue
        setupMap()
        setupCollectionView()
    }
    
    private func setupMap() {
        let map = MKMapView()
        addSubview(map)
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.map = map
    }
    
    private func setupCollectionView() {
        let size = UIScreen.main.bounds
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
                    (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width - 32), heightDimension: .absolute(220))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width - 32), heightDimension: .absolute(220))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            section.interGroupSpacing = 16
            section.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
                let row = (visibleItems.last?.indexPath.row ?? 0) - 1
                self.ixResponder?.onCollectionScroll(row: row)
            })
            return section
        })
        
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        collectionView.transform = CGAffineTransform(translationX: 0, y: 250)
        collectionView.alpha = 0
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
        self.collectionView = collectionView
    }
}
