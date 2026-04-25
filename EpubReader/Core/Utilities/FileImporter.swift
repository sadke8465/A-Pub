import Foundation
import UIKit
import UniformTypeIdentifiers
import ObjectiveC

/// Presents the iOS Files picker for `.epub` documents and returns parsed book data.
@MainActor
public struct FileImporter {

    public init() {}

    public func importEPUB() async throws -> (EPUBBook, String) {
        let pickedURL = try await pickEPUBURL()
        let gotSecurityScope = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if gotSecurityScope {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }

        let extractor = EPUBExtractor()
        let parser = EPUBParser()
        let extractedRoot = try await extractor.extract(pickedURL)
        let book = try await parser.parse(extractedRoot: extractedRoot)
        let base64String = try await Self.encodeBase64(from: pickedURL)
        return (book, base64String)
    }


    nonisolated private static func encodeBase64(from url: URL) async throws -> String {
        try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: url)
            return data.base64EncodedString()
        }.value
    }

    private func pickEPUBURL() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.epub], asCopy: true)
            picker.allowsMultipleSelection = false

            let coordinator = DocumentPickerCoordinator { result in
                continuation.resume(with: result)
            }

            picker.delegate = coordinator
            objc_setAssociatedObject(
                picker,
                &AssociatedKeys.coordinator,
                coordinator,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )

            guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let presenter = scene.keyWindow?.rootViewController?.topMostViewController
            else {
                continuation.resume(throwing: FileImporterError.presentationUnavailable)
                return
            }

            presenter.present(picker, animated: true)
        }
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
}

private extension UIViewController {
    var topMostViewController: UIViewController {
        if let presentedViewController {
            return presentedViewController.topMostViewController
        }

        if let navigationController = self as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topMostViewController
        }

        if let tabBarController = self as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topMostViewController
        }

        return self
    }
}

private enum FileImporterError: Error {
    case presentationUnavailable
    case noSelection
}

private enum AssociatedKeys {
    static var coordinator = "file_importer_document_picker_coordinator"
}

private final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    private let completion: (Result<URL, Error>) -> Void

    init(completion: @escaping (Result<URL, Error>) -> Void) {
        self.completion = completion
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let firstURL = urls.first else {
            completion(.failure(FileImporterError.noSelection))
            return
        }
        completion(.success(firstURL))
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion(.failure(CancellationError()))
    }
}
