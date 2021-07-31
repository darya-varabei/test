//
//  CoreDataModel.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 4/27/21.
//

import Foundation
import SwiftUI

struct CoreDataModel: Decodable, Hashable{
    var product_ndc: String
    var generic_name: String
    var dosage_form: String
    var userId: String
    var start_date: Date
    var finish_date: Date
    var doze: String
    var time: Date
    var state: Bool
}
