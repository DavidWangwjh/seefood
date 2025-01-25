import SwiftUI

extension AnyTransition {
    static func moveAndFade(direction: CalendarView.SlideDirection) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: direction == .right ? .leading : .trailing),
            removal: .move(edge: direction == .right ? .trailing : .leading)
                .combined(with: .opacity)
        )
    }
}

struct CalendarView: View {
    @Binding var calendarItems: [Date: FoodAnalysisResult]
    @Binding var selectedDate: Date
    @State private var currentMonth: Date // For month navigation
    @State private var slideDirection: SlideDirection = .none // For animation
    
    // Enum for slide direction
    enum SlideDirection {
        case left, right, none
    }
    
    init(calendarItems: Binding<[Date: FoodAnalysisResult]>, selectedDate: Binding<Date>) {
        self._calendarItems = calendarItems
        self._selectedDate = selectedDate
        self._currentMonth = State(initialValue: selectedDate.wrappedValue)
    }

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    // Month-Year formatter
    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    // Weekday formatter
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    // Get weekday symbols
    private var weekdaySymbols: [String] {
        return calendar.shortWeekdaySymbols
    }

    private func generateDaysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        let monthStart = monthInterval.start
        
        // Calculate the weekday of the first day (1 = Sunday, 7 = Saturday)
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        
        // Calculate offset from Sunday (0 to 6)
        let offset = firstWeekday - 1
        
        var days: [Date] = []
        
        // Add dates from the previous month
        if offset > 0 {
            // Get the last date of the previous month
            guard let lastDayOfPrevMonth = calendar.date(byAdding: DateComponents(day: -1), to: monthStart) else { return [] }
            
            // Start from the last day and work backwards
            for day in (0..<offset).reversed() {
                if let previousDate = calendar.date(byAdding: DateComponents(day: -day), to: lastDayOfPrevMonth) {
                    days.append(previousDate)
                }
            }
        }
        
        // Add all days in the current month
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)!.count
        for day in 0..<daysInMonth {
            if let dayDate = calendar.date(byAdding: DateComponents(day: day), to: monthStart) {
                days.append(dayDate)
            }
        }
        
        // Calculate remaining days needed to complete the grid
        let totalCount = days.count
        let remainingDays = (totalCount <= 35) ? (35 - totalCount) : (42 - totalCount)
        
        // Add days from next month
        if remainingDays > 0 {
            // Get the first date of the next month
            guard let firstDayOfNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: monthStart) else { return days }
            
            // Add the required number of days
            for day in 0..<remainingDays {
                if let nextDate = calendar.date(byAdding: DateComponents(day: day), to: firstDayOfNextMonth) {
                    days.append(nextDate)
                }
            }
        }
        
        return days
    }

    var body: some View {
        VStack {
            // Month navigation header
            HStack {
                Button {
                    withAnimation() {
                        slideDirection = .right
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Label("Last Month", systemImage: "chevron.left")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                HStack {
                    Text(monthYearFormatter.string(from: currentMonth))
                        .font(.title2.bold())
                        .transition(.moveAndFade(direction: slideDirection))
                        .id("month-\(monthYearFormatter.string(from: currentMonth))")
                }
                .frame(width: 200)
                
                Spacer()
                
                Button {
                    withAnimation() {
                        slideDirection = .left
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Label("Next Month", systemImage: "chevron.right")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .frame(height: 50)
            
            // Weekday headers
            HStack {
                ForEach(weekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 40, height: 30)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 50)
            
            let days = generateDaysInMonth(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(40)), count: 7)) {
                ForEach(days, id: \.self) { date in
                    VStack(spacing: 4) {
                        Text(dateFormatter.string(from: date))
                            .font(.system(size: 16))
                            .frame(width: 32, height: 32)
                            .background(calendar.isDate(selectedDate, inSameDayAs: date) ? Color.blue.opacity(0.3) : Color.clear)
                            .foregroundColor(date.isInSameMonth(as: currentMonth) ? .primary : .gray.opacity(0.3))
                            .cornerRadius(8)
                            .onTapGesture {
                                if date.isInSameMonth(as: currentMonth) {
                                    selectedDate = date
                                }
                            }
                        if let foodItem = calendarItems[date], date.isInSameMonth(as: currentMonth) {
                            Text("Food: \(foodItem.title)")
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: 36)
                        }
                    }
                    .frame(height: 55)
                }
            }
            .transition(.moveAndFade(direction: slideDirection))
            .id("calendar-\(monthYearFormatter.string(from: currentMonth))")
        }
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    // Check the horizontal component of the gesture
                    let horizontalTranslation = value.translation.width
                    
                    if horizontalTranslation < 0 {
                        // User swiped left: go to next month
                        withAnimation {
                            slideDirection = .left
                            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                        }
                    } else if horizontalTranslation > 0 {
                        // User swiped right: go to previous month
                        withAnimation {
                            slideDirection = .right
                            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                        }
                    }
                }
        )
    }
}

// Helper extension to check if a date is in the current month
extension Date {
    func isInSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }
}

#Preview {
    CalendarView(calendarItems: .constant([:]), selectedDate: .constant(Date()))
}
