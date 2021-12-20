//
//  StateViewCellTableViewCell.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

final class StateViewCellTableViewCell: UITableViewCell {
    static let identifier = String(describing: StateViewCellTableViewCell.self)
    
    // MARK: - Views
    
    lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.textColor = .black
        element.font = .systemFont(ofSize: 18)
        element.textAlignment = .left
        element.lineBreakMode = .byWordWrapping
        element.numberOfLines = 0
        return element
    }()
    
    lazy var taxValueLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.textColor = .red
        element.font = .systemFont(ofSize: 18)
        element.textAlignment = .right
        element.lineBreakMode = .byWordWrapping
        element.numberOfLines = 0
        return element
    }()
    
    // MARK: - LifeCyle
    
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
        nameLabel.text = nil
        taxValueLabel.text = nil
    }

    // MARK: - Layout Functions
    
    private func setupViews() {
        addComponents()
        addComponentsConstraints()
    }
    
    private func addComponents() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(taxValueLabel)
    }
    
    private func addComponentsConstraints() {
        addNameLabelConstraints()
        addTaxValueLabelConstraints()
    }
    
    private func addNameLabelConstraints() {
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: taxValueLabel.leadingAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func addTaxValueLabelConstraints() {
        taxValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        taxValueLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
    }
}
