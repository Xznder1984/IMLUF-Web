use crate::registry::RegistryManager;
use url::Url;
use anyhow::{Result, anyhow};

pub struct ProtocolHandler {
    pub registry: RegistryManager,
}

impl ProtocolHandler {
    pub fn new(registry: RegistryManager) -> Self {
        Self { registry }
    }

    pub fn resolve_imf_url(&self, imf_url: &str) -> Result<String> {
        // Expects format IMF:domain.tld
        if !imf_url.to_uppercase().starts_with("IMF:") {
            return Err(anyhow!("Invalid IMF protocol prefix"));
        }

        let domain = &imf_url[4..];
        if let Some(entry) = self.registry.resolve_domain(domain) {
            if let Some(ref target) = entry.target_url {
                return Ok(target.clone());
            }
            return Ok(format!("http://localhost:{}", entry.port));
        }

        Err(anyhow!("Domain {} not registered in IMF registry", domain))
    }
}
