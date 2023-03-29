//
//  BaseModel.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import SwiftyJSON

class BaseModel: SwiftyJSONMappable{
    
    convenience required init(jsonObj: JSON) {
        self.init()
        self.mapping(json: jsonObj)
    }
    
    func mapping(json: JSON) {
        
    }
}

protocol SwiftyJSONMappable {
    init?(jsonObj: JSON)
}

extension Array where Element: SwiftyJSONMappable {
    init(jsonObj: JSON) {
        self.init()
        if jsonObj.type == .null {return}
        for item in jsonObj.arrayValue {
            if let obj = Element.init(jsonObj: item) {
                self.append(obj)
            }
        }
    }
}
