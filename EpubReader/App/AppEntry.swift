import SwiftUI

@main
struct EpubReaderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ReaderView()
            }
        }
    }
}
