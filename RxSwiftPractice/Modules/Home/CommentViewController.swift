//
//  CommentViewController.swift
//  RxSwiftPractice
//
//  Created by Admin on 4/5/23.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var comments: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "commentcell")
        tableView.dataSource = self
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath)
        let commentor = (comments[indexPath.row].email ?? "Unknow user") + ": "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:commentor, attributes:attrs)
        let cmtBody = comments[indexPath.row].body ?? ""
        let normalString = NSMutableAttributedString(string:cmtBody)
        attributedString.append(normalString)
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.textAlignment = .natural
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
