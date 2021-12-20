//
//  UIImage+Extensions.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import UIKit

extension UIImage {
    func isEqualTo(image: UIImage?) -> Bool {
        self.pngData() == image?.pngData()
    }
}
