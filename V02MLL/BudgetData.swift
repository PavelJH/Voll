import Foundation

struct MonthlyBudget: Identifiable, Codable {
    let id = UUID()
    var month: Int
    var year: Int
    var budget: Double
    var expenses: [Expense] = []
}

class BudgetData: ObservableObject {
    @Published var budgets: [MonthlyBudget]

    init() {
        if let loadedBudgets = BudgetData.loadBudgets() {
            self.budgets = loadedBudgets
        } else {
            self.budgets = []
        }
    }

    func addBudget(_ budget: MonthlyBudget) {
        if let index = budgets.firstIndex(where: { $0.month == budget.month && $0.year == budget.year }) {
            budgets[index] = budget
        } else {
            budgets.append(budget)
        }
        saveBudgets()
    }

    func saveBudgets() {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: "budgets")
        }
    }

    static func loadBudgets() -> [MonthlyBudget]? {
        if let data = UserDefaults.standard.data(forKey: "budgets"),
           let decoded = try? JSONDecoder().decode([MonthlyBudget].self, from: data) {
            return decoded
        }
        return nil
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }
}
