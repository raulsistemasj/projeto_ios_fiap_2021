//
//  Array+Extensions.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import Foundation

extension Array {
    func get(index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
