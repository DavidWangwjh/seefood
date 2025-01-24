import SwiftUI

struct CalendarView: View {
    @Binding var calendarItems: [Date: FoodAnalysisResult]
    @Binding var selectedDate: Date

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    var body: some View {
        VStack {
            Text("Calendar")
                .font(.headline)

            let days = generateDaysInMonth(for: selectedDate)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { date in
                    VStack {
                        Text(dateFormatter.string(from: date))
                            .padding()
                            .background(calendar.isDate(selectedDate, inSameDayAs: date) ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedDate = date
                            }
                        if let foodItem = calendarItems[date] {
                            Text("Food: \(foodItem.title)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()

            if let foodItem = calendarItems[selectedDate] {
                Text("Food for \(selectedDate, formatter: dateFormatter): \(foodItem.title)")
                    .padding()
            }
        }
    }

    private func generateDaysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        let monthStart = monthInterval.start

        var days: [Date] = []
        for day in 0..<calendar.range(of: .day, in: .month, for: monthStart)!.count {
            if let dayDate = calendar.date(byAdding: .day, value: day, to: monthStart) {
                days.append(dayDate)
            }
        }
        return days
    }
} 