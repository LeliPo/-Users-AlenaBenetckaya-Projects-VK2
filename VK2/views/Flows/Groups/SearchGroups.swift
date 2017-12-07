//
//  SearchGroups.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase


class SearchGroups: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    
    lazy var photoService = PhotoService(container: tableView)
    
    lazy var groupService: GroupService? = {
        guard let tabsVC = navigationController?.tabBarController as? TabsVC else { return nil}
        let groupService = GroupService(environment: EnvironmentImp.Debug(), token: tabsVC.token)
        return groupService
    }()
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCellWithUserCount", for: indexPath) as! GroupCellWithUserCount
        
        let group = groups[indexPath.row]
        
        cell.nameView.text = group.name
        cell.countView.text = String(group.count)
        cell.avatarView.image = photoService.photo(atIndexpath: indexPath, byUrl: group.photoUrl)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = groups[indexPath.row].id
        groupService?.joinToGroup(groupID: id) { [weak self] in
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
            let enteredGroup = EnteredGroups(groupId: id)
            let dbLink = Database.database().reference()
            dbLink.child("Authenticated users/\(id)/enteredGroups").updateChildValues(["\(enteredGroup.groupId)": enteredGroup.toAnyObject])
        }
    }

}

extension SearchGroups: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let text = searchBar.text,
            !text.isEmpty else {
                
            tableView.reloadData()
            return
        }
        searchGroups(request: text)
        tableView.reloadData()
    }
    
    func searchGroups(request: String) {
        groupService?.searchGroups(request: request) { [weak self] groups in
            self?.groups = groups
            self?.tableView.reloadData()
        }
    }
}
