//
//  PostRoute.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import Alamofire
enum PostEndpoint {
    case getPosts, getPostWithId(id: Int)
}
class PostRoute: BaseRoute {
    var endpoint: PostEndpoint
    init(endpoint: PostEndpoint) {
        self.endpoint = endpoint
    }
    override var path: String? {
        switch endpoint {
        case .getPosts:
            return "posts/"
        case .getPostWithId(let id):
            return "posts/\(id)/"
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
        case .getPosts, .getPostWithId:
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
