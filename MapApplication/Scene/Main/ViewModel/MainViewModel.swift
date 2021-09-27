//
//  MainViewModel.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import RxSwift
import RxRelay

class MainViewModel: DefaultViewModel {
    
    let venues: BehaviorRelay<VenuesModel?> = BehaviorRelay(value: nil)
    
    func getVenues(lon: Double, lat: Double) {
        let model = SearchVenueRequest(client_id: "U0LJNCU4NYQYNRWMT3Q4D23QLHC1M41ZHHU2HARMN2SUCEV3", client_secret: "N5GJL1M30NGVVZPIO5U53WG5TNY3CDUKL4W5Y0ESDUKRPJFI", v: "20120609", ll: "\(lat),\(lon)", intent: "checkin", raius: 200)
        guard let parameters = model.dictionary else { return }
        self.taskStarted.onNext(())
        NetworkAdapter<MainAPI, VenuesModel>(disposeBag: disposeBag).request(target: MainAPI.getPopularVenues(parameters: parameters)) { apiResponse in
            switch apiResponse {
            case .success(let response):
                self.venues.accept(response)
            case .failure(let error):
                self.error.onNext(error)
            }
            self.taskEnded.onNext(())
        }
    }
}
