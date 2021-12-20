//
//  SettingsViewController.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dolarTextField: UITextField!
    @IBOutlet weak var iofTextValue: UITextField!
    
    // MARK: - Variables
    
    var stateList: [State] = [] {
        didSet { tableView.reloadData() }
    }
    
    var selectedState: State?
    
    var dolarValue: String {
        AppSettingsManager.shared.getDolarValue().getDolarValue()
    }
    
    var iofValue: String {
        String(AppSettingsManager.shared.getIOFValue())
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - Layout Functions
    
    private func setupView() {
        tableView.register(StateViewCellTableViewCell.self, forCellReuseIdentifier: StateViewCellTableViewCell.identifier)
    }
    
    // MARK: - Private Functions

    private func fetchData() {
        stateList = StateCoreDataService.shared.fetchState()
        iofTextValue.text = iofValue
        dolarTextField.text = dolarValue
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAddStateButton(_ sender: UIButton) {
        showStateAlert(isUpdating: false)
    }
    
    // MARK: - Private Functions
    
    private func createNewStateWith(name: String, taxValue: String) {
        let newState = StateCoreDataService.shared.createNewState()
        newState.name = name
        newState.stateTax = Double(taxValue) ?? 0
        StateCoreDataService.shared.saveChanges()
        didUpdateStateDataBase()
    }
    
    private func updateSelectedStateWith(name: String, taxValue: String) {
        selectedState?.name = name
        selectedState?.stateTax = Double(taxValue.replacingOccurrences(of: ",", with: ".")) ?? 0
        StateCoreDataService.shared.saveChanges()
        didUpdateStateDataBase()
    }
    
    // MARK: - Alert Actions
    
    private func showStateAlert(isUpdating: Bool, name: String = "", taxValue: String = "") {
        let title = isUpdating ? "Atualizar estado" : "Adicionar estado"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome do estado"
            textField.text = name
            textField.autocapitalizationType = .words
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Imposto"
            textField.text = taxValue
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { [weak self] _ in
            let stateName = alert.textFields?.first?.text ?? ""
            let taxValueText = alert.textFields?.last?.text ?? ""
            guard !stateName.isEmpty,
                  taxValueText.isNumeric else { self?.showErrorAlert(); return }
            isUpdating ? self?.updateSelectedStateWith(name: stateName, taxValue: taxValueText) : self?.createNewStateWith(name: stateName, taxValue: taxValueText)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Ops!", message: "Não foi possível salvar as informações, favor validar as informações digitadas.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func saveSelectedState() {
        StateCoreDataService.shared.saveChanges()
        selectedState = nil
    }
    
    private func didUpdateStateDataBase() {
        stateList = StateCoreDataService.shared.fetchState()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StateViewCellTableViewCell.identifier, for: indexPath) as? StateViewCellTableViewCell,
              let state = stateList.get(index: indexPath.row) else { return UITableViewCell() }
        cell.nameLabel.text = state.name
        cell.taxValueLabel.text = "\(state.stateTax) %"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedState = stateList.get(index: indexPath.row)
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
        guard selectedState != nil else { return }
        showStateAlert(isUpdating: true, name: selectedState?.name ?? "", taxValue: "\(selectedState?.stateTax ?? 0)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
        let state = stateList.get(index: indexPath.row) else { return }
        StateCoreDataService.shared.deleteState(state)
        didUpdateStateDataBase()
    }
}
