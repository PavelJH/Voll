import Foundation

struct Reminder: Identifiable, Codable {
    let id = UUID()
    var text: String
    var isCompleted: Bool
}
