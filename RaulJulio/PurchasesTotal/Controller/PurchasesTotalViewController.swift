//
//  PurchasesTotalViewController.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

class PurchasesTotalViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var dolarValueLabel: UILabel!
    @IBOutlet weak var realValueLabel: UILabel!
    
    // MARK: - Variable
    
    var products: [Product] = []
    var currentDollar: Double { AppSettingsManager.shared.getDolarValue() }
    var currentIOF: Double { AppSettingsManager.shared.getIOFValue() }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        calculateValues()
    }
    
    private func fetchData() {
        products = ProductCoreDataService.shared.fetchProduct()
    }
    
    private func calculateValues() {
        calculateDolars()
        calculateReals()
    }
    
    private func calculateDolars() {
        let value = products.compactMap { $0.value }.reduce(0, +)
        dolarValueLabel.text = value.getDolarValue()
    }
    
    private func calculateReals() {
        let value: Double = products.compactMap {
            var calculatedValue: Double = $0.value
            let stateTax: Double = $0.state?.stateTax ?? 0
            if stateTax > 0 { calculatedValue = calculatedValue * ((stateTax) / 100 + 1) }
            calculatedValue = calculatedValue * currentDollar
            if $0.isCardProduct { calculatedValue = calculatedValue * (currentIOF / 100 + 1) }
            return calculatedValue
        }.reduce(0, +)
        realValueLabel.text = value.getRealValue()
    }
 
}
