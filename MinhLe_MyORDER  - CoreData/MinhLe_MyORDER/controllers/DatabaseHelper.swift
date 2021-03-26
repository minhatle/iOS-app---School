// Fullname : Minh Nhat Le              StudentID: 164029175
//  DatabaseHelper.swift
//  MinhLe_MyORDER
//
//  Created by Minh Le on 2021-03-21.
//

import Foundation
import CoreData
import UIKit
class DatabaseHelper{
    //singleton instance
    private static var shared : DatabaseHelper?
    
    static func getInstance() -> DatabaseHelper{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            //create a new singlton instance
            return DatabaseHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "MyOrder"
    
    private init (context : NSManagedObjectContext){
        self.moc = context
    }
    
    //insert
    func insertOrder(newDetail: Order){
        do{
            let orderTobeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! MyOrder
            orderTobeAdded.coffeeSize = newDetail.coffeeSize
            orderTobeAdded.coffeeType = newDetail.coffeeType
            orderTobeAdded.quantity = Int16(newDetail.quantity)
            
            orderTobeAdded.completion = false
            orderTobeAdded.id = UUID()
            orderTobeAdded.dateCreated = Date()
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data inserted successfully")
            }
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    //update
    func updateOrder(updatedOrder: MyOrder){
        let searchResult = self.searchOrder(orderID: updatedOrder.id! as UUID)
        if(searchResult != nil){
            do{
                let orderUpdated = searchResult
                orderUpdated?.coffeeType = updatedOrder.coffeeType
                orderUpdated?.coffeeSize = updatedOrder.coffeeSize
                orderUpdated?.quantity = updatedOrder.quantity
                orderUpdated?.completion = updatedOrder.completion
                
                try self.moc.save()
                print(#function, "Order updated successfully")
                
            }catch let error as NSError{
                print(#function, "Unable to update order \(error)")
            }
        }
    }
    //search
    func searchOrder(orderID : UUID) -> MyOrder?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", orderID as CVarArg)
        fetchRequest.predicate = predicateID
        do{
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first as? MyOrder
            }
        }catch let error as NSError{
            print("Unable to search order \(error)")
        }
        return nil
    }
    //delete
    func deleteOrder(orderID : UUID) {
        let searchResult = self.searchOrder(orderID: orderID)
        if (searchResult != nil){
            do{
                self.moc.delete(searchResult!)
                //try self.moc.save()
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.saveContext()
                
                print(#function, "Order deleted successfully")
            
            }
        }
    }
    //retrieve all database
    func getAllDetails() -> [MyOrder]?{
        let fetchRequest = NSFetchRequest<MyOrder>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateCreated", ascending: false)]
        
        do{
            //execute the request
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched data: \(result as [MyOrder])")
            
            return result as [MyOrder]
        }catch let error as NSError{
            print("Could not fetch data \(error) \(error.code)")
        }
        //no data retrieved
        return nil
    }
    
    
    
}
