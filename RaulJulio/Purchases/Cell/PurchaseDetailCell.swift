//
//  PurchaseDetailCell.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

final class PurchaseDetailCell: UITableViewCell {
    static let identifier = String(describing: PurchaseDetailCell.self)
    
    // MARK: - Views
    
    private lazy var photo: UIImageView = {
        let element = UIImageView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.clipsToBounds = true
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 50
        return element
    }()
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.font = .systemFont(ofSize: 18)
        element.textColor = .black
        element.numberOfLines = 0
        element.lineBreakMode = .byWordWrapping
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.font = .systemFont(ofSize: 18)
        element.textColor = .blue
        element.numberOfLines = 0
        element.lineBreakMode = .byWordWrapping
        return element
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Layout Functions
    
    private func setupViews() {
        addComponents()
        addComponentsConstraints()
    }
    
    private func addComponents() {
        contentView.addSubview(photo)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func addComponentsConstraints() {
        addPhotoConstraints()
        addNameLabelConstraints()
        addPriceLabelConstraints()
    }
    
    private func addPhotoConstraints() {
        photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        photo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        photo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func addNameLabelConstraints() {
        nameLabel.topAnchor.constraint(equalTo: photo.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    private func addPriceLabelConstraints() {
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: photo.bottomAnchor).isActive = true
    }
    
    // MARK: - Configuration
    
    public func configure(with model: Purchases.Model.PurchaseDetailViewModel) {
        photo.image = model.photo
        nameLabel.text = model.name
        priceLabel.text = model.price
    }
}
