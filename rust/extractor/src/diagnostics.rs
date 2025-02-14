use crate::config::Config;
use anyhow::Context;
use chrono::{DateTime, Utc};
use log::{debug, info};
use ra_ap_project_model::ProjectManifest;
use serde::ser::SerializeMap;
use serde::Serialize;
use std::collections::HashMap;
use std::fmt::Display;
use std::fs::File;
use std::path::{Path, PathBuf};
use std::time::Instant;

#[derive(Default, Debug, Clone, Copy, Serialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
enum Severity {
    #[default]
    Note,
    Warning,
    Error,
}

#[derive(Default, Debug, Clone, Copy, Serialize)]
#[serde(rename_all = "camelCase")]
struct Visibility {
    status_page: bool,
    cli_summary_table: bool,
    telemetry: bool,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
enum Message {
    TextMessage(String),
    MarkdownMessage(String),
}

impl Default for Message {
    fn default() -> Self {
        Message::TextMessage("".to_string())
    }
}

#[derive(Default, Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct Source {
    id: String,
    name: String,
    extractor_name: String,
}

#[derive(Default, Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct Location {
    file: PathBuf,
    start_line: u32,
    start_column: u32,
    end_line: u32,
    end_column: u32,
}

#[derive(Default, Debug, Clone, Serialize)]
pub struct Diagnostics<T> {
    source: Source,
    visibility: Visibility,
    severity: Severity,
    #[serde(flatten)]
    message: Message,
    timestamp: DateTime<Utc>,
    #[serde(skip_serializing_if = "Option::is_none")]
    location: Option<Location>,
    attributes: T,
}

#[derive(Default, Debug, Clone, Copy, Serialize, PartialEq, Eq, Hash)]
#[serde(rename_all = "camelCase")]
pub enum ExtractionStepKind {
    #[default]
    LoadManifest,
    FindManifests,
    LoadSource,
    Parse,
    Extract,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExtractionStep {
    pub action: ExtractionStepKind,
    pub file: Option<PathBuf>,
    pub ms: u128,
}

impl ExtractionStep {
    fn new(start: Instant, action: ExtractionStepKind, file: Option<PathBuf>) -> Self {
        let ret = ExtractionStep {
            action,
            file,
            ms: start.elapsed().as_millis(),
        };
        debug!("{ret:?}");
        ret
    }

    pub fn load_manifest(start: Instant, target: &ProjectManifest) -> Self {
        Self::new(
            start,
            ExtractionStepKind::LoadManifest,
            Some(PathBuf::from(target.manifest_path())),
        )
    }

    pub fn parse(start: Instant, target: &Path) -> Self {
        Self::new(
            start,
            ExtractionStepKind::Parse,
            Some(PathBuf::from(target)),
        )
    }

    pub fn extract(start: Instant, target: &Path) -> Self {
        Self::new(
            start,
            ExtractionStepKind::Extract,
            Some(PathBuf::from(target)),
        )
    }

    pub fn load_source(start: Instant, target: &Path) -> Self {
        Self::new(
            start,
            ExtractionStepKind::LoadSource,
            Some(PathBuf::from(target)),
        )
    }

    pub fn find_manifests(start: Instant) -> Self {
        Self::new(start, ExtractionStepKind::FindManifests, None)
    }
}

#[derive(Debug, Default, Clone)]
struct HumanReadableDuration(u128);

impl Serialize for HumanReadableDuration {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut map = serializer.serialize_map(Some(2))?;
        map.serialize_entry("ms", &self.0)?;
        map.serialize_entry("pretty", &self.pretty())?;
        map.end()
    }
}

impl HumanReadableDuration {
    pub fn add(&mut self, other: u128) {
        self.0 += other;
    }

    pub fn pretty(&self) -> String {
        let milliseconds = self.0 % 1000;
        let mut seconds = self.0 / 1000;
        if seconds < 60 {
            return format!("{seconds}.{milliseconds:03}s");
        }
        let mut minutes = seconds / 60;
        seconds %= 60;
        if minutes < 60 {
            return format!("{minutes}min{seconds:02}.{milliseconds:03}s");
        }
        let hours = minutes / 60;
        minutes %= 60;
        format!("{hours}h{minutes:02}min{seconds:02}.{milliseconds:03}s")
    }
}

impl From<u128> for HumanReadableDuration {
    fn from(val: u128) -> Self {
        HumanReadableDuration(val)
    }
}

impl Display for HumanReadableDuration {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str(&self.pretty())
    }
}

#[derive(Debug, Default, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct DurationsSummary {
    #[serde(flatten)]
    durations: HashMap<ExtractionStepKind, HumanReadableDuration>,
    total: HumanReadableDuration,
}

#[derive(Debug, Default, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct ExtractionSummary {
    number_of_manifests: usize,
    number_of_files: usize,
    durations: DurationsSummary,
}

type ExtractionDiagnostics = Diagnostics<ExtractionSummary>;

fn summary(start: Instant, steps: &[ExtractionStep]) -> ExtractionSummary {
    let mut number_of_manifests = 0;
    let mut number_of_files = 0;
    let mut durations = HashMap::new();
    for step in steps {
        match &step.action {
            ExtractionStepKind::LoadManifest => {
                number_of_manifests += 1;
            }
            ExtractionStepKind::Parse => {
                number_of_files += 1;
            }
            _ => {}
        }
        durations
            .entry(step.action)
            .or_insert(HumanReadableDuration(0))
            .add(step.ms);
    }
    let total = start.elapsed().as_millis().into();
    for (key, value) in &durations {
        info!("total duration ({key:?}): {value}");
    }
    info!("total duration: {total}");
    ExtractionSummary {
        number_of_manifests,
        number_of_files,
        durations: DurationsSummary { durations, total },
    }
}

pub fn emit_extraction_diagnostics(
    start: Instant,
    config: &Config,
    steps: &[ExtractionStep],
) -> anyhow::Result<()> {
    let summary = summary(start, steps);
    let diagnostics = ExtractionDiagnostics {
        source: Source {
            id: "rust/extractor/telemetry".to_owned(),
            name: "telemetry".to_string(),
            extractor_name: "rust".to_string(),
        },
        visibility: Visibility {
            telemetry: true,
            ..Default::default()
        },
        timestamp: Utc::now(),
        attributes: summary,
        ..Default::default()
    };

    std::fs::create_dir_all(&config.diagnostic_dir).with_context(|| {
        format!(
            "creating diagnostics directory {}",
            config.diagnostic_dir.display()
        )
    })?;
    let target = config.diagnostic_dir.join("extraction.jsonc");
    let mut output = File::create(&target)
        .with_context(|| format!("creating diagnostics file {}", target.display()))?;
    serde_json::to_writer_pretty(&mut output, &diagnostics)
        .with_context(|| format!("writing to diagnostics file {}", target.display()))?;
    Ok(())
}
