//
//  URLParamProvider.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/05/2020.
//  Copyright © 2020 IphoneGameZone. All rights reserved.
//

import Foundation

protocol URLParamProvider
{
    func urlParametersAsString<T>(fetcher:T)->String where T:Fetcher
}
