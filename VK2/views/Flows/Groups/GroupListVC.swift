//
//  GroupList.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit
import RealmSwift

class GroupListVC: UITableViewController {
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    
    lazy var photoService = PhotoService(container: tableView)
    
    lazy var groupService: GroupService? = {
        guard let tabsVC = navigationController?.tabBarController as? TabsVC else { return nil}
        let groupService = GroupService(environment: EnvironmentImp.Debug(), token: tabsVC.token)
        return groupService
    }()
    
    var groups: Results<Group>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        groupService?.dowloadGroups()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        guard let group = groups?[indexPath.row] else { return cell }
        
        cell.nameView.text = group.name
        cell.avatarView.image = photoService.photo(atIndexpath: indexPath, byUrl: group.photoUrl)

        return cell
    }
    
//    override func tableView(_tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        
        groups = realm.objects(Group.self)
        
        token = groups?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
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
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        groupService?.dowloadGroups()
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let id = groups?[indexPath.row].id else { return }
            
            groupService?.leaveFromGroup(groupID: id) {}

        }
    }
    

}
