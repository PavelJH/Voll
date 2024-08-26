import SwiftUI

struct MonthYearPicker: View {
    @Binding var selectedDate: Date
    private let months = Calendar.current.monthSymbols
    private let years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(currentYear-5...currentYear+5)
    }()
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let components = Calendar.current.dateComponents([.month, .year], from: selectedDate.wrappedValue)
        self._selectedMonth = State(initialValue: components.month! - 1)
        self._selectedYear = State(initialValue: components.year!)
    }

    var body: some View {
        HStack {
            Picker("Month", selection: $selectedMonth) {
                ForEach(0..<months.count, id: \.self) { index in
                    Text(months[index]).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
            

            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text(String(format: "%d", year)).tag(year)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .onChange(of: selectedMonth) { newValue in
            updateDate()
        }
        .onChange(of: selectedYear) { newValue in
            updateDate()
        }
    }

    private func updateDate() {
        if let newDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth + 1)) {
            selectedDate = newDate
        }
    }
}

struct MonthYearPicker_Previews: PreviewProvider {
    static var previews: some View {
        MonthYearPicker(selectedDate: .constant(Date()))
    }
}
