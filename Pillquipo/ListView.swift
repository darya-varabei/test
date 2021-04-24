//
//  ListView.swift
//  test_ui
//
//  Created by Дарья Воробей on 3/8/21.
//

import SwiftUI
import Foundation

struct Response: Codable{
    var results: [Results]
}

struct Results: Codable {
    var userId: String
    var product_ndc: String
    var generic_name: String
    var labeler_name: String
    var start_date: Date
    var finish_date: Date
    var doze: String
    var type: String
    var time: Date
    var state: Bool
    var daysOn: Int
    var daysOff: Int
}

struct ListElement: View{
    
    var medication: Results
    @State var trimVal: CGFloat = 0
    @State var checked: Bool = false
    
    var body: some View{
        Color(ColorsSaved.customBlue).opacity(0.0)
            .edgesIgnoringSafeArea(.all)
        ZStack(){
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 319, height: 100, alignment: .center)
                .foregroundColor(Color(ColorsSaved.almostWhite))
            
            HStack(spacing: 20){
                
                CheckBoxView(checkState: medication.state)
                
                VStack(alignment: .leading, spacing: 7){
                    Text(medication.generic_name)
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                    Text(medication.doze)
                        .font(Font.custom("Karla-Bold", size: 12))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                    Text("\(medication.time)")
                        .padding(.top, 13)
                        .font(Font.custom("Karla-Bold", size: 16))
                        .foregroundColor(Color(ColorsSaved.textBlue))
                }.padding(.leading, 23)
                
                VStack(spacing: 30){
                    Button(action:{
                        
                    }){
                        Text("Update")
                            .font(Font.custom("Karla-Bold", size: 12))
                            .foregroundColor(Color(ColorsSaved.textBlue))
                    }
                    Button(action:{
                        
                    }){
                        Text("Delete")
                            .font(Font.custom("Karla-Regular", size: 12))
                            .foregroundColor(Color(ColorsSaved.textBlue))
                    }
                }.padding(.leading, 30)
            }
        }
    }
}

struct ListView: View {
    
    let now = Date()
    @State var results = [Results]()
    @StateObject var model = ModelData()
    
    var body: some View {
        ZStack{
            Color(ColorsSaved.clear).opacity(0)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    ForEach(results, id: \.product_ndc) { item in
                        if item.userId == "wrfhiuh"{
                            ListElement(medication: item)
                        }
                    }
                }
            }
        }
        
    }
    func loadData (){
        
        guard let url = URL(string: "http://localhost:8080/api/medication")
        else{
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed")
        }.resume()
    }
}

struct CheckBoxView: View {
    
    @State var checkState: Bool
    
    var body: some View {
        Button(action:
                {
                    self.checkState = !self.checkState
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
                        Image(systemName: self.checkState ? "checkmark": "checkmark")
                    }
                )
        }
        .foregroundColor(Color.white)
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
