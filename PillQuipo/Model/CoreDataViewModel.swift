//
//  CoreDataViewModel.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 4/28/21.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject{
    
    @Published var medications: [CoreDataModel] = []
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "HelloCoreDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func saveData(context: NSManagedObjectContext){
        
        medications.forEach{ (data) in
            
            let entity = Medication(context: context)
            entity.dosage_form = data.dosage_form
            entity.doze = data.doze
            entity.finish_date = data.finish_date
            entity.generic_name = data.generic_name
            entity.start_date = data.start_date
            entity.state = data.state
            entity.time = data.time
            entity.userId = data.dosage_form
            
        }
        
        do{
            try context.save()
            print("success")
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    func updateMedication() {
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
        
    }
    
    
    func deleteMedication(medication: Medication) {
        
        persistentContainer.viewContext.delete(medication)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func getAllMedications() -> [Medication] {
        
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
        
    }
}
