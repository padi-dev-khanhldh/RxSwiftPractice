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
    
    @IBOutlet weak var btnSignOut: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let authVM = AuthenticationViewModel()
    let homeVM = HomeViewModel()
    var isSearching = false
    let disposeBag = DisposeBag()
    var searchSubcription: Disposable!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        tableView.dataSource = self
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
            //print("Click log out")
            self?.showSignOutAlert()
        }).disposed(by: disposeBag)
        
        // sign out subcription
        authVM.so.subscribe(onNext: { [weak self] isSignOut in
            //print(isSignOut)
            if isSignOut != nil, let isSignOut = isSignOut as? Bool, isSignOut == true {
                let login = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                login.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(login, animated: true)
                self?.navigationController?.viewControllers.removeAll(where: { $0 === self?.`self`()})
            }
        }).disposed(by: disposeBag)
        
        // get posts with comments
        // (schedulers)update on mainthread
        homeVM.zippedObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                row, element, cell in
                cell.textLabel?.text = element.title
            }
            .disposed(by: disposeBag)
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
        //print("Home VC deinit")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(homeVM.posts.count)
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
        //print("hello")
        tableView.deselectRow(at: indexPath, animated: true)
        let commentVC = storyboard?.instantiateViewController(withIdentifier: "comVC") as! CommentViewController
        
        if !isSearching {
            commentVC.comments = homeVM.posts[indexPath.row].comments
        }
        else {
            commentVC.comments = homeVM.searchPosts[indexPath.row].comments
        }
        navigationController?.present(commentVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchSubcription == nil {
            print("subcribed")
            searchSubcription = homeVM.postObservable
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] data in
                    //                DispatchQueue.main.async {
                    print("onNext")
                    self?.tableView.reloadData()
                    //                }
                    
                })
            searchSubcription.disposed(by: disposeBag)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            //            tableView.delegate = nil
            isSearching = true
            tableView.dataSource = nil
            homeVM.searchPostWithTitle(with: searchText)
                .observe(on: MainScheduler.instance)
                .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                    row, element, cell in
                    cell.textLabel?.text = element.title
                }.disposed(by: disposeBag)
            
        }
        else {
            isSearching = false
            tableView.delegate = self
            tableView.dataSource = self
            homeVM.getPost()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
