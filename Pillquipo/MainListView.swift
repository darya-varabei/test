//
//  MainListView.swift
//  test_ui
//
//  Created by Дарья Воробей on 3/7/21.
//

import SwiftUI

struct MainListView: View {
    
    @State var results = [Results]()
    @State var countPositions = 2
    
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            if countPositions == 0
            {
                EmptyListView()
                    .padding(.top, 100)
            }
            else{
                ListView()
                    .padding(.top, 180)
            }
            VStack(){
                ZStack{
                    Rectangle()
                        .frame(width: 375, height: 180)
                        .foregroundColor(Color(ColorsSaved.almostWhite))
                        .background(Color(ColorsSaved.almostWhite))
                        .edgesIgnoringSafeArea(.all)
                        .shadow(radius: 10)
                    
                    CalendarView(selectedDate: dates[0])
                        .padding(.horizontal, 25)
                }
            }.padding(.bottom, 430)
        }.onAppear(perform: {
            loadData()
            countPositions = results.count
        })
        .animation(.easeInOut)
    }
    func loadData (){
        
        guard let url = URL(string: "https://api.fda.gov/drug/ndc.json?limit=1000")
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
                    self.countPositions = self.results.count
                    return
                }
            }
            print("Fetch failed")
        }.resume()
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
