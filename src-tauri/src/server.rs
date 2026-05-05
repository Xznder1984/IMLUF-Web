use std::process::{Command, Child};
use std::path::PathBuf;
use anyhow::{Result, anyhow};

pub enum ServerType {
    Node,
    Python,
}

pub struct ServerManager;

impl ServerManager {
    pub fn start_server(server_type: ServerType, dir: PathBuf, port: u16) -> Result<Child> {
        match server_type {
            ServerType::Node => {
                // Assumes a simple http-server is installed via npm: npm install -g http-server
                Command::new("http-server")
                    .arg("-p")
                    .arg(port.to_string())
                    .current_dir(dir)
                    .spawn()
                    .map_err(|e| anyhow!("Failed to start Node server: {}", e))
            },
            ServerType::Python => {
                // Uses Python's built-in http.server
                Command::new("python")
                    .arg("-m")
                    .arg("http.server")
                    .arg(port.to_string())
                    .current_dir(dir)
                    .spawn()
                    .map_err(|e| anyhow!("Failed to start Python server: {}", e))
            }
        }
    }
}
