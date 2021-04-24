//
//  AddPillView.swift
//  Care-time
//
//  Created by Дарья Воробей on 3/19/21.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct Responses: Codable{
    var results: [Resul]
}

struct Resul: Codable, Hashable {
    var product_ndc: String
    var generic_name: String
    var labeler_name: String
    var dosage_form: String
}

struct AddPillView: View {
    
    @State var index = 0
     @State var result = MedicationModel()
    @State private var isShowingScanner = false
    @State var text = ""
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
                    .sheet(isPresented: $isShowingScanner){
                        CodeScannerView(codeTypes: [.ean13], completion: self.handleScan)
                    }
                    
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
                    addCustomPill(name: result.generic_name, dosage: result.dosage_form)
                    
                } else if self.index == 1 {
                    addByScanner()
                }
                else {
                    addBySearch(text: text)
                }
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let medication = MedicationModel()
            medication.generic_name = details[0]
            medication.dosage_form = details[1]
        case .failure(let error):
            print("Scanning failed")
        }
    }
}

struct addCustomPill: View{
    
    @State var selected = 0
    @StateObject var medication = MedicationModel()
    @StateObject var model = ModelData()
    @State var name: String
    
    @State var dosage: String
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var index = 0
    @State var doze = 1
    var types: [String] = ["Capsule", "Tablet", "Injection", "Gel", "Concentrate", "Liquid", "Aerosol", "Cream", "Spray", "Suspension", "Other"]
    @State var selection: String = "Capsule"
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(ColorsSaved.almostWhite))
                .frame(width: 360, height: 480, alignment: .center)
            VStack(alignment: .leading){
                Text("Add new medicine")
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
                    TextField("Enter doze...", text: $medication.doze)
                        .frame(width: 100, height: 20)
                        .padding(.all, 10)
                        .foregroundColor(Color(ColorsSaved.textBlue))
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                    
                    HStack(spacing: 0){
                        Picker(medication.dosage_form, selection: $medication.dosage_form) {
                        ForEach(types, id: \.self) { word in
                            Text(word)
                                .underline()
                                .tag(word)
                        }
                    }.foregroundColor(Color(ColorsSaved.textBlue))
                    .frame(width: 65)
                    .pickerStyle(MenuPickerStyle())
                        Image(systemName:"chevron.down")
                    }
                }.padding(.horizontal, 15)
                .padding(.bottom, 10)
                
                //                    HStack(){
                //                        Button(action: {
                //                            withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                //                                self.index=0
                //                            }
                //                        }){
                //                            Text("Period")
                //                                .font(Font.custom("Karla-Bold", size: 12))
                //                                .padding(.vertical, 10)
                //                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                //                                .foregroundColor(self.index == 0 ? .white: Color(ColorsSaved.textBlue))
                //                        }.background(self.index == 0 ? Color(ColorsSaved.gradientBlue): Color.clear)
                //                        .clipShape(Capsule())
                //
                //                        Button(action: {
                //                            withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                //                                self.index=1
                //                            }
                //                        }){
                //                            Text("Intervals")
                //                                .font(Font.custom("Karla-Bold", size: 12))
                //                                .padding(.vertical, 10)
                //                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                //                                .foregroundColor(self.index == 1 ? .white: Color(ColorsSaved.textBlue))
                //                        }.background(self.index == 1 ? Color(ColorsSaved.gradientBlue): Color.clear)
                //                        .clipShape(Capsule())
                //
                //                    }.background(Color(ColorsSaved.almostWhite))
                //                    .clipShape(Capsule())
                //                    .padding(.bottom, 20)
                //                    .padding(.horizontal, 30)
                
                DatePicker("Choose start date",selection: $medication.start_date, displayedComponents: .date)
                    .foregroundColor(Color(ColorsSaved.textBlue))
                    .padding(.horizontal, 20)
                DatePicker("Choose finish date",selection: $medication.finish_date, displayedComponents: .date)
                    .foregroundColor(Color(ColorsSaved.textBlue))
                    .padding(.horizontal, 20)
                DatePicker("Choose time",selection: $medication.time, displayedComponents: .hourAndMinute)
                    .foregroundColor(Color(ColorsSaved.textBlue))
                    .padding(.horizontal, 20)
                NavigationLink(destination: MainListView()) {
                Button(action: {
                    medication.userId = model.email
                    medication.generic_name = name
                    medication.postMethod()
                }){
                    Text("Add")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 200)
                }.background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(14)
                .offset(y: 30)
                .padding(.leading, 100)
                .shadow(radius: 15)
                }
            }.padding(.bottom, 40)
        }.padding(.horizontal, 20)
        .cornerRadius(25)
            
    }
}


struct addByScanner: View{
    
    @State var isPresentingScanner = false
    @State var scannedCode: String?
    @State private var isShowingScanner = false
    @State var medication = MedicationModel()
    @State var result = [Resul]()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if self.scannedCode != nil {
                    Text(scannedCode ?? "0000")
                }
                Button("Scan Code") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
                Text("Scan a barcode code to begin")
            }
        }
            
    }
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr, .ean13, .code128],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code
                    self.isPresentingScanner = false
                }
            }
        )
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let medication = MedicationModel()
            medication.generic_name = details[0]
            medication.dosage_form = details[1]
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    
    func loadData(){
        guard let url = URL(string: "https://api.fda.gov/other/nsde.json?search=package_ndc:\(String(describing: scannedCode))")
        else{
            print("Invalid URL")
            return
        }
        print(url)
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
                .frame(width: 360, height: 480, alignment: .center)
            
            VStack{
                NavigationView {
                    List{
                        SearchBar(searchText: $searchText, isSearching: $isSearching)
                            .frame(alignment: .center)
                        
                        List((result).filter({ "\($0)".contains(searchText) || searchText.isEmpty }), id: \.self) { item in
                            
                            VStack(alignment: .leading){
                                NavigationLink(destination: addCustomPill(name: item.generic_name, dosage: item.dosage_form)) {
                                    Text("\(item.generic_name), \(item.labeler_name)")
                                }
                                .foregroundColor(Color(ColorsSaved.textBlue))
                            }
                        }.frame(width: 330, height: 470)
                    } .navigationBarHidden(true)
                    
                } .navigationBarTitle("")
                .navigationBarHidden(false)
            }.onAppear(perform: loadData)
            .padding(.top, 5)
            .cornerRadius(25)
            .frame(width: 350, height: 475, alignment: .center).foregroundColor(Color(ColorsSaved.almostWhite))
        }
    }
    func loadData(){
        guard let url = URL(string: "https://api.fda.gov/drug/ndc.json?limit=1000")
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
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                        .padding(.leading, 0)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
        }
    }
}


struct AddPillView_Previews: PreviewProvider {
    static var previews: some View {
        AddPillView()
    }
}
