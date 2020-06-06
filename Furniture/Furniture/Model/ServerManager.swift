//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

public enum ServerErrorCodes: Int{
    case notFound = 404
    case validationError = 422
    case internalServerError = 500
    
}


public enum ServerErrorMessages: String{
    case notFound = "Not Found"
    case validationError = "Validation Error"
    case internalServerError = "Internal Server Error"
}


public enum ServerError: Error{
    case systemError(Error)
    case customError(String)
    
    public var details:(code:Int ,message:String){
        switch self {
            
        case .customError(let errorMsg):
            switch errorMsg {
            case "Not Found":
                return (ServerErrorCodes.notFound.rawValue,ServerErrorMessages.notFound.rawValue)
            case "Validation Error":
                return (ServerErrorCodes.validationError.rawValue,ServerErrorMessages.validationError.rawValue)
            case "Internal Server Error":
                 return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            default:
                return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            }
            
        case .systemError(let errorCode):
            return (errorCode._code,errorCode.localizedDescription)
        }
    }
}

public struct ServerManager{
    
     static let sharedInstance = ServerManager()
    
    
    func getAllFurniture(_ handler:@escaping ([Furnitures?],ServerError?) -> Void) {

        let filepath = Bundle.main.path(forResource: "test", ofType: "json")
        let url = URL(fileURLWithPath: filepath!)
        let json  = try! Data(contentsOf: url)
        let jsonData = try! JSONSerialization.jsonObject(with: json, options: .allowFragments)
        var furnitData = jsonData as! [[String:Any]]
        var tempArray = Array<FurnitureData>()
        
        for temp in furnitData {
            tempArray.append(FurnitureData(JSON: temp)!)
        }
//        tempArray = furnitData
//        print(furnitData)
//
        handler(tempArray,nil)
////        let test = jsonData as! [[String:Any]]
//        for furn in furnitData {
//
//
//        }

//        let res = jsonStr as? [Furnitures?]

//        handler(furnitData,nil)

    }
    
    
    func getAllBeers(_ handler:@escaping ([Furnitures?],ServerError?) -> Void){
        
        Alamofire.request(ServerRequestRouter.getBeers).validate().responseArray {(response:DataResponse<[Furnitures]>) in
            
            switch response.result {
        
            case .success:
                if let beers = response.result.value{
                    handler(beers,nil)
                }
        
            case .failure(let error):
                print(error)
                if error.localizedDescription .contains("404"){
                    handler([],ServerError.customError("Not Found"))
                } else if error.localizedDescription.contains("422") {
                    handler([],ServerError.customError("Validation Error"))
                } else if error.localizedDescription.contains("500"){
                    handler([],ServerError.customError("Internal Server Error"))
                }
                else{
                    handler([],ServerError.systemError(error))
                }
            }
        }
    }
}
