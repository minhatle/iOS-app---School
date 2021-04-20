//
//  CoreDataHelper.swift
//  MinhLe_Bored
//
//  Created by Minh Le on 2021-04-20.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper{
    private static var shared : CoreDataHelper?
    
    static func getInstance() -> CoreDataHelper{
        if shared != nil{
            return shared!
        }else{
            return CoreDataHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "MyActivity"
    
    private init(context: NSManagedObjectContext){
        self.moc = context
    }
    
    //retrieve all database
    func getAll() -> [MyActivity]? {
        let fetchRequest = NSFetchRequest<MyActivity>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateCreated", ascending: false)]
        do{
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched data: \(result as [MyActivity])")
            return result as [MyActivity]
                
        }catch let error as NSError{
            print(#function, "Could not fetch data \(error) \(error.code)")
        }
        
        return nil
    }
    
    func insertActivity(newActivity: ActivityCoreData){
        do{
            let dataToBeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! MyActivity
            
            dataToBeAdded.activity = newActivity.activity
            dataToBeAdded.id = UUID()
            dataToBeAdded.dateCreated = Date()
            print("step 3")
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data inserted successfully")
            }
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    //delete
    func deleteActivity(actID : UUID){
        let searchResult = self.searchActivity(actID: actID)
        if(searchResult != nil){
            do{
                self.moc.delete(searchResult!)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.saveContext()
                print(#function, "Activity deleted successfully")
            }
        }
    }
    
    //search
    func searchActivity(actID : UUID) -> MyActivity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", actID as CVarArg)
        fetchRequest.predicate = predicateID
        do{
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first as? MyActivity
            }
        }catch let error as NSError{
            print("Unable to search activity \(error)")
        }
        return nil
    }
}
