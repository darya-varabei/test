//
//  ListView.swift
//  test_ui
//
//  Created by Дарья Воробей on 3/8/21.
//

import SwiftUI
import Foundation
import CoreData


struct ListElementToday: View{
    
    var medication: Medication
    let coreDM = CoreDataViewModel()
    @State var checked: Bool = false
    @State private var showAlert = false
    @State private var showUpdAlert = false
    @Environment(\.managedObjectContext) var context
    @State var showLast = false
    @State var selectedDate: Date
    @State var time = ""
    
    var body: some View{
        Color(ColorsSaved.customBlue).opacity(0.0)
            .edgesIgnoringSafeArea(.all)
        ZStack(){
            RoundedRectangle(cornerRadius: 12)
                .frame(width: UIScreen.main.bounds.width - 55, height: 100, alignment: .center)
                .foregroundColor(Color(ColorsSaved.almostWhite))
            
            HStack(spacing: 10){
                
                VStack(alignment: .leading, spacing: 7){
                    Text(medication.generic_name ?? "")
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .frame(width: 180, height: 18, alignment: .leading)
                    Text("\(medication.doze ?? "")  \(medication.dosage_form ?? "")")
                        .font(Font.custom("Karla-Bold", size: 12))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                    
                    HStack(spacing: 20){
                    Text(time)
                        .padding(.top, 13)
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                    
                    if showLast{
                        Text("Last day!")
                            .padding(.top, 13)
                            .font(Font.custom("Karla-Bold", size: 13))
                            .foregroundColor(Color(ColorsSaved.textBlue))
                    }
                    }
                }.padding(.leading, 40)
                
                VStack{
                    CheckBoxView(checkState: medication.state, medication: medication)
               
                    Text("Completed")
                        .font(Font.custom("Karla-Bold", size: 9))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                }
            }
        }.onAppear(perform: formatTime)
        .onAppear(perform: formatDay)
    }
    func formatTime(){
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm"
        self.time = formatter3.string(from: self.medication.time ?? Date())
    }
    
    func formatDay(){
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd MMM"
        
        if (formatter3.string(from: medication.finish_date!) == formatter3.string(from: selectedDate)){
            self.showLast = true
        }
    }
}



struct ListElement: View{
    
    var medication: Medication
    @State var checked: Bool = false
    @State private var showAlert = false
    @State var selectedDate: Date
    @Environment(\.managedObjectContext) var context
    @State var time = ""
    @State var showLast = false
    
    var body: some View{
        Color(ColorsSaved.customBlue).opacity(0.0)
            .edgesIgnoringSafeArea(.all)
        ZStack(){
            RoundedRectangle(cornerRadius: 12)
                .frame(width: UIScreen.main.bounds.width - 55, height: 100, alignment: .center)
                .foregroundColor(Color(ColorsSaved.almostWhite))
            
            HStack(spacing: 10){
                
                VStack(alignment: .leading, spacing: 7){
                    Text(medication.generic_name ?? "")
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .frame(width: UIScreen.main.bounds.width - 190, height: 18, alignment: .leading)
                    Text("\(medication.doze ?? "")  \(medication.dosage_form ?? "")")
                        .font(Font.custom("Karla-Bold", size: 12))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                    
                    HStack(spacing: 20){
                    Text(time)
                        .padding(.top, 13)
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        
                        if showLast{
                            Text("Last day!")
                                .padding(.top, 13)
                                .font(Font.custom("Karla-Bold", size: 13))
                                .foregroundColor(Color(ColorsSaved.textBlue))
                        }
                    }
                }.padding(.leading, 23)
                
                Rectangle()
                    .fill(Color(ColorsSaved.almostWhite))
                    .border(Color.gray)
                    .frame(width:25, height:25, alignment: .center)
                    .cornerRadius(15)
                    .overlay(
                        ZStack{
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        }
                    )
                    .onTapGesture {
                        checked = true
                    }.alert(isPresented: $checked, content: {
                        Alert(
                            title: Text("This medication should not be taken today"),
                            message: Text("We will remind about it later"),
                            dismissButton: .default(Text("Got it!"))
                        )
                    })
            }
        }.onAppear(perform: formatTime)
        .onAppear(perform: formatDay)
    }
    func formatTime(){
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm"
        self.time = formatter3.string(from: self.medication.time ?? Date())
    }
    
    func formatDay(){
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd MMM"
        
        if (formatter3.string(from: medication.finish_date!) == formatter3.string(from: selectedDate)){
            self.showLast = true
        }
    }
}



struct CheckBoxView: View {
    
    @State var checkState: Bool
    @State var medication: Medication
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        Button(action:
                {
                    self.checkState = !self.checkState
                    context.performAndWait {
                        medication.state = !medication.state
                        try? context.save()
                    }
                    print("State : \(self.checkState)")
                    
                }) {
            Rectangle()
                .fill(self.checkState ? Color(ColorsSaved.gradientBlue) : Color(ColorsSaved.clear))
                .border(self.checkState ? Color(ColorsSaved.gradientBlue) : Color(ColorsSaved.clear))
                .frame(width:25, height:25, alignment: .center)
                .cornerRadius(15)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(self.checkState ? Color(ColorsSaved.gradientBlue) : Color.gray, lineWidth: 1)
                        Image(systemName: "checkmark")
                    }
                )
        }
        .foregroundColor(Color.white)
    }
    func updateMedication(item: Medication) {
        var newStatus = item.state == true ? item.state : false

        if(item.state == true){
            newStatus = false
        }
        else{
            newStatus = true
        }
            context.performAndWait {
                item.state = newStatus
                try? context.save()
            }
        }
}

