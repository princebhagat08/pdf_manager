# 📘 Offline PDF Manager – Flutter App

A simple yet powerful Flutter app to **download, view, manage, and delete PDF files offline**. Users can download PDFs from a remote URL, view them using a native viewer, search through downloaded reports, and delete selected files. Built with a focus on performance and a clean UI.

---

## ✨ Features

- 📥 Download PDF from a public URL
- 📁 Store files in local storage using `path_provider`
- 📃 Beautiful card-style UI with PDF preview thumbnails (1st page)
- 🔍 Search bar to filter reports by name
- ✅ Long-press selection for multiple files
- 🗑️ Delete selected files with animated feedback
- 📡 Works completely offline


---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.32.1
- Android Studio / VS Code
- Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/princebhagat08/pdf_manager.git
   cd pdf-managet
   ```

2. Get packages
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

### Directory Stucture
```lib/
├── main.dart
├── screens/
│   └── downloaded_reports_screen.dart
├── services/
│   └── file_service.dart
├── widgets/
│   └── pdf_tile.dart
```
   

