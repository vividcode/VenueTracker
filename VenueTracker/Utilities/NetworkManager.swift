//
//  NetworkManager.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
typealias DATA_DOWNLOADED_BLOCK = (Array<Any>) -> Void
typealias NO_DATA_BLOCK = () -> Void
typealias DOWNLOAD_ERROR_BLOCK = (Error) -> Void

class NetworkManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate
{
    static let sharedInstance: NetworkManager = NetworkManager()
    
    var session : URLSession
    var opQueue : OperationQueue
    
    override init()
    {
        self.opQueue = OperationQueue()
        let configuration = URLSessionConfiguration.default

        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: self.opQueue)
        
        super.init()
    }
    
    func makeGetRequest(urlStr: String, timeOut: TimeInterval)->URLRequest
    {
        let encodedUrlStr =  (URLConstants.BaseURL.rawValue + urlStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var rq = URLRequest(url: URL(string: encodedUrlStr!)!)
        
        let headers = [
            "x-rapidapi-host": URLConstants.HostHeader.rawValue,
            "x-rapidapi-key": URLConstants.APIKeyHeader.rawValue
        ]
        
        rq.allHTTPHeaderFields = headers

        rq.httpMethod = "GET"
        rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        rq.addValue("application/json", forHTTPHeaderField: "Accept")
        rq.timeoutInterval = timeOut
        
        return rq
    }
    
    func fetchFromRest(urlStr: String, timeOut: TimeInterval, dataDownloadedBlock: @escaping DATA_DOWNLOADED_BLOCK, noDataBlock: @escaping NO_DATA_BLOCK, errorBlock: @escaping DOWNLOAD_ERROR_BLOCK)
    {
        let urlReq = self.makeGetRequest(urlStr: urlStr, timeOut: timeOut)
        let dataTask = self.session.dataTask(with: urlReq) { (data, urlResp, err) in
            do
            {
                if (err != nil)
                {
                    throw err!
                }
                
                guard let data = data
                    else
                {
                    noDataBlock()
                    return
                }
                guard let resultJson = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String:Any]
                    else
                {
                    throw JSONError.ConversionFailed
                }
                
                guard let resultArray:[Any] = resultJson["data"] as? [Any] else
                {
                    throw JSONError.ConversionFailed
                }
                
                dataDownloadedBlock(resultArray)
            }
            catch let error as JSONError
            {
                print(error.rawValue)
                errorBlock(error)
            }
            catch let error as NSError
            {
                print(error.debugDescription)
                errorBlock(error)
            }
        }
        
        dataTask.resume()
    }
}
