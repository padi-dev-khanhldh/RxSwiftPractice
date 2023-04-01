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
    @IBOutlet weak var searchBar: UISearchBar!
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
        tableView.delegate = self
        setUpSubcriptions()
        
        setUpSearchBar()
        homeVM.getPost()
    }
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
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
        // (schedulers)update on mainthread
        homeVM.postObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                //                DispatchQueue.main.async {
                print(Thread.isMainThread)
                self?.tableView.reloadData()
                //                }
                
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            //            tableView.delegate = nil
            tableView.dataSource = nil
            homeVM.searchPostWithTitle(with: searchText)
                .observe(on: MainScheduler.instance)
                .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                    row, element, cell in
                    cell.textLabel?.text = element.title
                }.disposed(by: disposeBag)
            
        }
        else {
            tableView.delegate = self
            tableView.dataSource = self
            homeVM.getPost()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
