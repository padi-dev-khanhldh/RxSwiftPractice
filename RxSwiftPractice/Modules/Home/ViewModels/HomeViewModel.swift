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
    let publishComments = PublishSubject<[Comment]>()
    
    let disposeBag = DisposeBag()
    var postObservable: Observable<Any?>{
        publishPost.asObservable()
    }
    
    var commentObservable: Observable<[Comment]> {
        publishComments.asObservable()
    }
    var posts = [Post]()
    var searchPosts = [Post]()
    
    func getPost() {
        //        print("Hello")
        if posts.isEmpty {
            fetchPost()
            fetchCommentsForPosts()
        }
        else {
            publishPost.onNext(posts)
            //            publishPost.on(.completed)
        }
    }
    
    var zippedObservable: Observable<[Post]> {
        Observable.zip(postObservable,commentObservable) { [weak self] posts, comments -> [Post] in
            let postsWithComments =  (posts as! [Post]).map({ post -> Post in
                let id = post.postId
                let postComments = comments.filter({comment in comment.postId == id})
                post.comments = postComments
                return post
            })
            self?.posts = postsWithComments
            return self?.posts ?? []
        }.asObservable()
    }
    
    func fetchPost() {
        ApiCaller.shared.sendRequest(route: PostRoute(endpoint: .getPosts))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(with: publishPost, onNext: { [weak self] _, data in
                //print(Thread.isMainThread)
                self?.posts = ListPosts(jsonObj: data as! JSON).posts!
                self?.publishPost.onNext(self?.posts)
                //                self?.publishPost.on(.completed)
            }).disposed(by: disposeBag)
    }
    
    func searchPostWithTitle(with title: String) -> Observable<[Post]> {
        return Observable.just(posts).compactMap{ [weak self] posts in
            self?.searchPosts = posts.filter{$0.title?.lowercased().contains(title.lowercased()) ?? false}
            return self?.searchPosts
        }
        
    }
    
    func fetchCommentsForPosts() {
        ApiCaller.shared.sendRequest(route: CommentsRoute(endpoint: .getAllComments))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            
            .subscribe(with: publishPost, onNext: { [weak self] _, data in
                //print(Thread.isMainThread)
                let comments: [Comment] = [Comment](jsonObj: data as! JSON)
                self?.publishComments.onNext(comments)
            }).disposed(by: disposeBag)
    }
}
