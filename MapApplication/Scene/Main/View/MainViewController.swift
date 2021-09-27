//
//  MainViewController.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit
import MapKit

class MainViewController: UIViewController, ViewSpecificController {
    typealias RootView = MainRootView
    
    let viewModel = MainViewModel()
    let dataProvider = MainDataProvider()
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        setupMap()
        bind()
    }

}
extension MainViewController {
    fileprivate func appearanceSettings() {
        self.view = MainRootView()
        self.dataProvider.collectionView = self.view().collectionView
    }
    
    fileprivate func bind() {
        viewModel.venues.asObservable().subscribe(onNext: { venues in
            guard let annotations = venues?.response?.venues?.map({ venue -> VenueAnnotation in
                return VenueAnnotation(title: venue.name, locationName: venue.location?.address, coordinate: CLLocationCoordinate2D(latitude: venue.location?.lat ?? 0, longitude: venue.location?.lng ?? 0))
            }) else { return }
            self.view().map.addAnnotations(annotations)
            self.dataProvider.venues = annotations
            self.animatieColletion()
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.isLoading.asObservable().subscribe(onNext: { isLoading in
            print("Сюда можно прикрепить loader :)")
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.error.asObservable().subscribe(onNext: { error in
            self.showCustomAlert(title: error.name, message: error.reason, code: error.code, viewController: self)
        }).disposed(by: viewModel.disposeBag)
        
        self.view().ixResponder = self
    }
    
    fileprivate func setupMap() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func animatieColletion() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.view().collectionView.alpha = 1.0
            self.view().collectionView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func showCustomAlert(title:String,message:String,code:Int,viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
    }
}
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last! as CLLocation
        let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        self.view().map.centerToLocation(initialLocation)
        self.view().map.addAnnotations([])
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.locationManager = nil
        self.viewModel.getVenues(lon: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
    }
}


extension MainViewController: MainRootViewIxResponder {
    func onCollectionScroll(row: Int) {
        guard let item = self.view().collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? MainCollectionViewCell, let annotation = item.model, let lat = item.model?.coordinate.latitude, let lon = item.model?.coordinate.longitude else { return }
        let location = CLLocation(latitude: lat, longitude: lon)
        self.view().map.centerToLocation(location)
        self.view().map.selectAnnotation(annotation, animated: true)
    }
}
