use serde::Serialize;
use std::io::Write;
use std::path::PathBuf;
/** SARIF severity */
#[derive(Serialize)]
pub enum Severity {
    Error,
    Warning,
    #[allow(unused)]
    Note,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Source {
    /** An identifier under which it makes sense to group this diagnostic message. This is used to build the SARIF reporting descriptor object.*/
    pub id: String,
    /** Display name for the ID. This is used to build the SARIF reporting descriptor object. */
    pub name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    /** Name of the CodeQL extractor. This is used to identify which tool component the reporting descriptor object should be nested under in SARIF.*/
    pub extractor_name: Option<String>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Visibility {
    #[serde(skip_serializing_if = "std::ops::Not::not")]
    /** True if the message should be displayed on the status page (defaults to false) */
    pub status_page: bool,
    #[serde(skip_serializing_if = "std::ops::Not::not")]
    /** True if the message should be counted in the diagnostics summary table printed by `codeql database analyze` (defaults to false) */
    pub cli_summary_table: bool,
    #[serde(skip_serializing_if = "std::ops::Not::not")]
    /** True if the message should be sent to telemetry (defaults to false) */
    pub telemetry: bool,
}

#[derive(Serialize, Clone, Default)]
#[serde(rename_all = "camelCase")]
pub struct Location {
    #[serde(skip_serializing_if = "Option::is_none")]
    /** Path to the affected file if appropriate, relative to the source root */
    pub file: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start_line: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start_column: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end_line: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end_column: Option<usize>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct DiagnosticMessage {
    /** Unix timestamp */
    pub timestamp: chrono::DateTime<chrono::Utc>,
    pub source: Source,
    #[serde(skip_serializing_if = "String::is_empty")]
    /** GitHub flavored Markdown formatted message. Should include inline links to any help pages. */
    pub markdown_message: String,
    #[serde(skip_serializing_if = "String::is_empty")]
    /** Plain text message. Used by components where the string processing needed to support Markdown is cumbersome. */
    pub plaintext_message: String,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    /** List of help links intended to supplement the `plaintextMessage`. */
    pub help_links: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub severity: Option<Severity>,
    #[serde(skip_serializing_if = "std::ops::Not::not")]
    pub internal: bool,
    #[serde(skip_serializing_if = "is_default_visibility")]
    pub visibility: Visibility,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub location: Option<Location>,
}

fn is_default_visibility(v: &Visibility) -> bool {
    !v.cli_summary_table && !v.status_page && !v.telemetry
}

pub struct LogWriter {
    extractor: String,
    path: Option<PathBuf>,
    inner: Option<std::io::BufWriter<std::fs::File>>,
}

impl LogWriter {
    pub fn message(&self, id: &str, name: &str) -> DiagnosticMessage {
        DiagnosticMessage {
            timestamp: chrono::Utc::now(),
            source: Source {
                id: format!("{}/{}", self.extractor, id),
                name: name.to_owned(),
                extractor_name: Some(self.extractor.to_owned()),
            },
            markdown_message: String::new(),
            plaintext_message: String::new(),
            help_links: vec![],
            severity: None,
            internal: false,
            visibility: Visibility {
                cli_summary_table: false,
                status_page: false,
                telemetry: false,
            },
            location: None,
        }
    }
    pub fn write(&mut self, mesg: &DiagnosticMessage) {
        let full_error_message = mesg.full_error_message();

        match mesg.severity {
            Some(Severity::Error) => tracing::error!("{}", full_error_message),
            Some(Severity::Warning) => tracing::warn!("{}", full_error_message),
            Some(Severity::Note) => tracing::info!("{}", full_error_message),
            None => tracing::debug!("{}", full_error_message),
        }
        if self.inner.is_none() {
            let mut open_failed = false;
            self.inner = self.path.as_ref().and_then(|path| {
                match std::fs::OpenOptions::new()
                    .create(true)
                    .append(true)
                    .write(true)
                    .open(&path)
                {
                    Err(e) => {
                        tracing::error!(
                            "Could not open log file '{}': {}",
                            &path.to_string_lossy(),
                            e
                        );
                        open_failed = true;
                        None
                    }
                    Ok(file) => Some(std::io::BufWriter::new(file)),
                }
            });
            if open_failed {
                self.path = None
            }
        }
        if let Some(mut writer) = self.inner.as_mut() {
            serde_json::to_writer(&mut writer, mesg)
                .unwrap_or_else(|e| tracing::debug!("Failed to write log entry: {}", e));
            &mut writer
                .write_all(b"\n")
                .unwrap_or_else(|e| tracing::debug!("Failed to write log entry: {}", e));
        }
    }
}

pub struct DiagnosticLoggers {
    extractor: String,
    root: Option<PathBuf>,
}

impl DiagnosticLoggers {
    pub fn new(extractor: &str) -> Self {
        let env_var = format!(
            "CODEQL_EXTRACTOR_{}_DIAGNOSTIC_DIR",
            extractor.to_ascii_uppercase()
        );

        let root = match std::env::var(&env_var) {
            Err(e) => {
                tracing::error!("{}: {}", e, &env_var);
                None
            }
            Ok(dir) => {
                if let Err(e) = std::fs::create_dir_all(&dir) {
                    tracing::error!("Failed to create log directory {}: {}", &dir, e);
                    None
                } else {
                    Some(PathBuf::from(dir))
                }
            }
        };
        DiagnosticLoggers {
            extractor: extractor.to_owned(),
            root,
        }
    }

    pub fn logger(&self) -> LogWriter {
        thread_local! {
            static THREAD_NUM: usize = {
                static COUNT: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);
                COUNT.fetch_add(1, std::sync::atomic::Ordering::SeqCst)
            };
        }
        THREAD_NUM.with(|n| LogWriter {
            extractor: self.extractor.to_owned(),
            inner: None,
            path: self
                .root
                .as_ref()
                .map(|root| root.to_owned().join(format!("extractor_{}.jsonl", n))),
        })
    }
}

impl DiagnosticMessage {
    pub fn full_error_message(&self) -> String {
        match &self.location {
            Some(Location {
                file: Some(path),
                start_line: Some(line),
                ..
            }) => format!("{}:{}: {}", path, line, self.plaintext_message),
            _ => self.plaintext_message.to_owned(),
        }
    }

    pub fn text(&mut self, text: &str) -> &mut Self {
        self.plaintext_message = text.to_owned();
        self
    }

    #[allow(unused)]
    pub fn markdown(&mut self, text: &str) -> &mut Self {
        self.markdown_message = text.to_owned();
        self
    }
    pub fn severity(&mut self, severity: Severity) -> &mut Self {
        self.severity = Some(severity);
        self
    }
    #[allow(unused)]
    pub fn help_link(&mut self, link: &str) -> &mut Self {
        self.help_links.push(link.to_owned());
        self
    }
    #[allow(unused)]
    pub fn internal(&mut self) -> &mut Self {
        self.internal = true;
        self
    }
    #[allow(unused)]
    pub fn cli_summary_table(&mut self) -> &mut Self {
        self.visibility.cli_summary_table = true;
        self
    }
    pub fn status_page(&mut self) -> &mut Self {
        self.visibility.status_page = true;
        self
    }
    #[allow(unused)]
    pub fn telemetry(&mut self) -> &mut Self {
        self.visibility.telemetry = true;
        self
    }
    pub fn location(
        &mut self,
        path: &str,
        start_line: usize,
        start_column: usize,
        end_line: usize,
        end_column: usize,
    ) -> &mut Self {
        let loc = self.location.get_or_insert(Default::default());
        loc.file = Some(path.to_owned());
        loc.start_line = Some(start_line);
        loc.start_column = Some(start_column);
        loc.end_line = Some(end_line);
        loc.end_column = Some(end_column);
        self
    }
}
