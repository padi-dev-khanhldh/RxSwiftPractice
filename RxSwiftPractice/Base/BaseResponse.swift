//
//  BaseResponse.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import SwiftyJSON
enum BaseResponse {
    case success(result: JSON)
    case APIError
    case HTTPError
}
