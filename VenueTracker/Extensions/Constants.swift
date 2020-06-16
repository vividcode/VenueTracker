//
//  Error.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

//TODO: Contents of this file must be ENCRYPTED...

import Foundation

enum JSONError: String, Error
{
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

enum  CoreDataCustomError: String, Error {
    case ObjectNotFound = "ERROR: Core Data Object Not Found"
}

enum FileErrors : String, Error
{
    case BadEnumeration = "Could not enumerate files in directory."
    case BadResource = "Could not create file URL."
}

enum URLConstants: String, RawRepresentable
{
    case BaseURL = "https://tripadvisor1.p.rapidapi.com/"
    case APIKeyHeader = "a7569f10cfmsh024e5e5a26cfa9dp1521c8jsn59ecc7c8824b"
    case HostHeader = "tripadvisor1.p.rapidapi.com"
}

struct RestFetchInterval
{
    static let VenueList = 10.0
}

struct ResultLimit
{
    static let VenueList = 15
}


