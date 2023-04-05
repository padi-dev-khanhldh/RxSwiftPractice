//
//  AuthenticationViewModel.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/28/23.
//

import Foundation
import GoogleSignIn
import RxSwift


enum MyError: Error {
    case signInFailed
}
class AuthenticationViewModel {
    func signInWithGoogle(root viewcontroller: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewcontroller) { [weak self] signInResult, error in
            guard let result = signInResult else {
                self?.authObservable.onNext(nil)
                self?.authObservable.onError(MyError.signInFailed)
                return
            }
            // If sign in succeeded, display the app's main content View.
            self?.authObservable.onNext(result.user.accessToken.tokenString)
            self?.authObservable.onCompleted()
        }
        
    }
    
    let authObservable = PublishSubject<Any?>()
    var so : Observable<Any?> {
        authObservable.asObservable()
    }
    
    func signOutGoogle(){
        GIDSignIn.sharedInstance.signOut()
        if GIDSignIn.sharedInstance.currentUser != nil {
            authObservable.onNext(false)
        }
        else {
            authObservable.onNext(true)
        }
        authObservable.onCompleted()
    }
    deinit {
        authObservable.dispose()
    }
}
