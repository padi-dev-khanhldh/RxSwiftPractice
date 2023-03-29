//
//  HomeViewController.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/28/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var btnSignOut: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let authVM = AuthenticationViewModel()
    let homeVM = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        setUpSubcriptions()
        
        homeVM.getPost()
    }
    
    func setUpSubcriptions() {
        // button sign out subcription
        btnSignOut.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            print("Click log out")
            self?.showSignOutAlert()
        }).disposed(by: disposeBag)
        
        // sign out subcription
        authVM.so.subscribe(onNext: { [weak self] isSignOut in
            let login = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            login.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(login, animated: true)
            self?.navigationController?.viewControllers.removeAll(where: { $0 === self?.`self`()})
        }).disposed(by: disposeBag)
        
        // get post
        homeVM.postObservable.subscribe(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = true
    }
    func showSignOutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .actionSheet)
        let agree = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.authVM.signOutGoogle()
        }
        alert.addAction(agree)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    deinit {
        print("Home VC deinit")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeVM.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = homeVM.posts[indexPath.row].title
        return cell
    }
    
    
}
