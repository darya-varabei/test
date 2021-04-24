//
//  CalendarView.swift
//  Care-time
//
//  Created by Дарья Воробей on 3/18/21.
//

import SwiftUI

let dates: [Date] = {
    (0...365).map { offset in
        Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
    }
}()

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = format

    return dateFormatterGet.string(from: date)
}

struct CalendarView: View {
    @State var selectedDate: Date

    var body: some View {
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
        }
    }
}

struct DayView: View {
    var date: Date
    let length: CGFloat = 81
    let width: CGFloat = 45

    @Binding var selectedDate: Date

    var isSelected: Bool { selectedDate == date }

    var body: some View {
        VStack(spacing: 3) {
            Text(dayName)
                .font(Font.custom("Karla-Bold", size: 14)).foregroundColor(isSelected ? Color(ColorsSaved.almostWhite) : Color(ColorsSaved.textTorquise))
                .padding(.top, 5)
            ZStack{
                
                Circle()
                    .frame(width: 33, height: 33)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
            Text(dayNumber)
                .font(Font.custom("Karla-Bold", size: 14))
            }
        }
        .frame(width: width, height: length)
        .background(isSelected ? Color(ColorsSaved.gradientBlue) : Color(ColorsSaved.almostWhite))
        .cornerRadius(22.5)
        .onTapGesture { self.selectedDate = self.date }
    }

    var dayName: String { return formatDate(date, format: "EE") }
    var dayNumber: String { return formatDate(date, format: "d") }
}

struct SelectedDayView: View {
    @Binding var selectedDate: Date

    var body: some View {
        Text(dayName)
            .font(Font.custom("Karla-Bold", size: 14))
    }

    var dayName: String {
            return formatDate(selectedDate, format: "EE, MMM dd")
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: dates[0])
    }
}
