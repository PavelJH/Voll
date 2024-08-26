import Foundation

// Определение CustomList
struct CustomList: Identifiable, Codable {
    let id = UUID()
    var name: String
    var items: [ListItemModel]
    var creationDate: Date

    init(name: String, items: [ListItemModel], creationDate: Date = Date()) {
        self.name = name
        self.items = items
        self.creationDate = creationDate
    }
}

// Определение ListItemModel
struct ListItemModel: Identifiable, Codable {
    let id = UUID()
    var text: String
    var isCompleted: Bool = false
}

// Определение Note
struct Note: Identifiable, Codable {
    let id = UUID()
    var content: String
    var creationDate: Date
    var lastModifiedDate: Date

    init(content: String, creationDate: Date = Date(), lastModifiedDate: Date = Date()) {
        self.content = content
        self.creationDate = creationDate
        self.lastModifiedDate = lastModifiedDate
    }
}
