use serde::Serialize;
use std::io::Write;
use std::path::PathBuf;
/** SARIF severity */
#[derive(Serialize)]
pub enum Severity {
    Error,
    Warning,
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

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Location {
    #[serde(skip_serializing_if = "Option::is_none")]
    /** Path to the affected file if appropriate, relative to the source root */
    pub file: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start_line: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start_column: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end_line: Option<i32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end_column: Option<i32>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct DiagnosticMessage {
    /** Unix timestamp */
    pub timestamp: u64,
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
    path: Option<PathBuf>,
    inner: Option<std::io::BufWriter<std::fs::File>>,
}

impl LogWriter {
    pub fn write(&mut self, mesg: &DiagnosticMessage) -> std::io::Result<()> {
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
            serde_json::to_writer(&mut writer, mesg)?;
            &mut writer.write_all(b"\n")?;
        }
        Ok(())
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
                tracing::error!("{}: {}", &env_var, e);
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
            inner: None,
            path: self
                .root
                .as_ref()
                .map(|root| root.to_owned().join(format!("extractor_{}.jsonl", n))),
        })
    }
    pub fn message(&self, id: &str, name: &str) -> DiagnosticMessage {
        DiagnosticMessage {
            timestamp: std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .expect("")
                .as_millis() as u64,
            source: Source {
                id: id.to_owned(),
                name: name.to_owned(),
                extractor_name: Some(self.extractor),
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
}
static EMPTY_LOCATION: Location = Location {
    file: None,
    start_line: None,
    start_column: None,
    end_line: None,
    end_column: None,
};
impl DiagnosticMessage {
    pub fn text<'a>(&'a mut self, text: &str) -> &'a mut Self {
        self.plaintext_message = text.to_owned();
        self
    }
    pub fn markdown<'a>(&'a mut self, text: &str) -> &'a mut Self {
        self.markdown_message = text.to_owned();
        self
    }
    pub fn severity<'a>(&'a mut self, severity: Severity) -> &'a mut Self {
        self.severity = Some(severity);
        self
    }
    pub fn help_link<'a>(&'a mut self, link: &str) -> &'a mut Self {
        self.help_links.push(link.to_owned());
        self
    }
    pub fn internal<'a>(&'a mut self) -> &'a mut Self {
        self.internal = true;
        self
    }
    pub fn cli_summary_table<'a>(&'a mut self) -> &'a mut Self {
        self.visibility.cli_summary_table = true;
        self
    }
    pub fn status_page<'a>(&'a mut self) -> &'a mut Self {
        self.visibility.status_page = true;
        self
    }
    pub fn telemetry<'a>(&'a mut self) -> &'a mut Self {
        self.visibility.telemetry = true;
        self
    }
    pub fn file<'a>(&'a mut self, path: &str) -> &'a mut Self {
        self.location.get_or_insert(EMPTY_LOCATION).file = Some(path.to_owned());
        self
    }
    pub fn start_line<'a>(&'a mut self, start_line: i32) -> &'a mut Self {
        self.location.get_or_insert(EMPTY_LOCATION).start_line = Some(start_line);
        self
    }
    pub fn start_column<'a>(&'a mut self, start_column: i32) -> &'a mut Self {
        self.location.get_or_insert(EMPTY_LOCATION).start_column = Some(start_column);
        self
    }
    pub fn end_line<'a>(&'a mut self, end_line: i32) -> &'a mut Self {
        self.location.get_or_insert(EMPTY_LOCATION).end_line = Some(end_line);
        self
    }
    pub fn end_column<'a>(&'a mut self, end_column: i32) -> &'a mut Self {
        self.location.get_or_insert(EMPTY_LOCATION).end_column = Some(end_column);
        self
    }
}
