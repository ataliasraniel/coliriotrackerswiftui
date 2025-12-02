import SwiftUI

struct ContentView: View {
    @EnvironmentObject var colirioStore: ColirioStore
    @State private var notes: String = ""
    @State private var showingHistory: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "drop.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("Colirio Tracker")
                    .font(.headline)
            }
            .padding(.top, 8)
            
            Divider()
            
            // Today's summary
            VStack(spacing: 8) {
                Text("Hoje")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(colirioStore.todayUsageCount)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                
                Text(colirioStore.todayUsageCount == 1 ? "aplicação" : "aplicações")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Quick add button
            Button(action: {
                colirioStore.addUsage(notes: notes)
                notes = ""
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar Uso")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            
            // Optional notes field
            TextField("Notas (opcional)", text: $notes)
                .textFieldStyle(.roundedBorder)
            
            Divider()
            
            // Today's history
            if !colirioStore.todayUsages.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Aplicações de Hoje")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(colirioStore.todayUsages) { usage in
                                UsageRowView(usage: usage)
                            }
                        }
                    }
                    .frame(maxHeight: 120)
                }
            }
            
            Divider()
            
            // Footer buttons
            HStack {
                Button("Histórico") {
                    showingHistory.toggle()
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
                Button("Encerrar") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        .frame(width: 280)
        .sheet(isPresented: $showingHistory) {
            HistoryView()
                .environmentObject(colirioStore)
        }
    }
}

struct UsageRowView: View {
    let usage: ColirioUsage
    
    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundColor(.blue)
                .font(.caption)
            
            Text(usage.date, style: .time)
                .font(.caption)
            
            if !usage.notes.isEmpty {
                Text("- \(usage.notes)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(ColirioStore())
}
