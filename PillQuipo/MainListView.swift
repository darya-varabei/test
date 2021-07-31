//
//  MainListView.swift
//  test_ui
//
//  Created by Дарья Воробей on 3/7/21.
//

import SwiftUI

struct MainListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var countPositionsToday = false
    @State var countPositions = 0
    @Environment(\.managedObjectContext) var context
    @State var selectedDate = dates[0]
    @State var ifContent = false
    @State var counter = 0
    
    @FetchRequest(
        entity: Medication.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Medication.time, ascending: true)
        ],
        predicate: NSPredicate(format: "userId == %@", userKey)
    ) var medication: FetchedResults<Medication>
    
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(){
                if medication.isEmpty{
                    EmptyListView()
                        .padding(.bottom, 40)
                }
                
                else{
                    ScrollView(.vertical, showsIndicators: false) {
                        LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                        VStack(alignment: .center) {
                            ForEach(medication) { item in
                                let isNotEarlier = Calendar.current.compare(selectedDate, to: item.start_date!, toGranularity: .hour)
                                let isNotLatter = Calendar.current.compare(selectedDate, to: item.finish_date!, toGranularity: .hour)
                                if ((isNotEarlier == .orderedDescending || isNotEarlier == .orderedSame) && (isNotLatter == .orderedAscending || isNotLatter == .orderedSame)){
                                    let today = Calendar.current.compare(selectedDate, to: Date(), toGranularity: .hour)
                                    if today == .orderedSame {
                                        ListElementToday(medication: item, selectedDate: selectedDate)
                                    }
                                    else{
                                        ListElement(medication: item, selectedDate: selectedDate)
                                    }
                                    }
                            }
                        }
                    }
                }
            }.padding(.top, 160)
            .padding(.bottom, 80)
            
            VStack(){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 180)
                        .foregroundColor(Color(ColorsSaved.almostWhite))
                        .background(Color(ColorsSaved.almostWhite))
                        .shadow(radius: 10)
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(dates, id: \.self) { date in
                                    DayView(date: date, selectedDate: self.$selectedDate)
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        SelectedDayView(selectedDate: $selectedDate)
                    }.padding(.top, 50)
                    .padding(.horizontal, 25)
                }
            }.padding(.bottom, UIScreen.main.bounds.height - 170)
        }
        .animation(.easeInOut)
    }
    
    func predic(){
        let datePredicate = NSPredicate(format: "start_date > %@", self.selectedDate as CVarArg)
        print(datePredicate)
    }
}
