#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod registry;
mod protocol;
mod crypto;
mod server;

use registry::{RegistryManager, DomainEntry};
use protocol::ProtocolHandler;
use server::{ServerManager, ServerType};
use tauri::{State, Manager};
use std::sync::Mutex;
use std::path::PathBuf;

struct AppState {
    registry: Mutex<RegistryManager>,
}

#[tauri::command]
fn resolve_url(state: State<AppState>, url: String) -> Result<String, String> {
    let registry = state.registry.lock().unwrap();
    let handler = ProtocolHandler::new(registry.clone_registry()); // Helper needed in RegistryManager
    
    if url.to_uppercase().starts_with("IMF:") {
        handler.resolve_imf_url(&url).map_err(|e| e.to_string())
    } else {
        Ok(url)
    }
}

#[tauri::command]
fn register_domain(state: State<AppState>, domain: String, port: u16, target_url: Option<String>) -> Result<bool, String> {
    let mut registry = state.registry.lock().unwrap();
    registry.register_domain(domain, port, target_url).map_err(|e| e.to_string())
}

#[tauri::command]
fn start_local_server(state: State<AppState>, domain: String, dir: String, server_type: String) -> Result<String, String> {
    let registry = state.registry.lock().unwrap();
    let entry = registry.resolve_domain(&domain).ok_or("Domain not found")?;
    
    let s_type = match server_type.as_str() {
        "node" => ServerType::Node,
        "python" => ServerType::Python,
        _ => return Err("Invalid server type".to_string()),
    };

    ServerManager::start_server(s_type, PathBuf::from(dir), entry.port)
        .map(|_| format!("Server started for {} on port {}", domain, entry.port))
        .map_err(|e| e.to_string())
}

// Adding a helper to RegistryManager for cloning state without mutex lock issues
impl RegistryManager {
    pub fn clone_registry(&self) -> RegistryManager {
        // In a real app, we'd implement Clone or use Arc. For simplicity:
        // We assume the paths are constant.
        let paths = (self.registry_path.clone(), self.tlds_path.clone());
        RegistryManager::new(paths.0, paths.1).unwrap()
    }
}

fn main() {
    let registry_path = PathBuf::from("browser/config/domain_registry.json");
    let tlds_path = PathBuf::from("browser/config/domains.txt");
    
    let registry = RegistryManager::new(registry_path, tlds_path).expect("Failed to init registry");

    tauri::Builder::default()
        .manage(AppState {
            registry: Mutex::new(registry),
        })
        .invoke_handler(tauri::generate_handler![resolve_url, register_domain, start_local_server])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
