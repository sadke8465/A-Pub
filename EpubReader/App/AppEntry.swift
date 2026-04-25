import SwiftUI

@main
struct EpubReaderApp: App {
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ReaderView()
            }
            .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
