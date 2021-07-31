//
//  FullListView.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 5/6/21.
//

import SwiftUI

struct FullListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.managedObjectContext) var context
    @State var showAlert = false
    
    @FetchRequest(
        entity: Medication.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Medication.generic_name, ascending: true)
            ],
            predicate: NSPredicate(format: "userId == %@", userKey)
    ) var medication: FetchedResults<Medication>
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                NavigationView(){
                    if self.medication.isEmpty{
                        VStack(spacing: 20){
                            
                            Text("😇")
                                .font(.system(size: 80))
                        Text("Medication history is empty")
                            .font(Font.custom("Karla-Bold", size: 18))
                            .foregroundColor(Color(ColorsSaved.gradientBlue))
                        }
                        .offset(y: -50)
                    }
                    List(){
                        ForEach(medication){ item in
                            if item.userId == userKey{
                                NavigationLink(destination: updatePill(medicationToUpdate: item, name: item.generic_name!, dosage: item.doze!, dosage_form: item.dosage_form!, start_date: item.start_date!, finish_date: item.finish_date!)) {
                                    Text("\(item.generic_name!),   \(item.doze!) \(item.dosage_form!)")
                                        .font(Font.custom("Karla-Bold", size: 15))
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewContext.delete(medication[index])
                            }
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }.navigationBarTitle("")
                    .navigationBarHidden(true)
                    .padding(.horizontal, 10)
                    .offset(y: 70)
                }
                .frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height - 145, alignment: .center)
                .cornerRadius(25)
            }
            Text("Medication history")
                .font(Font.custom("Karla-Bold", size: 20))
                .foregroundColor(Color(ColorsSaved.gradientBlue))
                .offset(y: -210)
        }
    }
}

struct FullListView_Previews: PreviewProvider {
    static var previews: some View {
        FullListView()
    }
}
