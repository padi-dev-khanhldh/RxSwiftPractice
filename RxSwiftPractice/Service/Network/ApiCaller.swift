//
//  ApiCaller.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/29/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class ApiCaller {
    static let shared = ApiCaller()
    private init() {
        
    }
    
    private var sessionManager:Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        return Session(configuration: configuration)
    }()
    
    func sendRequest(route: BaseRoute) -> Observable<Any?>{
        return Observable<Any?>.create {[weak self] observer in
            
            self?.sessionManager.request(route, method: route.method, parameters: route.params, encoding: route.paramEncoding, headers: route.headers)
                .response(completionHandler: { response in
                    DispatchQueue.global(qos: .background).async {
                        switch response.result {
                        case .success(let data):
                            switch response.response?.statusCode ?? 0{
                            case 200...299:
                                if let safedata = data {
                                    let jsonResult = self?.convertDataToJSON(data: safedata)
                                    if let jsonResult = jsonResult {
                                        observer.onNext(jsonResult)
                                    }
                                }
                            default:
                                observer.onNext(nil)
                                return
                            }
                        case .failure( _):
                            observer.onNext(nil)
                            return
                        }
                        observer.onCompleted()
                    }
                })
            return Disposables.create()
        }
        .do(onNext: { (data) in
            //print("onNext req \(Thread.isMainThread)")
        },onSubscribed: {
            //print("onSubcribed req on \(Thread.isMainThread)")
        })
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func convertDataToJSON(data: Data) -> JSON? {
        do {
            return try JSON(data: data)
        }
        catch {
            return nil
        }
    }
}
