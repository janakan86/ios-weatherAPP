//
//  CoreDataStack.swift
//  weatherView
//
//  Created by K Janakan on 6/2/20.
//  Copyright © 2020 K Janakan. All rights reserved.
//

import Foundation
import CoreData


/*  // The following is the legacy way of setting up a core data stack
 func createMainContext() -> NSManagedObjectContext {
 
 //initialize NSManagedObjectModel
 guard let modelURL = Bundle.main.url(forResource: "shoutout", withExtension: "momd")
 else { fatalError("model not found")}
 
 guard let model = NSManagedObjectModel(contentsOf: modelURL)
 else { fatalError("model not found")}
 
 //Configure NSPersistenceStore
 
 let storageURL = URL.documentsURL.appendingPathComponent("ShoutOut.sqlite")
 let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
 try! psc.addPersistentStore(ofType: "NSSQLiteStoreType", configurationName: nil, at: storageURL, options: nil)
 
 //create NSManagedObjectContext
 let context = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
 context.persistentStoreCoordinator = psc
 
 return context
 
 }
 
 
 
 extension URL {
 static var documentsURL: URL {
 return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
 }
 }
 */


func getPersistentContainer()-> NSPersistentContainer {
    
    let container =  NSPersistentContainer(name:"weatherApp")
    
    // The following snippet of code is not mandatory. SQLite store will be used by default
    // - start snippet - defining store type - //
    let description = NSPersistentStoreDescription()
    description.type = NSSQLiteStoreType //other probable values NSInMemoryStoreType ,NSBinaryStoreType
    
    if description.type == NSSQLiteStoreType || description.type == NSBinaryStoreType {
        // for persistence on local storage we need to set url
        description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("weatherApp")
    }
    
    container.persistentStoreDescriptions = [description]
    // - end snippet - //
    
 
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    
    return container
    
}




func saveContext () {
    let context = getPersistentContainer().viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
