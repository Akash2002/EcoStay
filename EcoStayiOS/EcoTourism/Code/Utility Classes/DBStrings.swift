//
//  DBStrings.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/10/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation

enum DBGlobal: String {
    
    case LeasedPlaces = "Leased Places"
    case DateOfBirth = "DOB"
    case Name = "Name"
    case Phone = "Phone"
    case Email = "Email"
    case BookedPlaces = "BookedPlaces"
    case FinishedPlaces = "FinishedPlaces"
    
    enum Specific: String {
        case Address = "Address"
        case Amenities = "Amenities"
        case Description = "Description"
        case Price = "Price"
        case Rating = "Rating"
        case RatingNum = "RatingNum"
        case NumRented = "NumRented"
    }
    
    enum LeasedPlaceDetails: String {
        case From = "FromWhen"
        case To = "ToWhen"
    }
    
}
