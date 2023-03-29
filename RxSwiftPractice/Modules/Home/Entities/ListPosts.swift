//
//  ListPosts.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import SwiftyJSON
class ListPosts: BaseModel {
    var posts: [Post]?
    override func mapping(json: JSON) {
        posts = [Post](jsonObj: json)
    }
}
