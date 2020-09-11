//
//  Persistence.swift
//  Flashcards
//
//  Created by Thane Heninger on 8/28/20.
//

import CoreData

var globalCards = [Card]()

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = CoreItem(context: viewContext)
            newItem.created = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Flashcards")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
    }
    
    func addItem(card: Card) throws {
        let coreItem = CoreItem(context: container.viewContext)
        coreItem.id = card.id
        coreItem.created = card.created
        coreItem.name = card.name
        coreItem.details = card.details
        
        coreItem.hasLocation = false
        if let location = card.location {
            coreItem.hasLocation = true
            coreItem.latitude = location.latitude
            coreItem.longitude = location.longitude
        }
        try container.viewContext.save()
    }
    
    var fetchRequest: NSFetchRequest<CoreItem> {
        let request: NSFetchRequest<CoreItem> = NSFetchRequest(entityName: "CoreItem")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CoreItem.created, ascending: true)
        ]
        return request
    }
    
    func loadItems(completion: @escaping ([CoreItem])->Void) {
        DispatchQueue.global().async {
            do {
                let coreItems = try container.viewContext.fetch(fetchRequest)
                completion(coreItems)
            }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error while loading \(nsError)")
            }
        }
    }
    
    func deleteItems(offsets: IndexSet, completion: @escaping ()->Void) {
        DispatchQueue.global().async {
            do {
                let coreItems = try container.viewContext.fetch(fetchRequest)
                offsets.map { coreItems[$0] }.forEach(container.viewContext.delete)
                try container.viewContext.save()
                completion()
            }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error while deleting \(nsError)")
            }
        }
    }
}
