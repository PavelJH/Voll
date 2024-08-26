import SwiftUI

struct MoneyView: View {
    @StateObject private var budgetData = BudgetData()
    @State private var selectedDate = Date()
    @State private var budgetText: String = ""
    @State private var budget: Double = 0.0
    @State private var expenses: [Expense] = []
    @State private var totalAcceptedExpenses: Double = 0.0
    @State private var textSize: CGFloat = 20.0 // Установите нужный размер текста здесь

    var body: some View {
        VStack {
            HStack {
                MonthYearPicker(selectedDate: $selectedDate)
                    .onChange(of: selectedDate) { newDate in
                        loadBudget()
                    }
                    .frame(width: 180)

                Spacer()

                TextField("Enter Budget", text: $budgetText, onEditingChanged: { isEditing in
                    if isEditing {
                        if budgetText == "0,00" {
                            budgetText = ""
                        }
                    } else {
                        budget = Double(budgetText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                        saveBudget()
                    }
                })
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                .frame(width: 150)
                .padding(.trailing, 10)
            }
            .padding()

            Text("Theme | Money | Accept")
                .font(.headline)
                .padding(.leading, 20)

            List {
                ForEach($expenses) { $expense in
                    ExpenseRow(expense: $expense, onValueChanged: {
                        totalAcceptedExpenses = calculateTotalAcceptedExpenses()
                        saveBudget()
                    })
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteExpense(at: IndexSet(integer: expenses.firstIndex(where: { $0.id == expense.id })!))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onMove(perform: moveExpense)
            }
            .listStyle(InsetListStyle())
            .frame(maxWidth: .infinity)
            .cornerRadius(20)

            Button(action: {
                addExpense()
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Add Expense")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            Spacer()

            Text("Remaining Budget: \(formattedRemainingBudget())")
                .font(.system(size: textSize))
                .padding()
        }
        .onAppear(perform: loadBudget)
        .hideKeyboardOnTap()
    }

    private func loadBudget() {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)

        if let budget = budgetData.budgets.first(where: { $0.month == month && $0.year == year }) {
            self.budget = budget.budget
            self.budgetText = String(format: "%.2f", budget.budget).replacingOccurrences(of: ".", with: ",")
            self.expenses = budget.expenses
            self.totalAcceptedExpenses = calculateTotalAcceptedExpenses()
        } else {
            self.budget = 0.0
            self.budgetText = "0,00"
            self.expenses = standardExpenses()
            self.totalAcceptedExpenses = 0.0
        }
    }

    private func saveBudget() {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)

        let budget = MonthlyBudget(month: month, year: year, budget: self.budget, expenses: self.expenses)
        budgetData.addBudget(budget)
    }

    private func addExpense() {
        expenses.append(Expense(theme: "", amount: 0.0, colorIndex: 0))
        saveBudget()
    }

    private func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        totalAcceptedExpenses = calculateTotalAcceptedExpenses()
        saveBudget()
    }

    private func moveExpense(from source: IndexSet, to destination: Int) {
        expenses.move(fromOffsets: source, toOffset: destination)
        saveBudget()
    }

    private func calculateTotalAcceptedExpenses() -> Double {
        return expenses.filter { $0.isAccepted }.reduce(0) { $0 + $1.amount }
    }

    private func calculateRemainingBudget() -> Double {
        let totalYellowAcceptedExpenses = expenses.filter { $0.isAccepted && $0.colorIndex == 2 && !$0.theme.isEmpty && $0.amount > 0 }.reduce(0) { $0 + $1.amount }
        let totalOtherAcceptedExpenses = expenses.filter { $0.isAccepted && $0.colorIndex != 2 && !$0.theme.isEmpty && $0.amount > 0 }.reduce(0) { $0 + $1.amount }
        return budget + totalYellowAcceptedExpenses - totalOtherAcceptedExpenses
    }

    private func formattedRemainingBudget() -> String {
        let remainingBudget = calculateRemainingBudget()
        return String(format: "%.2f", remainingBudget).replacingOccurrences(of: ".", with: ",")
    }

    private func standardExpenses() -> [Expense] {
        return [
            Expense(theme: "Apartment", amount: 378.66),
            Expense(theme: "Food_01", amount: 60.0),
            Expense(theme: "Food_02", amount: 60.0),
            Expense(theme: "Food_03", amount: 60.0),
            Expense(theme: "Food_04", amount: 60.0),
            Expense(theme: "Food_05", amount: 60.0),
            Expense(theme: "Hookah", amount: 300.0),
            Expense(theme: "GymX", amount: 24.0),
            Expense(theme: "Vodafone WiFI", amount: 39.99),
            Expense(theme: "Vodafone Phone", amount: 25.49),
            Expense(theme: "Bank/Account", amount: 4.95),
            Expense(theme: "Disney", amount: 8.99),
            Expense(theme: "Netflix", amount: 13.99),
            Expense(theme: "iCloud", amount: 2.99),
            Expense(theme: "Dental Insurance", amount: 31.23),
            Expense(theme: "BVG", amount: 49.0),
            Expense(theme: "Apple Insurance 13", amount: 11.49),
            Expense(theme: "Apple Insurance 15 pro", amount: 14.99),
            Expense(theme: "Asus", amount: 112.42),
            Expense(theme: "Bed", amount: 50.0),
            Expense(theme: "Wedding", amount: 123.34),
            Expense(theme: "Work Food_01", amount: 10.0),
            Expense(theme: "Work Food_02", amount: 10.0),
            Expense(theme: "Work Food_03", amount: 10.0),
            Expense(theme: "Work Food_04", amount: 10.0),
            Expense(theme: "Work Food_05", amount: 10.0),
            Expense(theme: "Work Food_06", amount: 10.0),
            Expense(theme: "Work Food_07", amount: 10.0),
            Expense(theme: "Work Food_08", amount: 10.0),
        ]
    }
}

struct ExpenseRow: View {
    @Binding var expense: Expense
    var onValueChanged: () -> Void

    @FocusState private var isMoneyFieldFocused: Bool
    @State private var amountText: String = ""
    
    let colors: [Color] = [.red, .gray, .yellow, .green]

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(colors[expense.colorIndex])
                .frame(width: 20, height: 20)
                .padding(.leading, 2)
                .onTapGesture {
                    expense.colorIndex = (expense.colorIndex + 1) % colors.count
                    onValueChanged()
                }

            TextField("Theme", text: $expense.theme)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
                .padding(.leading, 10)
                .onChange(of: expense.theme) { _ in
                    onValueChanged()
                }

            Spacer()

            TextField("Money", text: $amountText, onEditingChanged: { isEditing in
                if isEditing {
                    if amountText == "0,00" {
                        amountText = ""
                    }
                } else {
                    expense.amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                    onValueChanged()
                }
            })
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 80)
            .padding(.leading, 5)
            .focused($isMoneyFieldFocused)
            .onAppear {
                if expense.amount == 0.0 {
                    amountText = ""
                } else {
                    amountText = String(format: "%.2f", expense.amount).replacingOccurrences(of: ".", with: ",")
                }
            }

            Spacer()

            Button(action: {
                expense.isAccepted.toggle()
                onValueChanged()
            }) {
                Image(systemName: expense.isAccepted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(expense.isAccepted ? .green : .gray)
                    .padding(.leading, 10)
            }
        }
        .padding([.leading, .trailing])
    }
}

struct Expense: Identifiable, Codable {
    let id: UUID
    var theme: String
    var amount: Double
    var date: Date
    var isAccepted: Bool
    var colorIndex: Int

    enum CodingKeys: CodingKey {
        case id, theme, amount, date, isAccepted, colorIndex
    }

    init(id: UUID = UUID(), theme: String, amount: Double, date: Date = Date(), isAccepted: Bool = false, colorIndex: Int = 0) {
        self.id = id
        self.theme = theme
        self.amount = amount
        self.date = date
        self.isAccepted = isAccepted
        self.colorIndex = colorIndex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        theme = try container.decode(String.self, forKey: .theme)
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
        isAccepted = try container.decode(Bool.self, forKey: .isAccepted)
        colorIndex = try container.decode(Int.self, forKey: .colorIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(theme, forKey: .theme)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(isAccepted, forKey: .isAccepted)
        try container.encode(colorIndex, forKey: .colorIndex)
    }
}

struct MoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyView()
    }
}
