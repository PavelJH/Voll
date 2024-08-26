import Foundation
import SwiftUI
import Combine

struct ExerciseEntry: Codable, Identifiable {
    let id: UUID
    var exercise: String
    var time: String
    var date: Date

    init(id: UUID = UUID(), exercise: String, time: String, date: Date) {
        self.id = id
        self.exercise = exercise
        self.time = time
        self.date = date
    }
}

class ExerciseData: ObservableObject {
    @Published var entries: [ExerciseEntry] {
        didSet {
            saveEntries()
        }
    }

    init() {
        self.entries = []
        loadEntries()
    }

    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "exerciseEntries")
        }
    }

    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "exerciseEntries"),
           let decoded = try? JSONDecoder().decode([ExerciseEntry].self, from: data) {
            self.entries = decoded
        } else {
            self.entries = []
        }
    }

    func addEntry(_ entry: ExerciseEntry) {
        entries.append(entry)
        saveEntries()
    }

    func removeEntry(_ entry: ExerciseEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries.remove(at: index)
            saveEntries()
        }
    }
}
