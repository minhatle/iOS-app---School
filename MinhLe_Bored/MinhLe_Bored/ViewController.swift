//
//  ViewController.swift
//  MinhLe_Bored
//
//  Created by Minh Le on 2021-04-20.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var activity : UILabel!
    
    private let activityFetcher = ActivitiesFetcher.getInstance()
    private var activityList : Activity = Activity()
    private var cancellables : Set<AnyCancellable> = []
    
    var newActivity = ActivityCoreData()
    private let dbHelper = CoreDataHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Activity"

        self.activityFetcher.fetchDataFromApi()
        self.activityChanges()
    }
    
   @IBAction func performViewList() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "ActivityVC") as! DetailsTableViewController
        
        self.present(gameVC, animated: true, completion: nil)
    
        print("Running")
    
    }
    
    @IBAction func showAnotherActivity(){
        self.activityFetcher.fetchDataFromApi()
        self.activityChanges()
    }
    
    private func activityChanges(){
        self.activityFetcher.$activityList.receive(on: RunLoop.main).sink{(launch) in
            print(#function, "Received Launch: ", launch)
        
            self.activity.text = "\(launch.activity)"
        }
        .store(in: &cancellables)
    }
    
    
    @IBAction func addToFavourite(){
        if (activity.text != ""){
            newActivity.activity = self.activity.text!
            self.askConfirmation()
            self.dbHelper.insertActivity(newActivity: newActivity)
        }else{
            self.showErrorAlert(errorMessage: "Please choose Activity")
        }
    }
    
    func askConfirmation(){
        let confirmAlert = UIAlertController(title: "Confirmation", message: "You want to add this activity into Favourite?", preferredStyle: .actionSheet)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(errorMessage : String){
        let errorAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
        
    }
    
    func goToDetailsScreen(){
        let storyboard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let activityVC = storyboard.instantiateViewController(identifier: "ActivityVC") as!DetailsTableViewController
        
        self.navigationController?.pushViewController(activityVC, animated: true)
        
        print("Running")
    }
    
}

