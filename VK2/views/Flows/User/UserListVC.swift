//
//  UserListVC.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit
import RealmSwift

class UserListVC: UITableViewController {
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    lazy var photoService: PhotoService = PhotoService(container: tableView)
    
    
    lazy var userService: UserService? = {
        guard let tabsVC = navigationController?.tabBarController as? TabsVC else { return nil}
        let userService = UserService(environment: EnvironmentImp.Debug(), token: tabsVC.token)
        return userService
    }()
    
    var users: Results<User>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        userService?.dowloadFriends()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        guard let user = users?[indexPath.row] else { return cell }
        cell.nameView.text = user.fullName
        cell.avatarView.image = photoService.photo(atIndexpath: indexPath, byUrl: user.photoUrl)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto",
            let ctrl = segue.destination as? PhotoListVC,
            let indexpath = tableView.indexPathForSelectedRow,
            let id = users?[indexpath.row].id {
            
            ctrl.userId = id
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }

        users = realm.objects(User.self)
        
        token = users?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    

}
