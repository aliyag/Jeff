//
//  FoodViewController.swift
//  menu
//
//  Page that displays the different stations with the food served there 
//
//  Created by Aliya Gangji on 4/1/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // the table that displays menu items
    @IBOutlet weak var foodChart: UITableView!
    
    // holds the day of the week
    var dayOfWeek = ""
    // holds the time of the day
    var timeOfDay = ""
    // holds the food name of the selected cell
    var selectedCell = ""
    // holds the diet restrictions to pass to next page
    var dietRestrictionString = ""
    
    // holds the section headers
    var sectionHeader = [String]()
    // holds the menu items
    var foodMenu = [[String]]()
    // holds whether it is Vegan, Vegetarian, or Mindful
    var dietRestrictions = [[String]]()
    
    // number of rows in section
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodMenu[section].count
    }
    
    // design section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! FoodTableViewCell
        // fill section header with text
        cell2.headerLabel?.text = sectionHeader[section]
        
        // assign images to header 
        if "Chef's Table" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "chef.png")
        }
        if "Croutons" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "salad.png")
        }
        if "Mangia Mangia" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "pasta.png")
        }
        if "Wildfire Grille" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "grill.png")
        }
        if "Chew St. Deli" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "sandwich.png")
        }
        if "Magellan's" == sectionHeader[section]{
            cell2.foodImage.image = #imageLiteral(resourceName: "tray.png")
        }
        return cell2
    }
    
    // get information when the cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the selected cell
        selectedCell = foodMenu[(indexPath.section)][(indexPath.row)]
        // get dietRestrictions to pass to next page
        dietRestrictionString =  dietRestrictions[indexPath.section][indexPath.row]
        // pass the info to the next page
        performSegue(withIdentifier: "selectItem", sender: self)
    }
    
    // number of section headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    // height of the header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
   
    // if back button pressed
    @IBAction func pressBackButton(_ sender: Any) {
        performSegue(withIdentifier: "backButton", sender: self)
    }
    
    // fill the table cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodTableViewCell
        
        // fill cell with menu item
        cell.textLabel?.text = foodMenu[indexPath.section][indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
        
    }
    
    // pass data to the next or previous page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if back selected
        if segue.identifier == "backButton" {
            if let TimeVC = segue.destination as? TimeViewController {
                TimeVC.dayOfWeek = dayOfWeek 
            }
        }
        // pass to the item page
        if segue.identifier == "selectItem" {
            if let ItemVC = segue.destination as? ItemViewController {
                ItemVC.foodItem = selectedCell
                ItemVC.dayOfWeek = dayOfWeek
                ItemVC.timeOfDay = timeOfDay
                ItemVC.dietRestrictions = dietRestrictionString
            }
        }
       
    }
    
    override func viewDidLoad() {
        // load the food options
        viewWillAppear(true)
        super.viewDidLoad()
    }
    
    // load the information from the server
    override func viewWillAppear(_ animated: Bool) {
        // server link
        let requestURL: NSURL = NSURL(string: "http://mathcs.muhlenberg.edu/~ag249083/foodJson9")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do{
                    // format json as a NSDictionary
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary{
                        // format as [String: NSDictionary]
                        if let articlesFromJson = json[self.dayOfWeek + self.timeOfDay] as? [String : NSDictionary] {
                            for (key,value) in articlesFromJson {
                                // add to Section Header Dictionary
                                self.sectionHeader.append(String(describing: key))
                                // hold the foods served in a section
                                var food = [String]()
                                // holds whether the food item is Vegan, Vegetarian
                                var dietRest = [String]()
                                for (key2, value2) in value {
                                    // add to arrays
                                    food.append(key2 as! String)
                                    dietRest.append(String(describing: value2))
                                }
                                // add to the Double Array foodMenu
                                self.foodMenu.append(food)
                                // add to the Double Array dietRestrictions
                                self.dietRestrictions.append(dietRest)
                            }
                            // reload the foodChart
                            self.foodChart.reloadData()
                            
                        }
                    }
                }
                
            } // end status 200 if statement
        } // end task
        task.resume()
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
