//
//  LocalDataSource.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation
import UIKit
import CoreData

class LocalDataSource {
    static let shared = LocalDataSource()
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //Fetch Data from Core Data
    func getAllitem(onSuccess: @escaping (_ movies: [MovieListItem]) -> Void,
                    onFail: @escaping (_ : CustomError) -> Void){

        do {
            
            let items = try managedObjectContext().fetch(MovieListItem.fetchRequest())
            
            onSuccess(items as? [MovieListItem] ?? [])
            
        } catch {
            onFail(.serverMessage("Error Fetching Movie"))
            fatalError("Failed fetching content items with error: \(error)")
        }
    }
    
    //Save Data
    func saveItem(item:Result, onSuccess: @escaping (_ saved:Bool)-> Void){
        let movieitem = MovieListItem(context: managedObjectContext())
        movieitem.backdropPath  = item.backdropPath
        movieitem.director = ""
        movieitem.id = Int64(item.id)
        movieitem.overView = item.overview
        movieitem.releaseDate = item.releaseDate
        movieitem.title = item.title
        movieitem.voteAverage = item.voteAverage
        movieitem.voteCount = Int64(item.voteCount)
        movieitem.posterPath = item.posterPath
        movieitem.favourite = true
        do {
            try managedObjectContext().save()
            onSuccess(true)
        } catch  {
            print("Error Saving Movie")
        }
    }
    
    //setup context
    func managedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
  
    //delete all data
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext().fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedObjectContext().delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    
    //Delete Single Data
    func deleteItem(item:Result){
        do {
            let items = try managedObjectContext().fetch(MovieListItem.fetchRequest())
            for obj in items as? [MovieListItem] ?? []{
                if obj.id == item.id{
                    context.delete(obj)
                }
            }
            try context.save()
        } catch {
            fatalError("Failed fetching content items with error: \(error)")
        }
    }
}

