use crate::config::Config;
use anyhow::Context;
use chrono::{DateTime, Utc};
use log::{debug, info};
use ra_ap_project_model::ProjectManifest;
use serde::Serialize;
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

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
enum ExtractionStepTarget {
    LoadManifest(PathBuf),
    FetchFile(PathBuf),
    Parse(PathBuf),
    Extract(PathBuf),
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExtractionStep {
    #[serde(flatten)]
    target: ExtractionStepTarget,
    ms: u128,
}

impl ExtractionStep {
    fn new(start: Instant, target: ExtractionStepTarget) -> Self {
        let ret = ExtractionStep {
            target,
            ms: start.elapsed().as_millis(),
        };
        debug!("{ret:?}");
        ret
    }

    pub fn load_manifest(start: Instant, target: &ProjectManifest) -> Self {
        Self::new(
            start,
            ExtractionStepTarget::LoadManifest(PathBuf::from(target.manifest_path())),
        )
    }

    pub fn parse(start: Instant, target: &Path) -> Self {
        Self::new(start, ExtractionStepTarget::Parse(PathBuf::from(target)))
    }

    pub fn extract(start: Instant, target: &Path) -> Self {
        Self::new(start, ExtractionStepTarget::Extract(PathBuf::from(target)))
    }

    pub fn fetch_file(start: Instant, target: &Path) -> Self {
        Self::new(
            start,
            ExtractionStepTarget::FetchFile(PathBuf::from(target)),
        )
    }
}

#[derive(Debug, Default, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct HumanReadableDuration {
    ms: u128,
    pretty: String,
}

impl HumanReadableDuration {
    pub fn new(ms: u128) -> Self {
        let seconds = ms / 1000;
        let minutes = seconds / 60;
        let hours = minutes / 60;
        let pretty = format!(
            "{hours}:{minutes:02}:{seconds:02}.{milliseconds:03}",
            minutes = minutes % 60,
            seconds = seconds % 60,
            milliseconds = ms % 1000,
        );
        Self { ms, pretty }
    }
}

impl From<u128> for HumanReadableDuration {
    fn from(val: u128) -> Self {
        HumanReadableDuration::new(val)
    }
}

impl Display for HumanReadableDuration {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}ms ({})", self.ms, self.pretty)
    }
}

#[derive(Debug, Default, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct ExtractionSummary {
    number_of_manifests: usize,
    number_of_files: usize,
    total_load_duration: HumanReadableDuration,
    total_fetch_file_duration: HumanReadableDuration,
    total_parse_duration: HumanReadableDuration,
    total_extract_duration: HumanReadableDuration,
    total_duration: HumanReadableDuration,
}

#[derive(Debug, Default, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
struct ExtractionAttributes {
    steps: Vec<ExtractionStep>,
    summary: ExtractionSummary,
}

type ExtractionDiagnostics = Diagnostics<ExtractionAttributes>;

fn summary(start: Instant, steps: &[ExtractionStep]) -> ExtractionSummary {
    let mut number_of_manifests = 0;
    let mut number_of_files = 0;
    let mut total_load_duration = 0;
    let mut total_parse_duration = 0;
    let mut total_extract_duration = 0;
    let mut total_fetch_file_duration: u128 = 0;
    for step in steps {
        match &step.target {
            ExtractionStepTarget::LoadManifest(_) => {
                number_of_manifests += 1;
                total_load_duration += step.ms;
            }
            ExtractionStepTarget::FetchFile(_) => {
                number_of_files += 1;
                total_fetch_file_duration += step.ms;
            }
            ExtractionStepTarget::Parse(_) => {
                total_parse_duration += step.ms;
            }
            ExtractionStepTarget::Extract(_) => {
                total_extract_duration += step.ms;
            }
        }
    }
    let ret = ExtractionSummary {
        number_of_manifests,
        number_of_files,
        total_load_duration: total_load_duration.into(),
        total_fetch_file_duration: total_fetch_file_duration.into(),
        total_parse_duration: total_parse_duration.into(),
        total_extract_duration: total_extract_duration.into(),
        total_duration: start.elapsed().as_millis().into(),
    };
    info!("total loadimg duration: {}", ret.total_load_duration);
    info!(
        "total file fetching duration: {}",
        ret.total_fetch_file_duration
    );
    info!("total parsing duration: {}", ret.total_parse_duration);
    info!("total extracting duration: {}", ret.total_extract_duration);
    info!("total duration: {}", ret.total_duration);
    ret
}

pub fn emit_extraction_diagnostics(
    start: Instant,
    config: &Config,
    steps: Vec<ExtractionStep>,
) -> anyhow::Result<()> {
    let summary = summary(start, &steps);
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
        attributes: ExtractionAttributes { steps, summary },
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
