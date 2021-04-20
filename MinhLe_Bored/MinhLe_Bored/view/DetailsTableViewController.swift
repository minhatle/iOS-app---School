//
//  DetailsTableViewController.swift
//  MinhLe_Bored
//
//  Created by Minh Le on 2021-04-20.
//
import UIKit

class DetailsTableViewController: UITableViewController {

    var currentActivity : [MyActivity] = [MyActivity]()
    
    private let dbHelper = CoreDataHelper.getInstance()
    
    private func fetchAllDetails(){
        if (self.dbHelper.getAll() != nil){
            self.currentActivity = self.dbHelper.getAll()!
            self.tableView.reloadData()
        }else{
            print(#function, "No data received from dbHelper")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchAllDetails()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Order Details"
        self.tableView.rowHeight = 70
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentActivity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! DetailsCell

        // Configure the cell...
        if(indexPath.row < currentActivity.count){
            let act = currentActivity[indexPath.row]
            cell.activity?.text = act.activity
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activity Favourite List"
    }
    
    private func deleteFromList(indexPath: IndexPath){
        
        self.dbHelper.deleteActivity(actID: self.currentActivity[indexPath.row].id!)
        self.fetchAllDetails()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(indexPath.row < self.currentActivity.count){
            self.deleteFromList(indexPath: indexPath)
        }
    }
}
