//
//  Comment.swift
//  RxSwiftPractice
//
//  Created by Admin on 4/5/23.
//

import Foundation
import SwiftyJSON

class Comment: BaseModel {
    var postId: Int?
    var id: Int?
    var name: String?
    var email: String?
    var body: String?
    
    override func mapping(json: JSON) {
        postId = json["postId"].int
        id = json["id"].int
        name = json["name"].string
        email = json["email"].string
        body = json["body"].string
    }
}
