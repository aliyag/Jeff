//
//  ViewController.swift
//  menu
// 
//  Page that allows user to select a day of week 
//  First page in menu
//
//  Created by Aliya Gangji on 3/15/17.
//  Copyright © 2017 Aliya Gangji. All rights reserved.
//

import UIKit
class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // array with days of week, content to populate cells
    let cellContent = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var selectedCell = ""
    
    // returns total cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    // populates the table
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        // populates the cells
        cell.textLabel?.text = cellContent[indexPath.row]
        return cell
    }
    
    // prepares data to pass
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickDayOfWeek" {
            if let timeVC = segue.destination as? TimeViewController {
                // pass data
                timeVC.dayOfWeek = selectedCell
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // when user selects a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = cellContent[indexPath.row]
        // transfer data
        performSegue(withIdentifier: "pickDayOfWeek", sender: self)
      
    }

}

