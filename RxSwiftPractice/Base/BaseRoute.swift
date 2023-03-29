//
//  BaseRouter.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import Alamofire

class BaseRoute: URLConvertible {
    func asURL() throws -> URL {
//        guard var urlComponents = URLComponents(string: Constant.baseUrl + contextPath) else { return try (Constant.baseUrl + contextPath).asURL() }
//        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: Constant.api_key)]
//        return try urlComponents.asURL()
        print(Constant.baseUrl+contextPath+path!)
        return try (Constant.baseUrl+contextPath+path!).asURL()
    }
    
    var path: String? {
        fatalError("Must override ")
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var params: Parameters? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var paramEncoding: ParameterEncoding {
        fatalError("Must override")
    }
    
    var contextPath: String {
        return ""
    }
    
    
}
