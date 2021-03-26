// Fullname : Minh Nhat Le              StudentID: 164029175
//  OrderViewController.swift
//  MinhLe_MyORDER
//
//  Created by Minh Le on 2021-02-06.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet var pkrCoffeeType : UIPickerView!
    @IBOutlet var segSize : UISegmentedControl!
    @IBOutlet var quantity : UITextField!
    
    let coffeeType = ["Capuchino", "Dark Roast", "Original Blend", "Vanilla"]
    var newOrder = Order()
    //var orders : [MyOrder] = [MyOrder]()
    private let dbHelper = DatabaseHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Order"
        
        self.pkrCoffeeType.dataSource = self
        self.pkrCoffeeType.delegate = self
        
        let btnViewList = UIBarButtonItem(title: "View List", style: .plain, target: self, action: #selector(performViewList))
        
        self.navigationItem.setRightBarButton(btnViewList, animated: true)
        
    }
    @objc
    func performViewList() {
        //self.navigationController?.popViewController(animated: true)
        self.gotoDetailsScreen();
    }
    
    @IBAction func createOrder(){
        if(!self.quantity.text!.isEmpty && Int(self.quantity.text!) != 0){
            
            newOrder.quantity = Int(self.quantity.text!) ?? 1
            
            newOrder.coffeeSize = self.segSize.titleForSegment(at: segSize.selectedSegmentIndex)!
            
            newOrder.coffeeType = self.coffeeType[self.pkrCoffeeType.selectedRow(inComponent: 0)]
            
            self.askConfirmation()
            
            self.dbHelper.insertOrder(newDetail : newOrder)
            
            //orders.append(newOrder)
        }else{
            self.showErrorAlert(errorMessage: "Please input your Quantity or the Quantity could not be 0")
        }
    }
    
    
    
    func showErrorAlert(errorMessage : String){
        let errorAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "Please confirm your orders", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
        
    }
    
    func gotoDetailsScreen(){
        //identify the storyboard
        let storyboard = UIStoryboard(name:"Main", bundle:Bundle.main)
        //create instant of the destination ViewController
        let gameVC = storyboard.instantiateViewController(identifier: "GameVC") as! DetailsTableViewController
        
       // gameVC.currentOrders = orders
        //add new screen/VC on the Navigation stack
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.coffeeType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.coffeeType[row]
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print(#function, "Selected Country : \(self.coffeeType[row])")
        }
}
