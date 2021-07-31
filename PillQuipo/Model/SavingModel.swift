//
//  SavingModel.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 5/21/21.
//

import Foundation
import SwiftUI

struct SavingModel: Decodable, Hashable{
    var product_ndc: String
    var generic_name: String
    var dosage_form: String
    var imageD: String
    var dayNum: Int
    var instruction: String
}

