import SwiftUI

@main
struct ColirioTrackerApp: App {
    @StateObject private var colirioStore = ColirioStore()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(colirioStore)
        } label: {
            Image(systemName: "drop.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
