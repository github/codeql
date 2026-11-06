use crate::environment;
use crate::logger::{debug, info, log, warning};
use crate::project_definitions::SourceFile;
use crate::telemetry::{Severity, Telemetry, TelemetryMessage};
use crate::timing::ExecuteAccumulateTime;
use rayon::prelude::*;
use serde::ser::SerializeSeq;
use serde::{Serialize, Serializer};
use serde_json::Value;
use std::collections::HashMap;
use std::ffi::OsString;
use std::fmt::{Display, Formatter};
use std::io;
use std::path::Path;
use std::process::{Command, ExitStatus, Stdio};
use std::time::Duration;

fn osstring_to_lossy_string(o: &OsString) -> String {
    if let Some(s) = o.to_str() {
        s.to_string()
    } else {
        format!("Lossy: {}", o.to_string_lossy())
    }
}

fn pretty_osstrings<S>(os: &Vec<OsString>, serializer: S) -> Result<S::Ok, S::Error>
where
    S: Serializer,
{
    let mut seq = serializer.serialize_seq(Some(os.len()))?;
    for o in os {
        seq.serialize_element(&osstring_to_lossy_string(o))?;
    }
    seq.end()
}

#[derive(Debug, Serialize, Clone)]
pub struct ExtractionCommand {
    #[serde(serialize_with = "pretty_osstrings")]
    arguments: Vec<OsString>,
    #[serde(skip)]
    source_file: SourceFile,
}

impl ExtractionCommand {
    pub fn new(arguments: Vec<OsString>, source_file: &SourceFile) -> Self {
        ExtractionCommand {
            arguments,
            source_file: source_file.clone(),
        }
    }
}

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
enum ExtractorExitStatus {
    ReturnCode(i32),          // Extractor returned exit code
    Signalled,                // The subcommand was terminated by a signal
    RustCommandError(String), // The subcommand failed to execute
}

impl ExtractorExitStatus {
    fn from(subcommand_result: &io::Result<ExitStatus>) -> Self {
        match subcommand_result {
            Ok(status) => {
                match status.code() {
                    Some(exit_code) => Self::ReturnCode(exit_code),
                    None => Self::Signalled, // Process terminated by signal
                }
            }
            Err(err) => Self::RustCommandError(err.to_string()),
        }
    }

    fn is_success(&self) -> bool {
        matches!(self, ExtractorExitStatus::ReturnCode(0))
    }

    fn is_partial(&self) -> bool {
        matches!(self, ExtractorExitStatus::ReturnCode(3))
    }

    fn is_failure(&self) -> bool {
        match self {
            ExtractorExitStatus::ReturnCode(0 | 3) => false,
            ExtractorExitStatus::Signalled
            | ExtractorExitStatus::RustCommandError(_)
            | ExtractorExitStatus::ReturnCode(_) => true,
        }
    }
}

impl Display for ExtractorExitStatus {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            ExtractorExitStatus::ReturnCode(code) => write!(f, "ExitCode: {code}"),
            ExtractorExitStatus::Signalled => write!(f, "Signalled"),
            ExtractorExitStatus::RustCommandError(msg) => write!(f, "RustCommandError: {msg}"),
        }
    }
}

#[derive(Debug)]
struct ExtractionResult {
    command: ExtractionCommand,
    duration: Duration,
    extractor_exit_status: ExtractorExitStatus,
}

struct ExtractionStats<'a> {
    extraction_count: usize,
    status_counts: HashMap<ExtractorExitStatus, u32>,
    success_count: u32,
    partial_count: u32,
    failure_count: u32,
    cpu_time: Duration,
    total_time: Duration,
    slowest_command: Option<&'a ExtractionResult>,
    extraction_errors: Vec<&'a ExtractionResult>,
}

impl<'a> ExtractionStats<'a> {
    fn from(
        extraction_results: &'a [ExtractionResult],
        total_time: Duration,
    ) -> ExtractionStats<'a> {
        let mut cpu_time = Duration::default();
        let mut status_counts: HashMap<ExtractorExitStatus, u32> = HashMap::new();
        let mut slowest_command: Option<&ExtractionResult> = None;
        let mut extraction_errors: Vec<&ExtractionResult> = Vec::new();
        let mut success_count: u32 = 0;
        let mut partial_count: u32 = 0;
        let mut failure_count: u32 = 0;

        for extraction_result in extraction_results {
            cpu_time += extraction_result.duration;

            let exit_code = extraction_result.extractor_exit_status.clone();

            if exit_code.is_success() {
                success_count += 1;
            } else if exit_code.is_partial() {
                partial_count += 1;
            } else if exit_code.is_failure() {
                failure_count += 1;
            }

            // If the command failed (i.e., not success or partial), record it
            if extraction_result.extractor_exit_status.is_failure() {
                extraction_errors.push(extraction_result);
            }

            *status_counts.entry(exit_code).or_insert(0) += 1;

            slowest_command = match slowest_command {
                Some(current_slowest) => {
                    if extraction_result.duration > current_slowest.duration {
                        Some(extraction_result)
                    } else {
                        Some(current_slowest)
                    }
                }
                None => Some(extraction_result),
            };
        }

        ExtractionStats {
            extraction_count: extraction_results.len(),
            status_counts,
            success_count,
            partial_count,
            failure_count,
            cpu_time,
            total_time,
            slowest_command,
            extraction_errors,
        }
    }

    fn log(&self) {
        info!(
            "Ran {} commands [s={},p={},f={}]",
            self.extraction_count, self.success_count, self.partial_count, self.failure_count
        );
    }

    fn debug(&self) {
        debug!("Result breakdown:");
        let mut lines: Vec<String> = self
            .status_counts
            .iter()
            .map(|(k, v)| format!("  {k}: {v}"))
            .collect();
        lines.sort();
        for line in lines {
            debug!("{line}");
        }
    }

    fn get_telemetry_value(&self) -> Value {
        let all_count_values = self
            .status_counts
            .iter()
            .map(|(code, count)| (code.to_string(), Value::from(*count)))
            .collect::<serde_json::Map<_, _>>();

        let mut telemetry_body = serde_json::json!({"extraction_status": {
                                                "#total": self.extraction_count,
                                                "#success": self.success_count,
                                                "#partial": self.partial_count,
                                                "#errors": self.failure_count,
                                                "all_counts": all_count_values,
                                                },
                          "extraction_cpu_time_seconds": self.cpu_time.as_secs_f32(),
                          "total_extraction_time_seconds": self.total_time.as_secs_f32()
        });

        if let Some(slowest_command) = self.slowest_command {
            telemetry_body["slowest_extraction_time_seconds"] =
                Value::from(slowest_command.duration.as_secs_f32());
            telemetry_body["slowest_extraction_args"] = Value::Array(
                slowest_command
                    .command
                    .arguments
                    .iter()
                    .map(|arg| Value::String(osstring_to_lossy_string(arg)))
                    .collect(),
            );
        }

        if !self.extraction_errors.is_empty() {
            let error_body = self.extraction_errors
                .iter()
                .map(|extraction_error| {
                    serde_json::json!({
                    "error_time_seconds": extraction_error.duration.as_secs_f32(),
                    "error_args": extraction_error.command.arguments.iter().map(osstring_to_lossy_string).collect::<Vec<_>>(),
                    "failure_reason": extraction_error.extractor_exit_status.to_string(),
                })
                })
                .collect::<Vec<_>>();

            telemetry_body["extraction_errors"] = Value::Array(error_body);
        }

        telemetry_body
    }
}

fn run_extraction_command_get_status(
    extractor: &Path,
    project_dir: &Path,
    command: &ExtractionCommand,
    index: usize,
) -> ExtractionResult {
    let mut chrono = ExecuteAccumulateTime::default();
    let source_file_name = &command.source_file.path;
    debug!(
        "Starting extraction command {index}: {}",
        source_file_name.display()
    );

    let result = chrono.execute_accumulate_time(|| {
        Command::new(extractor)
            .args(&command.arguments)
            .current_dir(project_dir)
            .env("SEMMLE_CPP_MISSING_INCLUDES_NOT_FATAL", "1")
            .env("CODEQL_EXTRACTOR_CPP_RECURSIVE_INCLUDES_NOT_FATAL", "1")
            /*
            In BMN we know the compiler really is a compiler (or at
            least, if it's not then analysis isn't going to work
            anyway), so we don't need mimicry to timeout to guard
            against it being a binary that won't terminate.
            Hence we scale timeouts to 0, meaning no timeout.
            */
            .env("CODEQL_EXTRACTOR_CPP_OPTION_SCALE_TIMEOUTS", "0")
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .status()
    });

    let elapsed = chrono.total();
    debug!(
        "Finished extraction command {index}: {} ({:.1}s)",
        source_file_name.display(),
        elapsed.as_secs_f64()
    );

    ExtractionResult {
        command: command.clone(),
        duration: elapsed,
        extractor_exit_status: ExtractorExitStatus::from(&result),
    }
}

fn run_extraction_commands_sequential(
    extractor: &Path,
    project_dir: &Path,
    commands: &[ExtractionCommand],
) -> Vec<ExtractionResult> {
    commands
        .iter()
        .enumerate()
        .map(|(idx, cmd)| run_extraction_command_get_status(extractor, project_dir, cmd, idx))
        .collect()
}

fn run_extraction_commands(
    telemetry: &Telemetry,
    threads: usize,
    extractor: &Path,
    project_dir: &Path,
    commands: &[ExtractionCommand],
) -> Vec<ExtractionResult> {
    assert!(
        !environment::get_bool(environment::CODEQL_EXTRACTOR_CPP_BMN_PANIC_TEST),
        "Test panic triggered by {}",
        environment::CODEQL_EXTRACTOR_CPP_BMN_PANIC_TEST
    );

    if threads == 1 {
        // If only one thread, run commands sequentially to ensure deterministic behavior
        run_extraction_commands_sequential(extractor, project_dir, commands)
    } else {
        let rayon_thread_pool = rayon::ThreadPoolBuilder::new().num_threads(threads).build();
        match rayon_thread_pool {
            Err(err) => {
                warning!("Failed to build thread pool: {err}");
                telemetry.write_message(
                    TelemetryMessage::new(
                        Severity::Warning,
                        "cpp/bmn/thread-pool-failure",
                        "Failed to build thread pool",
                    )
                    .plaintext_message(&format!("Failed to build thread pool: {err}")),
                );
                // We don't have a thread pool, so run sequentially
                run_extraction_commands_sequential(extractor, project_dir, commands)
            }
            Ok(thread_pool) => thread_pool.install(|| {
                commands
                    .par_iter()
                    .enumerate()
                    .map(|(idx, cmd)| {
                        run_extraction_command_get_status(extractor, project_dir, cmd, idx)
                    })
                    .collect()
            }),
        }
    }
}

pub fn perform_extraction_send_telemetry(
    telemetry: &Telemetry,
    threads: usize,
    extractor: &Path,
    project_dir: &Path,
    commands: &[ExtractionCommand],
) -> anyhow::Result<()> {
    let mut chrono = ExecuteAccumulateTime::default();
    let extraction_results: Vec<ExtractionResult> = chrono.execute_accumulate_time(|| {
        run_extraction_commands(telemetry, threads, extractor, project_dir, commands)
    });

    let extraction_stats = ExtractionStats::from(&extraction_results, chrono.total());

    extraction_stats.log();
    extraction_stats.debug();

    telemetry.write_message(
        TelemetryMessage::new(
            Severity::Note,
            "cpp/bmn/extraction-information",
            "Extraction information",
        )
        .attributes(extraction_stats.get_telemetry_value()),
    );

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::project_definitions::Language;
    use all_asserts::{assert_false, assert_true};
    use std::ffi::OsString;
    use std::path::PathBuf;
    use std::time::Duration;

    fn make_command(
        args: &[&str],
        duration: u64,
        status: &io::Result<ExitStatus>,
    ) -> ExtractionResult {
        ExtractionResult {
            command: ExtractionCommand {
                arguments: args.iter().map(OsString::from).collect(),
                source_file: SourceFile {
                    path: PathBuf::from(args.last().unwrap_or(&"<unknown>")),
                    language: Language::C,
                },
            },
            duration: Duration::from_secs(duration),
            extractor_exit_status: ExtractorExitStatus::from(status),
        }
    }

    #[allow(clippy::unnecessary_wraps)]
    fn fake_status(exit_code: i32) -> io::Result<ExitStatus> {
        use std::process::ExitStatus;
        #[cfg(unix)]
        {
            use std::os::unix::process::ExitStatusExt;
            Ok(ExitStatus::from_raw(exit_code << 8))
        }
        #[cfg(windows)]
        {
            use std::os::windows::process::ExitStatusExt;
            Ok(ExitStatus::from_raw(exit_code as u32))
        }
    }

    #[test]
    fn test_extractor_code_to_short_string() {
        assert_eq!(
            ExtractorExitStatus::ReturnCode(0).to_string(),
            "ExitCode: 0"
        );
        assert_eq!(
            ExtractorExitStatus::ReturnCode(1).to_string(),
            "ExitCode: 1"
        );
        assert_eq!(ExtractorExitStatus::Signalled.to_string(), "Signalled");
        assert_eq!(
            ExtractorExitStatus::RustCommandError(String::from("error")).to_string(),
            "RustCommandError: error"
        );
        assert_eq!(
            ExtractorExitStatus::RustCommandError(String::from("another error")).to_string(),
            "RustCommandError: another error"
        );
    }

    #[test]
    fn test_extractor_code_is_success_partial_failure() {
        assert_true!(ExtractorExitStatus::ReturnCode(0).is_success());
        assert_false!(ExtractorExitStatus::ReturnCode(1).is_success());
        assert_false!(ExtractorExitStatus::ReturnCode(3).is_success());

        assert_true!(ExtractorExitStatus::ReturnCode(3).is_partial());
        assert_false!(ExtractorExitStatus::ReturnCode(0).is_partial());
        assert_false!(ExtractorExitStatus::ReturnCode(1).is_partial());

        assert_true!(ExtractorExitStatus::ReturnCode(1).is_failure());
        assert_true!(ExtractorExitStatus::RustCommandError(String::from("error")).is_failure());
        assert_false!(ExtractorExitStatus::ReturnCode(0).is_failure());
        assert_false!(ExtractorExitStatus::ReturnCode(3).is_failure());
    }

    #[test]
    fn test_extractor_result_from_ok() {
        for i in 1..10 {
            let ok_status = fake_status(i);
            let result = ExtractorExitStatus::from(&ok_status);
            assert_eq!(result, ExtractorExitStatus::ReturnCode(i));
        }
    }

    #[cfg(unix)]
    #[test]
    fn test_extractor_result_from_signalled() {
        use std::os::unix::process::ExitStatusExt;
        let code = (1 << 8) + 0o177; // 0o177 indicates termination by signal
        let signalled_status = Ok(ExitStatus::from_raw(code));
        let result = ExtractorExitStatus::from(&signalled_status);
        assert_eq!(result, ExtractorExitStatus::Signalled);
    }

    #[test]
    fn test_extractor_result_from_err() {
        let err = Err(io::Error::other("fail"));
        let result = ExtractorExitStatus::from(&err);
        assert_eq!(
            result,
            ExtractorExitStatus::RustCommandError(String::from("fail"))
        );
    }

    #[test]
    fn test_all_success() {
        let results = vec![
            make_command(&["foo"], 2, &fake_status(0)),
            make_command(&["-l"], 3, &fake_status(0)),
        ];
        let extraction_stats = ExtractionStats::from(&results, Duration::from_secs(10));
        let telemetry = extraction_stats.get_telemetry_value();
        assert_eq!(telemetry["extraction_status"]["#total"], 2);
        assert_eq!(telemetry["extraction_status"]["#success"], 2);
        assert_eq!(telemetry["extraction_status"]["#partial"], 0);
        assert_eq!(telemetry["extraction_status"]["#errors"], 0);
        assert_true!(
            telemetry["slowest_extraction_time_seconds"]
                .as_f64()
                .expect("bad time")
                >= 2.0
        );
        let slowest_args = telemetry["slowest_extraction_args"]
            .as_array()
            .expect("bad args");
        assert_eq!(slowest_args, &vec![Value::String("-l".to_string())]);
        assert_true!(telemetry.get("extraction_errors").is_none());
    }

    #[test]
    fn test_partial_and_failure() {
        let results = vec![
            make_command(&["0"], 1, &fake_status(0)),
            make_command(&["1"], 1, &fake_status(1)),
            make_command(&["2"], 1, &fake_status(2)),
            make_command(&["3"], 1, &fake_status(3)),
            make_command(
                &["fail"],
                3,
                &Err(io::Error::new(io::ErrorKind::NotFound, "not found")),
            ),
        ];
        let extraction_stats = ExtractionStats::from(&results, Duration::from_secs(6));
        let telemetry = extraction_stats.get_telemetry_value();
        assert_eq!(telemetry["extraction_status"]["#total"], 5);
        assert_eq!(telemetry["extraction_status"]["#success"], 1);
        assert_eq!(telemetry["extraction_status"]["#partial"], 1);
        assert_eq!(telemetry["extraction_status"]["#errors"], 3);

        let all_counts = &telemetry["extraction_status"]["all_counts"];

        assert_true!(all_counts.is_object());
        assert_eq!(all_counts["ExitCode: 0"], 1);
        assert_eq!(all_counts["ExitCode: 1"], 1);
        assert_eq!(all_counts["ExitCode: 2"], 1);
        assert_eq!(all_counts["ExitCode: 3"], 1);
        assert_eq!(all_counts["RustCommandError: not found"], 1);

        assert_true!(telemetry["extraction_errors"].is_array());
        let errors = telemetry["extraction_errors"]
            .as_array()
            .expect("bad errors");
        assert_eq!(
            errors,
            &vec![
                serde_json::json!({
                    "error_time_seconds": 1.0,
                    "error_args": ["1"],
                    "failure_reason": "ExitCode: 1"
                }),
                serde_json::json!({
                    "error_time_seconds": 1.0,
                    "error_args": ["2"],
                    "failure_reason": "ExitCode: 2"
                }),
                serde_json::json!({
                    "error_time_seconds": 3.0,
                    "error_args": ["fail"],
                    "failure_reason": "RustCommandError: not found"
                })
            ]
        );
    }

    #[test]
    fn test_empty_results() {
        let results = vec![];
        let extraction_stats = ExtractionStats::from(&results, Duration::from_secs(0));
        let telemetry = extraction_stats.get_telemetry_value();
        assert_eq!(telemetry["extraction_status"]["#total"], 0);
        assert_eq!(telemetry["extraction_status"]["#success"], 0);
        assert_eq!(telemetry["extraction_status"]["#partial"], 0);
        assert_eq!(telemetry["extraction_status"]["#errors"], 0);
        assert_true!(telemetry.get("slowest_extraction_time_seconds").is_none());
    }
}
