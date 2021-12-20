//
//  RaulJulioFormViewController.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

protocol FormViewControllerDelegate: AnyObject {
    func didUpdateProduct()
}

final class FormViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var isCardSwitch: UISwitch!

    // MARK: - Views
    
    private lazy var statePicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapPickerDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapPickerCancelButton))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    // MARK: - Delegate
    
    weak var delegate: FormViewControllerDelegate?
    
    // MARK: - Variables
    
    private lazy var isCameraAvailable: Bool = { UIImagePickerController.isSourceTypeAvailable(.camera) }()
    var selectedProduct: Product?
    private var selectedState: State?
    private var stateList: [State] = [] {
        didSet { statePicker.reloadAllComponents() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayProductDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStateList()
    }
    
    // MARK: - Layout Functions
    
    private func setupViews() {
        setupProductImageAction()
        stateTextField.inputView = statePicker
        stateTextField.inputAccessoryView = toolBar
    }
    
    private func setupProductImageAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapGesture)
    }
    
    private func checkImageErrorStatus(_ imageView: inout UIImageView, _ hasError: Bool) {
        imageView.layer.borderWidth = hasError ? 1 : 0
        imageView.layer.borderColor = hasError ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
    
    private func checkFieldErrorStatus(_ field: inout UITextField, _ hasError: Bool) {
        field.layer.borderWidth = hasError ? 1 : 0
        field.layer.borderColor = hasError ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Private functions
    
    private func showPhotoAccessAlert() {
        var alert = UIAlertController(title: "Escolher imagem", message: "De onde você deseja escolher a imagem?", preferredStyle: .actionSheet)
        addAlertActions(&alert)
        present(alert, animated: true, completion: nil)
    }
    
    private func addAlertActions(_ alert: inout UIAlertController) {
        if isCameraAvailable {
            let cameraOption = UIAlertAction(title: "Câmera", style: .default, handler: didTapCameraOption)
            alert.addAction(cameraOption)
        }
        
        let libraryOption = UIAlertAction(title: "Biblioteca de Fotos", style: .default, handler: didTapLibraryOption)
        alert.addAction(libraryOption)
        
        let photosOption = UIAlertAction(title: "Álbum de Fotos", style: .default, handler: didTapPhotosOption)
        alert.addAction(photosOption)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
    }
    
    private func chooseImage(from source: UIImagePickerController.SourceType) {
        view.endEditing(true)
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func validateAllFields() -> Bool {
        let hasSameImage = productImage.image?.isEqualTo(image: UIImage(named: "noProductImage")) ?? false
        let isEmptyName = (nameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isEmptyState = (stateTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isEmptyValue = (valueTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isValueNumeric = (valueTextField.text ?? "").isNumeric
        
        checkFieldErrorStatus(&nameTextField, isEmptyName)
        checkFieldErrorStatus(&stateTextField, isEmptyState)
        checkFieldErrorStatus(&valueTextField, isEmptyValue)
        checkFieldErrorStatus(&valueTextField, !isValueNumeric)
        checkImageErrorStatus(&productImage, hasSameImage)
        
        return !isEmptyName && !isEmptyState && !isEmptyValue && !hasSameImage && selectedState != nil && isValueNumeric
    }
    
    private func updateStateList() {
        stateList = StateCoreDataService.shared.fetchState()
    }
    
    private func displayProductDetails() {
        if let image = selectedProduct?.image?.asImage() { productImage.image = image }
        if let value = selectedProduct?.value, value > 0 { valueTextField.text = value.getDolarValue() }
        nameTextField.text = selectedProduct?.name
        selectedState = selectedProduct?.state
        stateTextField.text = selectedProduct?.state?.name
        isCardSwitch.isOn = selectedProduct?.isCardProduct ?? false
    }
    
    private func updateSelectedProduct() {
        if selectedProduct == nil { selectedProduct = ProductCoreDataService.shared.createNewProduct() }
        selectedProduct?.image = productImage.image?.pngData()
        selectedProduct?.name = nameTextField.text
        selectedProduct?.state = selectedState
        selectedProduct?.value = Double(valueTextField.text?.replacingOccurrences(of: ",", with: "") ?? "0") ?? 0
        selectedProduct?.isCardProduct = isCardSwitch.isOn
    }
    
    // MARK: - Actions
    
    @IBAction func confirmAction(_ sender: UIButton) {
        guard validateAllFields() else { return }
        updateSelectedProduct()
        ProductCoreDataService.shared.saveChanges()
        delegate?.didUpdateProduct()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapProductImage() {
        showPhotoAccessAlert()
    }
    
    private func didTapCameraOption(_ action: UIAlertAction) {
        chooseImage(from: .camera)
    }
    
    private func didTapLibraryOption(_ action: UIAlertAction) {
        chooseImage(from: .photoLibrary)
    }
    
    private func didTapPhotosOption(_ action: UIAlertAction) {
        chooseImage(from: .savedPhotosAlbum)
    }
    
    @objc private func didTapPickerDoneButton() {
        stateTextField.text = selectedState?.name
        stateTextField.resignFirstResponder()
    }
    
    @objc private func didTapPickerCancelButton() {
        stateTextField.resignFirstResponder()
    }
    
}

extension FormViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            productImage.image = image
            productImage.backgroundColor = .white
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { stateList.count }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        stateList.get(index: row)?.name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = stateList.get(index: row)
    }
}


