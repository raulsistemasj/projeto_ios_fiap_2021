//
//  PurchasesViewController.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

final class PurchasesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    var purchaseList: [Product] = [] {
        didSet { tableView.reloadData() }
    }
    
    var selectedProduct: Product?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.isHidden = purchaseList.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FormViewController else { return }
        destination.selectedProduct = selectedProduct
        destination.delegate = self
    }
    
    // MARK: - Layout Functions
    
    private func setupView() {
        configureTableView()
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseDetailCell.self, forCellReuseIdentifier: PurchaseDetailCell.identifier)
    }
    
    private func fetchData() {
        purchaseList = ProductCoreDataService.shared.fetchProduct()
    }

}

extension PurchasesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        purchaseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseDetailCell.identifier, for: indexPath) as? PurchaseDetailCell,
              let product = purchaseList.get(index: indexPath.row) else { return UITableViewCell() }
        
        cell.configure(with: Purchases.Model.PurchaseDetailViewModel(photo: product.image?.asImage(),
                                                                     name: product.name ?? "",
                                                                     price: "$ \(product.value.getDolarValue())"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = purchaseList.get(index: indexPath.row)
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
        guard selectedProduct != nil else { return }
        performSegue(withIdentifier: "goToPurchaseForm", sender: self)
        selectedProduct = nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
        let product = purchaseList.get(index: indexPath.row) else { return }
        ProductCoreDataService.shared.deleteProduct(product)
        didUpdateProduct()
    }
}

extension PurchasesViewController: FormViewControllerDelegate {
    func didUpdateProduct() {
        fetchData()
    }
}
