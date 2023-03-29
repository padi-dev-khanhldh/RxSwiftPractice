//
//  Post.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import SwiftyJSON

class Post: BaseModel {
    
    var userId: Int?
    var postId: Int?
    var title: String?
    var body: String?
    override func mapping(json: JSON) {
        userId = json["userId"].int
        postId = json["id"].int
        title = json["title"].string
        body = json["body"].string
    }
}
