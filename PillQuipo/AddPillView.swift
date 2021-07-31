//
//  AddPillView.swift
//  Care-time
//
//  Created by Дарья Воробей on 3/19/21.
//

import SwiftUI
import CodeScanner
import AVFoundation
import UserNotifications

enum ActiveAlert {
    case first, second
}

struct Responses: Codable{
    var results: [Resul]
}

struct Resul: Codable, Hashable {
    var product_ndc: String
    var generic_name: String
    var labeler_name: String
    var dosage_form: String
}

struct PillInfoView: View {
    @State var imageD: String
    @State var image: Data = .init(count: 0)
    @State var recommendations: String
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(Color(ColorsSaved.almostWhite))
                .frame(width: 200, height: 300, alignment: .center)
                .shadow(radius: 10)
          
            VStack{
                Image(imageD)
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .top)
                    .padding(.top, 20)
                
                Text("\(recommendations)")
                    .frame(width: 150, height: 150, alignment: .top)
            }
        }
    }
}

struct AddPillView: View {
    
    @State var index = 0
    @State var isListed = false
    @State var result = MedicationModel()
    @State private var isShowingScanner = false
    @State var text = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(1), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(){
                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                            self.index=0
                        }
                    }){
                        Text("Custom")
                            .font(Font.custom("Karla-Bold", size: 12))
                            .padding(.vertical, 10)
                            .frame(width: (UIScreen.main.bounds.width - 80) / 3)
                            .foregroundColor(self.index == 0 ? .black: .white)
                    }.background(self.index == 0 ? Color.white: Color.clear)
                    .clipShape(Capsule())
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                            self.index = 1
                            self.isShowingScanner = true
                        }
                    }){
                        Text("Scan barcode")
                            .font(Font.custom("Karla-Bold", size: 12))
                            .padding(.vertical, 10)
                            .frame(width: (UIScreen.main.bounds.width - 80) / 3)
                            .foregroundColor(self.index == 1 ? .black: .white)
                    }.background(self.index == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())

                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                            self.index=2
                        }
                    }){
                        Text("Search")
                            .font(Font.custom("Karla-Bold", size: 12))
                            .padding(.vertical, 10)
                            .frame(width: (UIScreen.main.bounds.width - 80) / 3)
                            .foregroundColor(self.index == 2 ? .black: .white)
                    }.background(self.index == 2 ? Color.white: Color.clear)
                    .clipShape(Capsule())
                    
                }.background(Color.black.opacity(0.1))
                .clipShape(Capsule())
                .padding(.bottom, 20)
                
                if self.index == 0 {
                    addCustomPill(name: result.generic_name, dosage: result.dosage_form, dosage_form: "Capsule", dayNum: 0, start_date:Date(), finish_date:Date(), imageD: .init(""), recomendations: "")
                }
                 else if self.index == 1 {
                    addByScanner()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 255, alignment: .center)
                }
                else {
                    addBySearch(text: text)
                }
                if isListed{
                    MainTabView()
                }
            }
        }
    }
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 5)
            .speed(1)
            .delay(1 * Double(index))
    }
}

struct addCustomPill: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selected = 0
    @State var index = 0
    @State private var activeAlert: ActiveAlert = .first
    @State private var showAlert = false
    @StateObject var medication = MedicationModel()
    @State var medications: [Medication] = [Medication]()
    @State var name: String
    @State var dosage: String
    @State var dosage_form: String
    @State var dayNum: Int
    @State var dayNumInt: Int = 0
    @State var start_date: Date
    @State var finish_date: Date
    @State var showRecommendations = false
    @State var imageD: String

    @State var recomendations: String
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var doze = 1
    var types: [String] = ["Capsule", "Tablet", "Injection", "Gel", "Concentrate", "Liquid", "Aerosol", "Cream", "Spray", "Suspension", "Other"]
    @State var selection: String = "Capsule"
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }
    
    var body: some View{
        ZStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
                    .frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height - 205, alignment: .center)
                VStack(alignment: .leading){
                    
                    HStack(spacing: 90){
                    Text("Add new medicine")
                        .font(Font.custom("Karla-Bold", size: 20))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.leading, 20)
                        
                        if imageD != ""{
                        Text("Show info")
                            .underline()
                            .font(Font.custom("Karla-Bold", size: 14))
                            .foregroundColor(Color(ColorsSaved.textBlue))
                            .onTapGesture {
                                self.showRecommendations.toggle()
                            }
                        }
                    }
                    
                    TextField("Medication name", text: $name)
                        .padding(.all, 10)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding()
                    HStack{
                        TextField("Enter doze...", text: $medication.doze)
                            .frame(width: 100, height: 20)
                            .padding(.all, 10)
                            .foregroundColor(Color(ColorsSaved.textBlue))
                            .background(lightGreyColor)
                            .cornerRadius(5.0)
                        
                        HStack(spacing: 0){
                            Picker(self.dosage_form, selection: self.$dosage_form) {
                                ForEach(types, id: \.self) { word in
                                    Text(word)
                                        .underline()
                                        .font(Font.custom("Karla-Bold", size: 10))
                                        .tag(word)
                                        .frame(width: 100)
                                }
                            }.foregroundColor(Color(ColorsSaved.textBlue))
                            .frame(width: 100)
                            .font(Font.custom("Karla-Bold", size: 18))
                            .pickerStyle(MenuPickerStyle())
                            Image(systemName:"chevron.down")
                        }
                    }.padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    
                    if imageD != ""{
                    HStack(alignment: .center){
                            
                        Button(action: {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                self.index=0
                            }
                        }){
                            Text("Custom dates")
                                .font(Font.custom("Karla-Bold", size: 12))
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - 80) / 3)
                                .foregroundColor(self.index == 0 ? .white: Color(ColorsSaved.gradientBlue))
                        }.background(self.index == 0 ? Color(ColorsSaved.gradientBlue): Color.clear)
                        .clipShape(Capsule())
                        
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                self.index = 1
                                self.recomendedDates()
                            }
                        }){
                            Text("Recommended dates")
                                .font(Font.custom("Karla-Bold", size: 12))
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - 80) / 3)
                                .foregroundColor(self.index == 1 ? .white: Color(ColorsSaved.gradientBlue))
                        }.background(self.index == 1 ? Color(ColorsSaved.gradientBlue): Color.clear)
                        .clipShape(Capsule())
                        
                    }.padding(.leading, 20)
                    }
                    
                    DatePicker("Choose start date",selection: $medication.start_date, displayedComponents: .date)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                        .disabled(index == 1)

                    DatePicker("Choose finish date",selection: $medication.finish_date, displayedComponents: .date)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                        .disabled(index == 1)

                    DatePicker("Choose time",selection: $medication.time, displayedComponents: .hourAndMinute)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                    Button(action: {
                        
                        if index == 1{
                        self.recomendedDates()
                        }
                        
                        if name == "" || medication.doze == "" || medication.start_date >= medication.finish_date{
                            self.activeAlert = .first
                        }
                        else{
                            self.activeAlert = .second
                            medication.generic_name = name
                           
                            let medicationData = Medication(context: viewContext)
                            medicationData.generic_name = name
                            medicationData.dosage_form = dosage_form
                            medicationData.doze = medication.doze
                            medicationData.start_date = medication.start_date
                            medicationData.finish_date = medication.finish_date
                            medicationData.state = false
                            medicationData.time = medication.time
                            medicationData.userId = userKey
                            
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: medication.time)
                            let minutes = calendar.component(.minute, from: medication.time)
                            
                            self.setUpLocalNotification(hour: hour, minute: minutes, date: medication.start_date)
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            name = ""
                            dosage = ""
                            medication.finish_date = Date()
                            medication.start_date = Date()
                            medication.doze = ""
                        }
                        self.showAlert = true
                    })
                    {
                        Text("Add")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                    }.alert(isPresented:$showAlert) {
                        switch activeAlert{
                        case .first:
                            return Alert(
                                title: Text("Invalid input!"),
                                message: Text("Fill content properly"),
                                dismissButton: .default(Text("Got it!"))
                            )
                        case .second:
                            return Alert(
                                title: Text("A new medication has been added successfully"),
                                message: Text("Scheduled medications are shown on home screen"),
                                dismissButton: .default(Text("Got it!"))
                            )
                        }
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                    .offset(y: 15)
                    .padding(.leading, 100)
                    .shadow(radius: 15)
                }.padding(.bottom, 50)
                
                if showRecommendations{
                    PillInfoView(imageD: imageD, recommendations: recomendations)
                        .animation(.ripple(index: 250))
                }
            }.padding(.horizontal, 20)
            .cornerRadius(25)
        }
    }
    
    func setUpLocalNotification(hour: Int, minute: Int, date: Date) {
        
        if(date <= Date() || notification){

        let calendar = NSCalendar(identifier: .gregorian)!;

        var dateFire = Date()
        var fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire)

        if (fireComponents.hour! > hour
            || (fireComponents.hour == hour && fireComponents.minute! >= minute) ) {

            dateFire = dateFire.addingTimeInterval(8886400)
            fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire);
        }
        fireComponents.hour = hour
        fireComponents.minute = minute
        dateFire = calendar.date(from: fireComponents)!

        let localNotification = UNUserNotificationCenter.current()
        
        
                let content = UNMutableNotificationContent()
                content.title = "PillQuipo"
                content.subtitle = "Hey,\(username), it's time to take care of your health"
                content.sound = UNNotificationSound.default

                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
        
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                localNotification.add(request)
        }
    }
    
    func recomendedDates(){
       
        self.medication.finish_date = self.medication.start_date.addingTimeInterval(TimeInterval(86400*self.dayNum))
    }
}


struct addByScanner: View{

    @Environment(\.managedObjectContext) private var viewContext

    @State var isPresentingScanner = false
    @State var scannedCode: String?
    @State private var isShowingScanner = false
    @State var medication = MedicationModel()
    @State var result = [SavingModel]()
    @State var showingAlert = false
    @State var name = ""
    @State var ndc = ""
    @State var form = ""
    @State var dayNum = 0
    @State var dayNumInt = 0
    @State var imaget = ""
    @State var instruction = ""


    @FetchRequest(
        entity: Saving.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Saving.generic_name, ascending: false)
        ]

    ) var medications: FetchedResults<Saving>

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(1), Color(ColorsSaved.gradientTorquise).opacity(1)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack{
                ZStack() {
                    CodeScannerView(
                        codeTypes: [.qr, .ean13, .code128],
                        completion: { result in
                            if case let .success(code) = result {
                                self.scannedCode = code

                                if medications.isEmpty{
                                    print("Empty")
                                }
                                for item in medications{
                                    print(item)
                                    if item.product_ndc == scannedCode{
                                        print(scannedCode!)
                                        form = item.dosage_form!
                                        name = item.generic_name!
                                        dayNumInt = Int(item.dayNum)
                                        instruction = item.recommendation!
                                        imaget = item.imageD!
                                    }
                                }
                            }
                        }
                    )
                    if name != ""{
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(1), Color(ColorsSaved.gradientTorquise).opacity(1.0)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                            addCustomPill(name: name, dosage: "", dosage_form: form, dayNum: dayNumInt, start_date: Date(), finish_date: Date(), imageD: imaget, recomendations: instruction)
                        }
                    }

                }
            }
  //      }
        }.onAppear(perform: {
            if result.isEmpty{
            core()
        }
        })
    
    }
    func data(){
        for item in medications{
            if item.product_ndc == scannedCode{
                print(scannedCode!)
                medication.dosage_form = item.dosage_form!
                medication.generic_name = item.generic_name!
            }
        }
   }

    func core(){

        result.append(SavingModel(product_ndc: "5903060016507", generic_name: "Ibufen", dosage_form: "Capsule", imageD: "Ibufen", dayNum: 3, instruction: "Antipyretic. Recommended to take for up to 3 days with time interval 4-6"))
        result.append(SavingModel(product_ndc: "5997001381649", generic_name: "Verospiron", dosage_form: "Tablet", imageD: "verospiron-tab", dayNum: 21, instruction: "Decongestant. Recommneded to take 1-2 times a day after meals up to 4 pills a day"))
        result.append(SavingModel(product_ndc: "5995327121062", generic_name: "Halixol", dosage_form: "Tablet", imageD: "Halixol", dayNum: 5, instruction: "Recommended to take up to 3 tablets a day for 5 days(for adults)"))
        result.append(SavingModel(product_ndc: "3838989698799", generic_name: "Septolete", dosage_form: "Tablet", imageD: "Septolete", dayNum: 7, instruction: "Recommended dose for adults is 3-4 tablets a day with 3-6 hours time interval"))
        result.append(SavingModel(product_ndc: "4607008130140", generic_name: "Augmentin", dosage_form: "Tablet", imageD: "Augmentin", dayNum: 7, instruction: "Recommended dose for adults is 2 tablets a day with for 7 days"))
        result.append(SavingModel(product_ndc: "4601378008276", generic_name: "Shalpheum", dosage_form: "Tablet", imageD: "Shalfeum", dayNum: 7, instruction: "Recommended dose for adults is 6 tablets a day with 2 hours time interval"))
        result.append(SavingModel(product_ndc: "4870206091197", generic_name: "Panadol", dosage_form: "Tablet", imageD: "Panadol", dayNum: 3, instruction: "Recommended dose for adults is 1-2 tablets every 6 hours up to 3 days"))
        result.append(SavingModel(product_ndc: "5997001360989", generic_name: "Vermox", dosage_form: "Tablet", imageD: "Panadol", dayNum: 3, instruction: "Recommended dose for adults is 1 tablets 2 times a day  up to 3 days"))
        result.append(SavingModel(product_ndc: "8699540091023", generic_name: "Megasef", dosage_form: "Capsule", imageD: "Megasef", dayNum: 14, instruction: "Recommended doze depends on patients weight"))
        result.append(SavingModel(product_ndc: "4820044930851", generic_name: "Celestoderm", dosage_form: "Gel", imageD: "Celestoderm", dayNum: 21, instruction: "Recommended doze depends on sympthoms"))
        result.append(SavingModel(product_ndc: "4810201015095", generic_name: "Ibuclin", dosage_form: "Tablet", imageD: "Ibuclin", dayNum: 21, instruction: "Recommended doze for adults is 3-4 tablets a day up to 3 days"))
        result.append(SavingModel(product_ndc: "4603619000087", generic_name: "Rhynofluimucil", dosage_form: "Spray", imageD: "Rhyno", dayNum: 20, instruction: "Recommended doze fr adults is 2 spray dozes 2 times a day  up to 20 days days"))
        for item in result {
            print(item)
            print("Ok")
            let newItem = Saving(context: viewContext)
            newItem.generic_name = item.generic_name
            newItem.product_ndc = item.product_ndc
            newItem.dosage_form = item.dosage_form
            newItem.imageD = item.imageD
            newItem.dayNum = Int16(item.dayNum)
            newItem.recommendation = item.instruction

            do {
                try viewContext.save()
            } catch {
                print("No")
            }
        }
    }

}

struct addBySearch: View{
    
    @State var result = [Resul]()
    @State var text: String
    @State var results = MedicationModel()
    @State var searchText = ""
    @State var isSearching = false
    @State var hideBar = false
    
    var body: some View {
        ZStack(alignment: .top){
            
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(ColorsSaved.almostWhite))
                .frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height - 255, alignment: .center)
                
                NavigationView {
                    List{
                        SearchBar(searchText: $searchText, isSearching: $isSearching)
                            .frame(alignment: .center)
                        VStack{
                            if result.isEmpty{
                                LoadingView()
                                    .padding(.top, 100)
                            }
                            
                        List((result).filter({ "\($0)".contains(searchText) || searchText.isEmpty }), id: \.self) { item in
                            
                            VStack(alignment: .leading){
                                NavigationLink(destination: addCustomPill(name: item.generic_name, dosage: item.dosage_form, dosage_form: item.dosage_form, dayNum: 0, start_date: Date(), finish_date: Date(), imageD: "", recomendations: "")) {
                                    Text("\(item.generic_name), \(item.labeler_name)")
                                        .font(Font.custom("Karla-Bold", size: 15))
                                }.navigationBarHidden(true)
                                .foregroundColor(Color(ColorsSaved.textBlue))
                            }.navigationBarHidden(true)
                        }.frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height - 255)
                        .navigationBarHidden(true)
                    } .navigationBarHidden(true)
                } .navigationBarTitle("")
                .navigationBarHidden(true)
                }.onAppear(perform: {
                        loadData()
                })
            .navigationBarHidden(true)
            .padding(.top, 5)
            .cornerRadius(25)
                .frame(width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.height - 255, alignment: .center)
            .foregroundColor(Color(ColorsSaved.almostWhite))
        }
    }
    func loadData(){
        guard let url = URL(string: "https://api.fda.gov/drug/ndc.json?api_key=C6oBLYcNLGTcYx7VndRjAkyrnBuHD7fYUp7PMxAL&limit=1000")
        
        else{
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                if let decodedResponse = try? JSONDecoder().decode(Responses.self, from: data){
                    DispatchQueue.main.async{
                        self.result = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed")
        }.resume()
    }
}


struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("Search terms here", text: $searchText)
                    .foregroundColor(Color(ColorsSaved.textBlue))
                    .padding(.leading, 24)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            .onTapGesture(perform: {
                isSearching = true
            })
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    
                }.padding(.horizontal, 32)
                .foregroundColor(.gray)
            ).transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .padding(.trailing)
                        .padding(.leading, 0)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
        }
    }
}

struct updatePill: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var medicationToUpdate: Medication
    @State private var activeAlert: ActiveAlert = .first
    @State private var showAlert = false
    @StateObject var medication = MedicationModel()
    @State var name: String
    @State var dosage: String
    @State var dosage_form: String
    @State var start_date: Date
    @State var finish_date: Date
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    var types: [String] = ["Capsule", "Tablet", "Injection", "Gel", "Concentrate", "Liquid", "Aerosol", "Cream", "Spray", "Suspension", "Other"]
    @State var selection: String = "Capsule"
    
    var body: some View{
        ZStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
                    .frame(width: UIScreen.main.bounds.width - 15, height: UIScreen.main.bounds.height - 255, alignment: .center)
                VStack(alignment: .leading){
                    Text("Update medication")
                        .font(Font.custom("Karla-Bold", size: 20))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.leading, 20)
                    
                    TextField("Medication name", text: $name)
                        .padding(.all, 10)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding()
                    HStack{
                        TextField("Enter doze...", text: $dosage)
                            .frame(width: 100, height: 20)
                            .padding(.all, 10)
                            .foregroundColor(Color(ColorsSaved.textBlue))
                            .background(lightGreyColor)
                            .cornerRadius(5.0)
                        
                        HStack(spacing: 0){
                            Picker(self.dosage_form, selection: self.$dosage_form) {
                                ForEach(types, id: \.self) { word in
                                    Text(word)
                                        .underline()
                                        .font(Font.custom("Karla-Bold", size: 10))
                                        .tag(word)
                                        .frame(width: 100)
                                }
                            }.foregroundColor(Color(ColorsSaved.textBlue))
                            .frame(width: 100)
                            .font(Font.custom("Karla-Bold", size: 12))
                            .pickerStyle(MenuPickerStyle())
                            Image(systemName:"chevron.down")
                        }
                    }.padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    
                    
                    DatePicker("Choose start date",selection: $medication.start_date, displayedComponents: .date)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                    DatePicker("Choose finish date",selection: $medication.finish_date, displayedComponents: .date)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                    DatePicker("Choose time",selection: $medication.time, displayedComponents: .hourAndMinute)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .padding(.horizontal, 20)
                    Button(action: {
                        if name == "" || dosage == "" || medication.start_date >= medication.finish_date{
                            self.activeAlert = .first
                        }
                        else{
                            medicationToUpdate.generic_name = name
                            medicationToUpdate.doze = dosage
                            medicationToUpdate.dosage_form = dosage_form
                            
                            self.activeAlert = .second
                            self.updateMedication(updatedMedication: medicationToUpdate)
                            do {
                                try viewContext.save()
                              
                                print("Order saved.")
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            name = ""
                            dosage = ""
                            medication.finish_date = Date()
                            medication.start_date = Date()
                        }
                        self.showAlert = true
                    })
                    {
                        Text("Update")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                    }.alert(isPresented:$showAlert) {
                        switch activeAlert{
                        case .first:
                            return Alert(
                                title: Text("Invalid input!"),
                                message: Text("Fill content properly"),
                                dismissButton: .default(Text("Got it!"))
                            )
                        case .second:
                            return Alert(
                                title: Text("Medication updated successfully"),
                                message: Text("Reopen app to view changes"),
                                dismissButton: .default(Text("Got it!"))
                            )
                        }
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                    .offset(y: 30)
                    .padding(.leading, 100)
                    .shadow(radius: 15)
                }.padding(.bottom, 40)
            }.padding(.horizontal, 20)
            .cornerRadius(25)
        }
    }
    func updateMedication(updatedMedication: Medication) {
            viewContext.performAndWait {
                updatedMedication.generic_name = name
                updatedMedication.doze = dosage
                updatedMedication.dosage_form = dosage_form
                updatedMedication.start_date = medication.start_date
                updatedMedication.finish_date = medication.finish_date
                try? viewContext.save()
            }
        }
}


struct AddPillView_Previews: PreviewProvider {
    static var previews: some View {
        AddPillView()
    }
}


//        func core(){
//
//        result.append(Resul(product_ndc: "5010232954250", generic_name: "Classic condom", labeler_name: "Durex", dosage_form: "Item"))
//        result.append(Resul(product_ndc: "5903060016507", generic_name: "Ibufen", labeler_name: "Orion pharma", dosage_form: "Capsule"))
//        result.append(Resul(product_ndc: "5997001381649", generic_name: "Verospiron", labeler_name: "Gideon Richter", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "5995327121062", generic_name: "Halixol", labeler_name: "Cegis", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "3838989698799", generic_name: "Septolete", labeler_name: "KPKA", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "4607008130140", generic_name: "Augmentin", labeler_name: "Glakso", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "4029799124137", generic_name: "Sinupret", labeler_name: "Bionica", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "4870206091197", generic_name: "Panadol", labeler_name: "Glakso", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "5997001360989", generic_name: "Vermox", labeler_name: "Gideon Richter", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "8699540091023", generic_name: "Megasef", labeler_name: "Nobel", dosage_form: "Capsule"))
//        result.append(Resul(product_ndc: "4820044930851", generic_name: "Celestoderm", labeler_name: "Berlin-chemi", dosage_form: "Gel"))
//        result.append(Resul(product_ndc: "4810201015095", generic_name: "Ibuclin", labeler_name: "Reddy", dosage_form: "Tablet"))
//        result.append(Resul(product_ndc: "4030855426348", generic_name: "Ambrohexal", labeler_name: "Sandoz", dosage_form: "Liquid"))
//        for item in result {
//            print(item)
//            print("Ok")
//            let newItem = DataForScan(context: viewContext)
//            newItem.generic_name = item.generic_name
//            newItem.product_ndc = item.product_ndc
//            newItem.dosage_form = item.dosage_form
//
//            do {
//                try viewContext.save()
//            } catch {
//                print("No")
//            }
//        }
//    }
