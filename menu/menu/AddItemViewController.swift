//
//  AddItemViewController.swift
//  menu
//  Page that allows users to add a food item and calories to a list 
//
//  Created by Aliya Gangji on 4/22/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    // stores food name
    var foodItem = ""
    // stores calories
    var calories = ""
    // total number of calories
    var TotalDailyCaloriesInt = 0
    
    // food text field
    @IBOutlet weak var foodItemText: UITextField!
    // calories text field
    @IBOutlet weak var caloriesText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // check if calories is an Integer
        if let cal = Int(calories)
        {
            // add calories to user text field if available
            caloriesText.text = String(cal)
        }
        // assign food item to the user text field
        foodItemText.text = foodItem
        // Do any additional setup after loading the view.
    }
    
    
    // when the user wants to add an item to the list
    @IBAction func add(_ sender: Any) {
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        
        var items:[String]
        
        if let tempItems = itemsObject as? [String] {
            items = tempItems
            // add to list
            items.append(foodItemText.text! + ", " + caloriesText.text! + " calories")
        } else {
            // if no items in list
            items = [foodItemText.text! + ", " + caloriesText.text! + " calories"]
        }
        
        // Store items in UserDefaults
        UserDefaults.standard.set(items, forKey: "items")

        // remove text from the foodItem and calories text fields
        foodItemText.text = ""
        caloriesText.text = ""

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // when the user clicks the back button
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backButton", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
