//
//  NewsFeedVC.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 19.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import UIKit

class NewsFeedVC: UITableViewController {
    
    
    var environment: Environment {
        return EnvironmentImp.Debug()
    }
    
    lazy var photoService = PhotoService(container: tableView)
    
    lazy var newsService: NewsService? = {
        guard let tabsVC = tabBarController as? TabsVC else { return nil}
        let userService = NewsService(environment: environment, token: tabsVC.token)
        return userService
    }()
    
    var news = [New]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        
        newsService?.downloadsNews() { [weak self] news in
            self?.news = news
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell", for: indexPath) as! NewCell
        let new = news[indexPath.row]

        var autorName = ""
        var autorAvatarUrl = ""
        if let group = new.group {
            autorName = group.name
            autorAvatarUrl = group.photoUrl
        } else if let user = new.user {
            autorName = user.fullName
            autorAvatarUrl = user.photoUrl
        }
        
     
        if new.photoLink != nil {
            let mainPhotoUrl = new.photoLink
            cell.mainImage.image = photoService.photo(atIndexpath: indexPath, byUrl: mainPhotoUrl!)
        } else {
            cell.mainImage.image = nil
        }

        cell.autorAvatar.image = photoService.photo(atIndexpath: indexPath, byUrl: autorAvatarUrl)
        cell.autorName.text = autorName
        cell.mainText.text = new.text
        cell.likeCount.text = String(describing: new.likesCount)
        cell.commentCount.text = String(describing: new.commentsCount)
        cell.repostCount.text = String(describing: new.repostsCount)
        cell.viewsCount.text = String(describing: new.viewsCount)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
