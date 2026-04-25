import SwiftUI

@main
struct EpubReaderApp: App {
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LibraryView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
