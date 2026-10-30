use super::logger::{error, log};
use anyhow::Result;
use chrono::Utc;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use serde_with::skip_serializing_none;
use std::fs;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::sync::Mutex;
use tempfile::Builder as TempfileBuilder;

pub struct Telemetry {
    diagnostics_directory: PathBuf,
    collected_messages: Mutex<Vec<TelemetryMessage>>,
}

#[derive(Debug, Clone, Copy, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Severity {
    Note,
    Warning,
    Error,
}

#[skip_serializing_none]
#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct TelemetryMessage {
    timestamp: String,
    source: TelemetrySource,
    severity: Severity,
    visibility: TelemetryVisibility,
    plaintext_message: Option<String>,
    attributes: Option<Value>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct TelemetrySource {
    id: &'static str,
    name: String,
    extractor_name: &'static str,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct TelemetryVisibility {
    status_page: bool,
    cli_summary_table: bool,
    telemetry: bool,
}

impl TelemetryMessage {
    pub fn new(severity: Severity, id: &'static str, name: impl Into<String>) -> TelemetryMessage {
        TelemetryMessage {
            timestamp: Utc::now().to_rfc3339_opts(chrono::SecondsFormat::AutoSi, true),
            source: TelemetrySource {
                id,
                name: name.into(),
                extractor_name: "cpp",
            },
            severity,
            visibility: TelemetryVisibility {
                status_page: false,
                cli_summary_table: false,
                telemetry: true,
            },
            plaintext_message: None,
            attributes: None,
        }
    }

    #[must_use]
    pub fn plaintext_message(mut self, plaintext_message: &str) -> TelemetryMessage {
        self.plaintext_message = Some(plaintext_message.to_string());
        self
    }

    #[must_use]
    pub fn attributes(mut self, attributes: Value) -> TelemetryMessage {
        self.attributes = Some(attributes);
        self
    }
}

impl Telemetry {
    pub fn new(diagnostics_directory: String) -> Result<Telemetry> {
        fs::create_dir_all(&diagnostics_directory)?;
        Ok(Telemetry {
            diagnostics_directory: PathBuf::from(diagnostics_directory),
            collected_messages: Mutex::new(Vec::new()),
        })
    }

    fn write_message_worker(&self, telemetry_message: &TelemetryMessage) -> std::io::Result<()> {
        let time = Utc::now();
        let time_usecs = time.timestamp_micros();
        let pid = std::process::id();

        let prefix = "standalone-extraction";
        let mut tempfile = TempfileBuilder::new()
            .prefix(prefix)
            .suffix(".json.tmp")
            .tempfile_in(&self.diagnostics_directory)?;
        tempfile.write_all(serde_json::to_string(telemetry_message)?.as_bytes())?;
        tempfile.flush()?;

        let mut file_num = 0;
        let mut file_path;
        loop {
            file_path = self
                .diagnostics_directory
                .join(format!("{prefix}.{pid}.{time_usecs}.{file_num}.json"));
            if let Ok(false) = fs::exists(&file_path) {
                break;
            }
            file_num += 1;
        }
        tempfile.persist_noclobber(file_path)?;

        Ok(())
    }

    pub fn write_message(&self, telemetry_message: TelemetryMessage) {
        // Write to individual file
        let _ = self
            .write_message_worker(&telemetry_message)
            .inspect_err(|e| {
                error!("Failed to write telemetry message: {e}");
            });
        // Collect the message for potential combined output
        if let Ok(mut messages) = self.collected_messages.lock() {
            messages.push(telemetry_message);
        }
    }

    /// Writes all collected telemetry messages to a combined JSON file.
    pub fn write_combined_to_file(&self, path: &Path) {
        let messages = match self.collected_messages.lock() {
            Ok(guard) => guard.clone(),
            Err(e) => {
                error!("Failed to lock telemetry messages: {e}");
                return;
            }
        };
        let json_str = match serde_json::to_string_pretty(&messages) {
            Ok(s) => s,
            Err(e) => {
                error!("Failed to serialize telemetry messages: {e}");
                return;
            }
        };
        if let Err(e) = fs::write(path, json_str) {
            error!("Failed to write combined telemetry file: {e}");
        }
    }
}
