import SwiftUI

struct SportView: View {
    @StateObject private var exerciseData = ExerciseData()
    @State private var selectedDate = Date()
    @State private var editMode: EditMode = .inactive // Добавлена переменная editMode
    
    // Параметры настройки размеров строк, полей ввода и текста
    private let rowHeight: CGFloat = 50.0 // Высота строки
    private let rowPadding: CGFloat = 10.0 // Отступы строки
    private let textFieldWidth: CGFloat = 100.0 // Ширина TextField
    private let textSize: CGFloat = 16.0 // Размер текста

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                MonthYearPicker(selectedDate: $selectedDate)
                    .onChange(of: selectedDate) { _, _ in
                        // Перезагружаем данные на основе выбранного месяца и года
                        exerciseData.entries = loadExerciseEntries(for: selectedDate)
                    }.frame(width: 180)

                Spacer()
            }
            .padding()

            HStack {
                Text("Date")
                Spacer()
                Text("Exercise")
                Spacer()
                Text("Time")
            }
            .font(.headline)
            .padding([.leading, .trailing, .top])

            List {
                ForEach($exerciseData.entries) { $entry in
                    HStack {
                        DatePicker("", selection: $entry.date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()

                        Spacer()

                        ExercisePicker(exerciseEntry: $entry, exerciseData: exerciseData)
                            .frame(minWidth: 20, maxHeight: 35) // Минимальная и максимальная ширина
                        .frame(minWidth: 130)
                        .cornerRadius(10) // Закругленные углы
                        
                        
                        Spacer()
                            .listStyle(InsetListStyle())
                            .frame(minWidth: 10)
                            .cornerRadius(10) // Закругленные углы

                        TextField("Minutes", text: $entry.time)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: textFieldWidth) // Установка ширины TextField
                            .font(.system(size: textSize)) // Установка размера текста
                            .shadow(radius: 5)
                    }
                    .padding([.leading, .trailing], rowPadding) // Установка отступов
                    .frame(height: rowHeight) // Установка высоты строки
                    .swipeActions {
                        Button(role: .destructive) {
                            delete(at: IndexSet(integer: exerciseData.entries.firstIndex(where: { $0.id == entry.id })!))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode) // Режим редактирования
            .listStyle(InsetListStyle()) // Стиль списка
            .frame(maxWidth: .infinity) // Максимальная ширина списка
            .cornerRadius(20) // Закругленные углы

            Button(action: {
                let newEntry = ExerciseEntry(exercise: "Other", time: "", date: Date())
                exerciseData.addEntry(newEntry)
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
            }

            Text("Total Dates: \(calculateTotalDates())")
                .padding([.leading, .trailing, .top])

            VStack(alignment: .leading) {
                ForEach(groupedEntriesByDate(), id: \.key) { date, totalTime in
                    Text("\(formattedDate(date)): \(totalTime) min")
                        .padding([.leading, .trailing])
                }
            }
            .padding([.top, .bottom])

            Spacer()
        }
        .navigationTitle("Sport")
        .hideKeyboardOnTap()
        .onAppear {
            exerciseData.entries = loadExerciseEntries(for: selectedDate)
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let entry = exerciseData.entries[index]
            exerciseData.removeEntry(entry)
        }
    }

    func groupedEntriesByDate() -> [(key: Date, value: Int)] {
        let groupedEntries = Dictionary(grouping: exerciseData.entries, by: { Calendar.current.startOfDay(for: $0.date) })
        let totalTimeByDate = groupedEntries.mapValues { entries in
            entries.reduce(0) { $0 + (Int($1.time) ?? 0) }
        }
        return totalTimeByDate.sorted { $0.key < $1.key }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func calculateTotalDates() -> Int {
        let uniqueDates = Set(exerciseData.entries.map { Calendar.current.startOfDay(for: $0.date) })
        return uniqueDates.count
    }

    func loadExerciseEntries(for date: Date) -> [ExerciseEntry] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return exerciseData.entries.filter {
            let entryMonth = calendar.component(.month, from: $0.date)
            let entryYear = calendar.component(.year, from: $0.date)
            return entryMonth == month && entryYear == year
        }
    }
}

struct SportView_Previews: PreviewProvider {
    static var previews: some View {
        SportView()
    }
}
