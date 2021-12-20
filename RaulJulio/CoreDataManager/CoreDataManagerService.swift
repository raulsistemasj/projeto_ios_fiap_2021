//
//  CoreDataManager.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit
import CoreData

protocol CoreDataManagerService {
    func saveChanges()
    var context: NSManagedObjectContext { get }
}

extension CoreDataManagerService {
    var context: NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
        return appdelegate.persistentContainer.viewContext
    }
    
    func saveChanges() {
        try? context.save()
    }
}
