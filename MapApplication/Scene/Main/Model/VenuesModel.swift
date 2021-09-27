//
//  VenuesModel.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation

struct VenuesModel: APIData {
    var meta: Meta?
    var response: VenueResponse?
}

struct VenueResponse: Codable {
    var venues: [Venue]?
}

struct Venue: Codable {
    var id: String?
    var name: String?
    var location: VenueLocation?
}

struct VenueLocation: Codable {
    var address: String?
    var lat: Double?
    var lng: Double?
    var distance: Double?
    var cc: String?
    var city: String?
    var state: String?
}

struct SearchVenueRequest: Codable {
    var client_id: String?
    var client_secret: String?
    var v: String?
    var ll: String?
    var intent: String?
    var raius: Int?
}
