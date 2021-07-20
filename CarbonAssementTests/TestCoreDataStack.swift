//
//  TestCoreDataStack.swift
//  CarbonAssementTests
//
//  Created by Anthony Odu on 19/07/2021.
//


import CoreData


class TestCoreDataStack: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "MovieListItem")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
}
