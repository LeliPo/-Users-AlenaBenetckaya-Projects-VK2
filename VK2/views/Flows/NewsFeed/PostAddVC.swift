//
//  PostAddVC.swift
//  VK2
//
//  Created by  Алёна Бенецкая on 07.12.2017.
//  Copyright © 2017  Алёна Бенецкая. All rights reserved.
//

import UIKit
import CoreLocation

class PostAddVC: UIViewController {

    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var locLat: UILabel!
    @IBOutlet weak var locCity: UILabel!
    @IBOutlet weak var locLong: UILabel!
    
    var currentLocation: CLLocation = CLLocation()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        let text = self.postText.text + "\nfrom" + self.locCity.text!
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
