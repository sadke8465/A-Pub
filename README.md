# A-Pub

[![Platform](https://img.shields.io/badge/platform-iOS%2017%2B%20%7C%20macOS%2014%2B-blue)](#prerequisites)
[![Language](https://img.shields.io/badge/language-Swift%205.9%2B-orange)](#tech-stack)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

A-Pub is a native-first EPUB reading application built for Apple platforms. It combines a SwiftUI-driven experience with a WebKit-powered EPUB renderer to deliver a clean, fast, and reliable reading workflow.

---

## Introduction

A-Pub is designed as an Apple-quality alternative to web-first readers, with an emphasis on:

- Native performance and smooth UI interactions
- Clean library management
- Reliable EPUB rendering using `epub.js` inside a `WKWebView`
- Offline-friendly local reading experience

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** Core Data
- **Rendering Engine:** WebKit + epub.js
- **Project Format:** Xcode project (`.xcodeproj`)

---

## Getting Started

Follow this guide to run A-Pub locally in development.

### Prerequisites

Install the following before setup:

- **macOS** 14+ (recommended)
- **Xcode** 15+
- **Swift** 5.9+ (bundled with Xcode)
- **Git**

> Note: Because this is a native Apple app, there is no Node/Python runtime requirement for core development.

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/<your-org-or-user>/A-Pub.git
   cd A-Pub
   ```

2. **Open the project in Xcode**

   ```bash
   open EpubReader.xcodeproj
   ```

3. **Resolve dependencies (if prompted by Xcode)**

   The project is currently configured to run with bundled resources; Xcode will handle project indexing/build configuration.

### Environment Variables

A-Pub does **not** require runtime environment variables by default.

If you add API-backed features, create a `.env` file (or Xcode build settings equivalents) with keys such as:

```env
API_KEY=your_api_key_here
DATABASE_URL=your_database_url_here
```

Recommended: keep secrets out of source control and use an untracked local config file.

### Running the App

#### Option A: Run from Xcode (recommended)

1. Open `EpubReader.xcodeproj`
2. Select the `EpubReader` scheme
3. Choose an iOS Simulator or macOS target
4. Press **Run** (`⌘R`)

#### Option B: Build from command line

```bash
xcodebuild -project EpubReader.xcodeproj -scheme EpubReader -destination 'platform=iOS Simulator,name=iPhone 15' build
```

---

## Usage

After launching the app:

1. Open the library view
2. Import or load EPUB content
3. Select a book to start reading
4. Use in-reader controls for navigation and reading progress


## Development Roadmap Status

The project follows a staged execution plan tracked in `refrence_files/master-plan.md`.

### Current Stage (as of April 25, 2026)

- **Last completed task:** `1.9`
- **Next task:** `2a.1`
- **Completed tasks:** `19 / 93` (**~20.4% complete**)
- **Current phase:** Transition from foundational Phase 1 work into the `2a.*` implementation track.
- **Gate progress:** No release gates passed yet (`GATES_PASSED = []`).

### Planned Release Gates

- **Gate 1 — TestFlight Alpha:** requires `3b.6`
- **Gate 2 — TestFlight Beta:** requires `6c.5`
- **Gate 3 — App Store v1:** requires `7b.6`
- **Gate 4 — v1.1:** requires `8.8`

### How to Update This Status

When plan progress changes, update this section to mirror the latest values in `refrence_files/master-plan.md`:

- `LAST_COMPLETED`
- `NEXT_TASK`
- `TASKS_DONE` / `TASKS_TOTAL`
- `GATES_PASSED`

## Project Structure

```text
EpubReader/
├── App/                # App entry and root composition
├── Core/               # Persistence, models, shared utilities
├── Features/           # Library and reader feature modules
└── Resources/          # HTML/CSS/JS resources for EPUB rendering
```

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m "feat: add your feature"`)
4. Push your branch (`git push origin feature/your-feature`)
5. Open a pull request

For larger changes, open an issue first to discuss scope and implementation approach.

## License

This project is currently unlicensed in-repo. If you plan to distribute it, add a `LICENSE` file (for example, MIT, Apache-2.0, or proprietary terms) and update this section accordingly.
