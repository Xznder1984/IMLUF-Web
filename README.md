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
- Rust (Latest Stable)
- Node.js & npm (for UI and local server)
- Tauri dependencies (see [Tauri Setup](https://tauri.app/v1/guides/getting-started/prerequisites))

### Building from Source
1. Clone the repository.
2. Install UI dependencies (if any) and run:
   ```bash
   cd browser/src-tauri
   cargo build --release
   ```

### Using the IMF Protocol
1. Open the browser.
2. Go to **Settings** (Gear icon).
3. Register a domain (e.g., `mysite.web`) and assign a local port (e.g., `8080`).
4. Start a local server in a folder:
   - **Node.js**: `npm install -g http-server && http-server -p 8080`
   - **Python**: `python -m http.server 8080`
5. Type `IMF:mysite.web` in the URL bar.

## 📦 Build Pipeline
The project uses GitHub Actions to build for all platforms. Binaries are compressed with **UPX** and Windows installs are packaged with **Inno Setup**.
