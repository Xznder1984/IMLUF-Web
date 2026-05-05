# IMF Browser

A modern, cross-platform web browser written in Rust, featuring the decentralized `IMF:` protocol.

## 🚀 Features
- **IMF Protocol**: Browse sites using `IMF:domain.tld`.
- **Local Hosting**: Host sites locally using Node.js or Python and map them to IMF domains.
- **Dark UI**: Brave-inspired minimal dark theme.
- **Encryption**: End-to-End Encryption between IMF domains.
- **Cross-Platform**: Windows, macOS, and Linux.

## 🛠 Setup & Installation

### Prerequisites
- **Rust**: Install via [rustup.rs](https://rustup.rs/)
- **Node.js & npm**: Required for the UI frontend.
- **Tauri Dependencies**:
  - **Windows**: [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/) and C++ Build Tools.
  - **Linux**: `libwebkit2gtk-4.1-dev`, `build-essential`, `curl`, `wget`, `libssl-dev`, `libgtk-3-dev`, `libayatana-appindicator3-dev`, `librsvg2-dev`.
  - **macOS**: Xcode Command Line Tools.

## 📦 Build Pipeline
The project uses GitHub Actions to build for all platforms automatically. Binaries are compressed with **UPX**, and Windows releases include a professional installer generated via **Inno Setup**. 
Check the "Actions" tab on GitHub to find the latest artifacts for Windows, macOS, and Linux.

### 🌐 Using the IMF Protocol
1. Open the browser.
2. Go to **Settings** (Gear icon).
3. Register a domain (e.g., `mysite.web`) and assign a local port (e.g., `8080`).
4. Start a local server in a folder:
   - **Node.js**: `npm install -g http-server && http-server -p 8080`
   - **Python**: `python -m http.server 8080`
5. Type `IMF:mysite.web` in the URL bar.
