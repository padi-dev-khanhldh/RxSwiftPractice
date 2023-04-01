//
//  HomeViewModel.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/28/23.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class HomeViewModel {
    let publishPost = PublishSubject<Any?>()
    let disposeBag = DisposeBag()
    var postObservable: Observable<Any?>{
        publishPost.asObservable()
    }
    var posts = [Post]()
    
    
    func getPost() {
        print("Hello")
        ApiCaller.shared.sendRequest(route: PostRoute(endpoint: .getPosts)).subscribe(with: publishPost, onNext: { [weak self] _, data in
            print(Thread.isMainThread)
            self?.posts = ListPosts(jsonObj: data as! JSON).posts!
            self?.publishPost.onNext(self?.posts)
        }).disposed(by: disposeBag)
    }
    
    func searchPostWithTitle(with title: String) -> Observable<[Post]> {
        
        return Observable.just(posts).compactMap({$0.filter({($0.title?.lowercased().contains(title.lowercased()))!})})
    }
}
