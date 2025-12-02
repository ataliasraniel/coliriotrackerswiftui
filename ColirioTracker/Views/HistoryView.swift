import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var colirioStore: ColirioStore
    @Environment(\.dismiss) var dismiss
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
    
    private var groupedUsages: [(String, [ColirioUsage])] {
        let formatter = Self.dateFormatter
        let grouped = Dictionary(grouping: colirioStore.usages) { usage -> String in
            formatter.string(from: usage.date)
        }
        
        return grouped.sorted { first, second in
            guard let firstDate = colirioStore.usages.first(where: { 
                formatter.string(from: $0.date) == first.key 
            })?.date,
            let secondDate = colirioStore.usages.first(where: { 
                formatter.string(from: $0.date) == second.key 
            })?.date else {
                return false
            }
            return firstDate > secondDate
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Histórico de Uso")
                    .font(.headline)
                Spacer()
                Button("Fechar") {
                    dismiss()
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
            
            if colirioStore.usages.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "drop")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Nenhum registro ainda")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(groupedUsages, id: \.0) { dateString, usages in
                        Section(header: Text(dateString)) {
                            ForEach(usages.sorted { $0.date > $1.date }) { usage in
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    
                                    Text(usage.date, style: .time)
                                    
                                    if !usage.notes.isEmpty {
                                        Text("- \(usage.notes)")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        colirioStore.deleteUsage(usage)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 350, height: 400)
    }
}

#Preview {
    HistoryView()
        .environmentObject(ColirioStore())
}
