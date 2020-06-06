//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import Alamofire

internal enum ServerRequestRouter: URLRequestConvertible{
    
    static var baseURLString:String{
        return "http://starlord.hackerearth.com/beercraft"
    }
    
    case getBeers
    
    var httpMethod:Alamofire.HTTPMethod {
        switch self {
        case .getBeers:
           return .get
        }
    }
    
    var path: String {
        switch self {
        case .getBeers:
            
            // changedd
            return FurnitureModel.shared.myURL
//            return ServerRequestRouter.baseURLString
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: path)!
        var mutableURLRequest = URLRequest(url: URL)
        mutableURLRequest.httpMethod = httpMethod.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch  self {
        case .getBeers:
            do {
                let encoding =  URLEncoding(destination: URLEncoding.Destination.queryString)
                return try encoding.encode(mutableURLRequest, with: nil)
                
            } catch {
                return mutableURLRequest
            }
        }
    }
}
