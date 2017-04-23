//
//  FoodTableViewController.swift
//  menu
//
//  Table that displays the food and calories that a user has consumed
//
//  Created by Aliya Gangji on 4/22/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit

class FoodTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // reference to calories label
    @IBOutlet weak var calorieLabel: UILabel!
    // reference to table
    @IBOutlet weak var table: UITableView!
   
    // Array to hold the food items
    var items: [String] = []
    // Total Calories, Counted every time the page is loaded
    var TotalDailyCaloriesInt = 0

    // total number of cells in table
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // populates table, counts the calories
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        // populates the cells
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // gets data from UserDefaults
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        
        if let tempItems = itemsObject as? [String] {
            items = tempItems
        }
        // counts the calories
        for item in items{
            // splits string by ", "
            var temp = item.components(separatedBy: ", ")
            // gets the integer
            let temp2 = temp[1].components(separatedBy: " ")[0]
            // adds to TotalDailyCaloriesInt
            TotalDailyCaloriesInt +=  Int(temp2)!
            // display in calories label
            calorieLabel.text = String(TotalDailyCaloriesInt)
        }
        // reload table data
        table.reloadData()
    }
 
    
   // allows user to delete cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            // remove the calorie of food item from total count
            var temp = items[indexPath.row].components(separatedBy: ", ")
            let temp2 = temp[1].components(separatedBy: " ")[0]
            TotalDailyCaloriesInt = TotalDailyCaloriesInt -  Int(temp2)!
            // remove cell from display
            items.remove(at: indexPath.row)
            // update the data
            table.reloadData()
            // update the calorie display
            calorieLabel.text = String(TotalDailyCaloriesInt)
            // update UserDefaults
            UserDefaults.standard.set(items, forKey: "items")
        }
        
    }

    override func viewDidLoad() {
              super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
