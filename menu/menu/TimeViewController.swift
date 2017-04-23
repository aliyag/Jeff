//
//  TimeViewController.swift
//  menu
// 
//  Description: This page allows a user to select what time of day
//  that he or she would like the menu for.
//
//  Created by Aliya Gangji on 3/15/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // holds the day of week, from previous page
    var dayOfWeek: String?
    
    // holds the time of day
    var timeOfDay = [String]()
    
    // holds the time of day the user selected
    var selectedCell = ""

        
    // size of table
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return timeOfDay.count
    }
    
    // populate cells with text
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        // populate cell with array info
        cell.textLabel?.text = timeOfDay[indexPath.row]
        return cell
    }
    
    // when user selects a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell that the user clicked on
        selectedCell = timeOfDay[indexPath.row]
        // go to next page, pass information
        performSegue(withIdentifier: "showFood", sender: self)
    }
    
    // pass the day of the week and time of day to next day
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFood" {
            // pass day of week and time of day through segue
            if let FoodVC = segue.destination as? FoodViewController {
                FoodVC.dayOfWeek = dayOfWeek!
                FoodVC.timeOfDay = selectedCell
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if weekend, display only lunch and dinner
        if  "Saturday"  == dayOfWeek || "Sunday" == dayOfWeek {
            timeOfDay.append("Lunch")
            timeOfDay.append("Dinner")
         }
        // else it is a week day, display breakfast, lunch and dinner
        else{
            timeOfDay.append("Breakfast")
            timeOfDay.append("Lunch")
            timeOfDay.append("Dinner")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
