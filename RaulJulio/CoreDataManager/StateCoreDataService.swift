//
//  StateCoreData.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import CoreData

final class StateCoreDataService: CoreDataManagerService {
    static let shared = StateCoreDataService()
    
    func fetchState() -> [State] {
        let fetchedState: NSFetchedResultsController<State> = {
            let request: NSFetchRequest<State> = State.fetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            return result
        }()
        try? fetchedState.performFetch()
        return fetchedState.fetchedObjects ?? []
    }
    
    func createNewState() -> State {
        State(context: context)
    }
    
    func deleteState(_ state: State) {
        ProductCoreDataService.shared.deleteAllProductsWith(state)
        context.delete(state)
        try? context.save()
    }
    
    
}
