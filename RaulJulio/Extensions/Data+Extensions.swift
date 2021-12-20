//
//  Data+Extensions.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import Foundation
import UIKit

extension Data {
    func asImage() -> UIImage? { UIImage(data: self) }
}
