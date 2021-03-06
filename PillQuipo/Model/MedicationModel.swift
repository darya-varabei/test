//
//  MedicationModel.swift
//  Project
//
//  Created by Дарья Воробей on 3/22/21.
//

import Foundation
import SwiftUI


class MedicationModel: ObservableObject, Codable{
    enum CodingKeys: CodingKey{
        
        case product_ndc, generic_name, labeler_name, dosage_form, userId, start_date, finish_date, doze, time, state
    }

    @Published var product_ndc = ""
    @Published var generic_name = ""
    @Published var labeler_name = ""
    @Published var dosage_form = ""
    @Published var userId = ""
    @Published var start_date = Date()
    @Published var finish_date = Date()
    @Published var doze = ""
    @Published var time = Date()
    @Published var state = false
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        product_ndc = try container.decode(String.self, forKey: .product_ndc)
        generic_name = try container.decode(String.self, forKey: .generic_name)

        labeler_name = try container.decode(String.self, forKey: .labeler_name)
        dosage_form = try container.decode(String.self, forKey: .dosage_form)

        userId = try container.decode(String.self, forKey: .userId)
        start_date = try container.decode(Date.self, forKey: .start_date)
        finish_date = try container.decode(Date.self, forKey: .finish_date)
        doze = try container.decode(String.self, forKey: .doze)
        time = try container.decode(Date.self, forKey: .time)
        state = try container.decode(Bool.self, forKey: .state)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(product_ndc, forKey: .product_ndc)
        try container.encode(generic_name, forKey: .generic_name)

        try container.encode(labeler_name, forKey: .labeler_name)
        try container.encode(dosage_form, forKey: .dosage_form)

        try container.encode(userId, forKey: .userId)
        try container.encode(start_date, forKey: .start_date)
        try container.encode(finish_date, forKey: .finish_date)
        try container.encode(doze, forKey: .doze)
        try container.encode(time, forKey: .time)
        try container.encode(state, forKey: .state)
    }
}


