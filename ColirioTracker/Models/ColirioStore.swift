import Foundation
import SwiftUI

class ColirioStore: ObservableObject {
    @Published var usages: [ColirioUsage] = []
    
    private let saveKey = "colirioUsages"
    
    init() {
        loadUsages()
    }
    
    var todayUsageCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return usages.filter { calendar.isDate($0.date, inSameDayAs: today) }.count
    }
    
    var todayUsages: [ColirioUsage] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return usages.filter { calendar.isDate($0.date, inSameDayAs: today) }
            .sorted { $0.date > $1.date }
    }
    
    var recentUsages: [ColirioUsage] {
        return usages.sorted { $0.date > $1.date }.prefix(10).map { $0 }
    }
    
    func addUsage(notes: String = "") {
        let usage = ColirioUsage(notes: notes)
        usages.append(usage)
        saveUsages()
    }
    
    func deleteUsage(_ usage: ColirioUsage) {
        usages.removeAll { $0.id == usage.id }
        saveUsages()
    }
    
    private func saveUsages() {
        if let encoded = try? JSONEncoder().encode(usages) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadUsages() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([ColirioUsage].self, from: data) {
            usages = decoded
        }
    }
}
