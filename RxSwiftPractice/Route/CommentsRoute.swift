//
//  CommentsRoute.swift
//  RxSwiftPractice
//
//  Created by Admin on 4/5/23.
//

import Foundation
import Alamofire

enum CommentEndpoint {
    case getAllComments
}
class CommentsRoute: BaseRoute {
    var endpoint: CommentEndpoint
    init(endpoint: CommentEndpoint) {
        self.endpoint = endpoint
    }
    override var path: String? {
        switch endpoint {
        case .getAllComments:
            return "comments/"
        
        }
    }
    
    override var headers: HTTPHeaders? {
        return nil
    }
    
    override var params: Parameters? {
        return nil
    }
    
    override var method: HTTPMethod {
        switch endpoint {
        case .getAllComments:
            return .get
        default:
            return .post
        }
    }
    
    override var paramEncoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    override var contextPath: String {
        return ""
    }
}
