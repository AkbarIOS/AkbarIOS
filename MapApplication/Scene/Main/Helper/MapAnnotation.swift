//
//  MapAnnotation.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
