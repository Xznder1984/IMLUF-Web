use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use anyhow::{Result, Context};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DomainEntry {
    pub domain: String,
    pub port: u16,
    pub target_url: Option<String>, // For GitHub Pages integration
}

pub struct RegistryManager {
    registry_path: PathBuf,
    tlds_path: PathBuf,
    pub domains: HashMap<String, DomainEntry>,
    pub allowed_tlds: Vec<String>,
}

impl RegistryManager {
    pub fn new(registry_path: PathBuf, tlds_path: PathBuf) -> Result<Self> {
        let mut manager = Self {
            registry_path,
            tlds_path,
            domains: HashMap::new(),
            allowed_tlds: Vec::new(),
        };
        manager.load_tlds()?;
        manager.load_registry()?;
        Ok(manager)
    }

    fn load_tlds(&mut self) -> Result<()> {
        if !self.tlds_path.exists() {
            fs::write(&self.tlds_path, "web\napp\nlocal\nme")?;
        }
        let content = fs::read_to_string(&self.tlds_path)?;
        self.allowed_tlds = content.lines().map(|s| s.trim().to_string()).collect();
        Ok(())
    }

    fn load_registry(&mut self) -> Result<()> {
        if !self.registry_path.exists() {
            fs::write(&self.registry_path, "{}")?;
        }
        let content = fs::read_to_string(&self.registry_path)?;
        self.domains = serde_json::from_str(&content).context("Failed to parse registry JSON")?;
        Ok(())
    }

    pub fn save_registry(&self) -> Result<()> {
        let content = serde_json::to_string_pretty(&self.domains)?;
        fs::write(&self.registry_path, content)?;
        Ok(())
    }

    pub fn register_domain(&mut self, domain: String, port: u16, target_url: Option<String>) -> Result<bool> {
        let parts: Vec<&str> = domain.split('.').collect();
        if parts.len() < 2 {
            return Ok(false);
        }
        let tld = parts.last().unwrap().to_string();
        if !self.allowed_tlds.contains(&tld) {
            return Ok(false);
        }

        self.domains.insert(domain.clone(), DomainEntry {
            domain,
            port,
            target_url,
        });
        self.save_registry()?;
        Ok(true)
    }

    pub fn resolve_domain(&self, domain: &str) -> Option<DomainEntry> {
        self.domains.get(domain).cloned()
    }
}
