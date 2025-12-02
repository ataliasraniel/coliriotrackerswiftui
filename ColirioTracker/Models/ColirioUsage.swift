import Foundation

struct ColirioUsage: Identifiable, Codable {
    let id: UUID
    let date: Date
    let notes: String
    
    init(id: UUID = UUID(), date: Date = Date(), notes: String = "") {
        self.id = id
        self.date = date
        self.notes = notes
    }
}
