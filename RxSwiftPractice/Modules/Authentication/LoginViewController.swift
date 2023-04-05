//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/28/23.
//

import UIKit
import GoogleSignIn
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    let dbag = DisposeBag()
    @IBOutlet weak var btnGGSignIn: GIDSignInButton!
    let viewModel = AuthenticationViewModel()
    @IBAction func btnGGSignInClicked(_ sender: GIDSignInButton) {
        viewModel.signInWithGoogle(root: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.so.subscribe(onNext: { [weak self] token in
            if token != nil {
                let home = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                self?.navigationController?.navigationItem.hidesBackButton = true
                self?.navigationController?.pushViewController(home, animated: true)
                self?.navigationController?.viewControllers.removeAll(where: { $0 === self?.`self`()})
                
            }
        }).disposed(by: dbag)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    deinit {
        print("Loginview denit")
    }
}

