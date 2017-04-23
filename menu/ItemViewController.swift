//
//  ItemViewController.swift
//  menu
//
//  Display description, serving size for food item
//
//  Created by Aliya Gangji on 4/15/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    // Outlets  that display info
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    
    var foodItem = ""
    var dayOfWeek = ""
    var timeOfDay = ""
    // Diet Restrictions from prev page
    var dietRestrictions = ""
    // Diet Restrictions formated for user
    var dietRestructionsString = ""

 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // if user clicks back
    @IBAction func pressBackButton(_ sender: Any) {
            performSegue(withIdentifier: "backButton", sender: self)
    }

    // if user clicks add
    @IBAction func addItemList(_ sender: Any) {
        performSegue(withIdentifier: "addItemList", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // transfer dayOfWeek and timeOfDay to prev page
        if segue.identifier == "backButton" {
            if let FoodVC = segue.destination as? FoodViewController {
                FoodVC.dayOfWeek = dayOfWeek
                FoodVC.timeOfDay = timeOfDay
            }
        }

        // transfer data to addItem page
        if segue.identifier == "addItemList" {
            if let AddVC = segue.destination as?
                AddItemViewController {
                AddVC.foodItem = self.foodItem
                AddVC.calories = self.caloriesLabel.text!
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // if Mindful
        if dietRestrictions.range(of: "Mindful = Yes;") != nil {
            dietRestructionsString = "Mindful Item"
        }
        // if Vegan
        if dietRestrictions.range(of: "Vegan = Yes;") != nil {
            if dietRestructionsString.isEmpty {
                dietRestructionsString = "Vegan Item"
            }
                // if Vegan and Mindful
            else{
                dietRestructionsString = dietRestructionsString +  ", Vegan Item"
            }
        }
        // if Vegetarian
        if dietRestrictions.range(of: "Vegetarian = Yes;") != nil {
            if dietRestructionsString.isEmpty {
                dietRestructionsString = "Vegetarian Item"
            }
            else{
                dietRestructionsString = dietRestructionsString +  ", Vegetarian Item"
            }
        }
        // display food label from previous page
        foodLabel.text = foodItem
        let requestURL: NSURL = NSURL(string: "http://mathcs.muhlenberg.edu/~ag249083/foodJson10")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                
                do{
                    // load from server
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary{
                        if let articlesFromJson = json[self.foodItem] as? [String : String] {
                            // display Description
                            self.descriptionLabel.text = articlesFromJson["Description"]!
                            // display Serving Size
                            self.servingSizeLabel.text = articlesFromJson["servingSize"]! + "(" + articlesFromJson["servingSizeInGrams"]! + ")"
                            // display calories
                            self.caloriesLabel.text = articlesFromJson["calories"]!
                            // find out of special restrictions
                            if let special = articlesFromJson["Special"] {
                                // if not Vegetarian, Vegan or Special
                                if self.dietRestructionsString.isEmpty {
                                    self.specialLabel.text = special
                                }
                                    // if Vegetarian, Vegan or Special
                                else{
                                    self.specialLabel.text = self.dietRestructionsString +  ", " + special
                                }
                            }
                                // No special dietary restrictions found
                            else{
                                self.specialLabel.text = "N/A"
                            }
                        }
                            // Item not in Dictionary
                        else{
                            self.descriptionLabel.text = "Description not available for this item"
                            self.servingSizeLabel.text = "N/A"
                            self.caloriesLabel.text = "N/A"
                            self.specialLabel.text = "N/A"
                        }
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        viewWillAppear(true)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
