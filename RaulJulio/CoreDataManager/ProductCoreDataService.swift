//
//  ProductCoreDataService.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import CoreData

final class ProductCoreDataService: CoreDataManagerService {
    static let shared = ProductCoreDataService()
    
    func fetchProduct() -> [Product] {
        let fetchedProduct: NSFetchedResultsController<Product> = {
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            return result
        }()
        try? fetchedProduct.performFetch()
        return fetchedProduct.fetchedObjects ?? []
    }
    
    func createNewProduct() -> Product {
        Product(context: context)
    }
    
    func deleteProduct(_ product: Product) {
        context.delete(product)
        try? context.save()
    }
    
    func deleteAllProductsWith(_ state: State) {
        let products = fetchProduct().filter({ $0.state == state })
        products.forEach { context.delete($0) }
        try? context.save()
    }
}
