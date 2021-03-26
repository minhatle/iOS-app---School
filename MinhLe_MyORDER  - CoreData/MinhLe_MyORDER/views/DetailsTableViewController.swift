// Fullname : Minh Nhat Le              StudentID: 164029175
//  DetailsTableViewController.swift
//  MinhLe_MyORDER
//
//  Created by Minh Le on 2021-02-07.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    //var currentOrders : [Order] = []
    var currentOrders : [MyOrder] = [MyOrder]()
    
    private let dbHelper = DatabaseHelper.getInstance()
    
    private func fetchAllDetails(){
        if (self.dbHelper.getAllDetails() != nil){
            self.currentOrders = self.dbHelper.getAllDetails()!
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
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Order Details"
        self.tableView.rowHeight = 70
        
        self.setUpLongPressGesture()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentOrders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! DetailsCell

        // Configure the cell...
        if(indexPath.row < currentOrders.count){
            let order = currentOrders[indexPath.row]
            
            cell.orderCoffeeType?.text = order.coffeeType
            cell.orderCoffeeSize?.text = order.coffeeSize
            cell.orderQuantity?.text = String(order.quantity)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Coffee Type                          Size        Quantity"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if (indexPath.row < self.currentOrders.count){
            let order = self.currentOrders[indexPath.row]
            order.completion.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            self.dbHelper.updateOrder(updatedOrder: self.currentOrders[indexPath.row])
        }
    }
    
    private func deleteOrderFromList(indexPath: IndexPath){
        //self.currentOrders.remove(at:indexPath.row)
        //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        //self.tableView.reloadData()
        
        self.dbHelper.deleteOrder(orderID: self.currentOrders[indexPath.row].id!)
        self.fetchAllDetails()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(indexPath.row < self.currentOrders.count){
            self.deleteOrderFromList(indexPath: indexPath)
        }
    }
    
    private func updateOrderInList(indexPath: IndexPath, coffeeType : String, coffeeSize : String, quantity : Int){
        self.currentOrders[indexPath.row].coffeeType = coffeeType
        self.currentOrders[indexPath.row].coffeeSize = coffeeSize
        self.currentOrders[indexPath.row].quantity = Int16(quantity)
        
        self.dbHelper.updateOrder(updatedOrder: self.currentOrders[indexPath.row])
        self.fetchAllDetails()
        
    }
    

    private func setUpLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        longPressGesture.minimumPressDuration = 1.0 //1 second
        
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended{
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint){
                
                self.displayCustomAlert(indexPath: indexPath, title: "Edit Order", message: "Please provide the updated details")
            }
        }
    }
    
    private func displayCustomAlert(indexPath: IndexPath?, title : String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (indexPath != nil){
            alert.addTextField{(textField: UITextField!) ->Void in
                textField.placeholder = self.currentOrders[indexPath!.row].coffeeType
                textField.isUserInteractionEnabled = false
            }
            
            alert.addTextField{(textField: UITextField!) ->Void in
                textField.placeholder = self.currentOrders[indexPath!.row].coffeeSize
                textField.isUserInteractionEnabled = false
            }
            
            alert.addTextField{(textField: UITextField) in
                textField.text = String(self.currentOrders[indexPath!.row].quantity)
                
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if let coffeeTypeText = alert.textFields?[0].placeholder,
               let coffeeSizeText = alert.textFields?[1].placeholder,
               let quantityText = Int((alert.textFields?[2].text)!) {
                
                if (indexPath != nil){
                    self.updateOrderInList(indexPath: indexPath!, coffeeType: coffeeTypeText, coffeeSize: coffeeSizeText, quantity: quantityText)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

