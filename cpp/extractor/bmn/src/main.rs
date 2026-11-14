pub mod compiler;
pub mod dependency_installation;
pub mod directory_tree;
pub mod environment;
pub mod extraction_command_runner;
pub mod file_filter;
pub mod gnu_compiler_default_include_finder;
pub mod include_finder;
pub mod include_scanner;
pub mod logger;
pub mod overlays;
pub mod package_database;
mod path_utils;
pub mod project_definitions;
pub mod telemetry;
#[cfg(test)]
pub mod test_utils;
pub mod timing;

use crate::compiler::generate_extraction_commands;
use crate::environment::CODEQL_EXTRACTOR_CPP_DIAGNOSTIC_DIR;
use crate::file_filter::FileFilter;
use crate::include_finder::{
    InferredIncludes, find_system_header_files, infer_include_paths, send_folder_scan_telemetry,
};
use crate::logger::debug;
use crate::overlays::get_overlay_settings;
use crate::project_definitions::{SourceDirectory, is_header_file, is_source_file};
use crate::telemetry::{Severity, Telemetry, TelemetryMessage};
use anyhow::Result;
use dependency_installation::infer_and_install_dependencies;
use itertools::sorted;
use logger::{error, info, log};
use overlays::OverlaySettings;
use serde_json::json;
use std::cmp;
use std::collections::HashSet;
use std::env;
use std::env::consts::EXE_SUFFIX;
use std::fs::File;
use std::io::Write;
use std::panic;
use std::path::{Path, PathBuf};
use std::time::Instant;

/// Get the path to the C/C++ extractor executable.
fn get_extractor_executable() -> Result<PathBuf> {
    let root_dir = environment::get_required(environment::CODEQL_EXTRACTOR_CPP_ROOT)?;
    let platform = environment::get_required(environment::CODEQL_PLATFORM)?;

    let binary_name = format!("extractor{EXE_SUFFIX}");
    let extractor = PathBuf::from_iter([&root_dir, "tools", &platform, &binary_name]);
    if !extractor.exists() {
        Err(anyhow::anyhow!(
            "Extractor executable not found at: {:?}",
            extractor
        ))
    } else {
        Ok(extractor)
    }
}

#[allow(clippy::too_many_lines)]
fn extract_with_telemetry(telemetry: &Telemetry) -> Result<()> {
    let project_dir = env::current_dir()?;
    let log_dir = environment::get_required(environment::CODEQL_EXTRACTOR_CPP_LOG_DIR)?;

    let overlay_settings = get_overlay_settings()?;
    info!(
        "Overlay mode: {} (enabled: {})",
        overlay_settings.overlay_mode(),
        overlay_settings.is_enabled()
    );

    let number_of_cpus = num_cpus::get();
    let threads = cmp::max(
        environment::get_optional(environment::CODEQL_THREADS)
            .and_then(|s| s.parse().ok())
            .unwrap_or(number_of_cpus),
        1,
    );
    info!("Using {threads} threads for extraction");

    let extraction_commands_file = Path::new(&log_dir).join("extraction_commands.json");

    telemetry.write_message(TelemetryMessage::new(
        Severity::Note,
        "cpp/bmn/standalone-extraction-started",
        "Standalone extraction started",
    ));

    telemetry.write_message(
        TelemetryMessage::new(
            Severity::Note,
            "cpp/bmn/overlay-information",
            "Overlay information",
        )
        .attributes(serde_json::json!({
            "overlay_mode": overlay_settings.overlay_mode(),
            "overlay_support_enabled": overlay_settings.is_enabled()
        })),
    );

    telemetry.write_message(
        TelemetryMessage::new(
            Severity::Note,
            "cpp/bmn/platform-information",
            "Platform information",
        )
        .attributes(serde_json::json!({
            "arch": std::env::consts::ARCH,
            "family": std::env::consts::FAMILY,
            "os": std::env::consts::OS,
            "num_cpus": number_of_cpus
        })),
    );

    let file_filter = FileFilter::from_env_vars(&project_dir)?;

    let mut project = SourceDirectory::new(&project_dir, Some(&file_filter));

    // Log with info level the stats of the project being analyzed
    project.log_stats();

    // Emit telemetry for overlay file statistics
    if let OverlaySettings::Overlay { changed_files, .. } = &overlay_settings {
        info!("Overlay changes include {} file(s).", changed_files.len());

        let changed_source_resolution_time = project.retain_changed_files(changed_files);

        let changed_source_paths: HashSet<PathBuf> = changed_files
            .iter()
            .filter(|f| is_source_file(f))
            .map(|f| project_dir.join(f))
            .collect();
        let changed_sources = changed_source_paths.len();
        let changed_headers = changed_files.iter().filter(|f| is_header_file(f)).count();
        let other_files = changed_files.len() - changed_sources - changed_headers;
        let total_files_extracted = project.sources.len();
        let directly_changed = project
            .sources
            .iter()
            .filter(|s| changed_source_paths.contains(&s.path))
            .count();
        let sources_expanded_from_headers = total_files_extracted - directly_changed;

        telemetry.write_message(
            TelemetryMessage::new(
                Severity::Note,
                "cpp/bmn/overlay-file-statistics",
                "Overlay file statistics",
            )
            .attributes(serde_json::json!({
                "num_changed_files_total": changed_files.len(),
                "num_changed_files_sources": changed_sources,
                "num_changed_files_headers": changed_headers,
                "num_changed_files_other": other_files,
                "num_extractions_total": total_files_extracted,
                "num_extractions_listed_cli": directly_changed,
                "num_extractions_inferred": sources_expanded_from_headers,
                "changed_source_resolution_time_ms": changed_source_resolution_time.as_millis()
            })),
        );
    }

    if project.sources.is_empty() {
        return overlay_settings.is_overlay().then_some(()).ok_or_else(|| {
            telemetry.write_message(
                TelemetryMessage::new(
                    Severity::Error,
                    "cpp/bmn/standalone-extraction-failure",
                    "No source files found",
                )
                .plaintext_message("No source files found"),
            );
            anyhow::anyhow!("No source files found.")
        });
    }

    let compiler_config = {
        let found = compiler::find_compiler(telemetry)?;
        telemetry.write_message(
            TelemetryMessage::new(
                Severity::Note,
                "cpp/bmn/compiler-information",
                "Compiler information",
            )
            .attributes(found.telemetry),
        );
        found.config
    };

    // Create include finders and infer includes for each file
    debug!("Generating include paths.");
    let system = find_system_header_files(&compiler_config);
    let compiler_defaults = &compiler_config.compiler_default_includes;
    let mut inferred_includes: Vec<InferredIncludes> = project
        .sources
        .iter()
        .map(|file| infer_include_paths(&project.all_files, &system, compiler_defaults, file))
        .collect();

    // Install missing dependencies if enabled
    let dependency_installation_enabled =
        environment::get_bool(environment::CODEQL_EXTRACTOR_CPP_AUTOINSTALL_DEPENDENCIES)
            && environment::get_bool(
                environment::CODEQL_EXTRACTOR_CPP_BMN_EXPERIMENTAL_AUTOINSTALL_DEPENDENCIES,
            );

    // Re-generate extraction commands if dependencies were installed
    if dependency_installation_enabled {
        info!("Dependency resolution enabled.");

        let all_includes_missing = {
            let mut acc = HashSet::<PathBuf>::new();
            for inferred_include in &inferred_includes {
                acc.extend(inferred_include.unresolvable.iter().cloned());
            }
            sorted(acc).collect::<Vec<_>>()
        };

        let attributes = match infer_and_install_dependencies(&all_includes_missing) {
            Ok(mut result) => {
                const MAX_PACKAGE_LENGTH: usize = 10;

                if !result.installed_packages.is_empty() {
                    info!("Re-generating include paths after dependency installation.");
                    let system = find_system_header_files(&compiler_config);
                    inferred_includes = project
                        .sources
                        .iter()
                        .map(|file| {
                            infer_include_paths(
                                &project.all_files,
                                &system,
                                compiler_defaults,
                                file,
                            )
                        })
                        .collect();
                }

                // Truncate the package lists to avoid producing arbitrarily large telemetry
                result.installed_packages.truncate(MAX_PACKAGE_LENGTH);
                result.failed_packages.truncate(MAX_PACKAGE_LENGTH);

                serde_json::to_value(result).unwrap_or_else(|_| json!({}))
            }
            Err(msg) => {
                info!("Dependency installation failed: {}", msg);
                json!({ "dependencyInstallationError": msg })
            }
        };
        telemetry.write_message(
            TelemetryMessage::new(
                Severity::Note,
                "cpp/bmn/dependency-resolution",
                "Automatic installation of dependencies",
            )
            .attributes(attributes),
        );
    } else {
        info!("Dependency resolution not enabled.");
    }

    info!("Generating compilation commands.");
    let (extraction_commands, stats) =
        generate_extraction_commands(&compiler_config, &project, inferred_includes);

    send_folder_scan_telemetry(stats.get_telemetry_content(), telemetry);

    let json_str = serde_json::to_string_pretty(&extraction_commands)?;
    std::fs::write(&extraction_commands_file, json_str)?;

    debug!("Extraction commands written: {extraction_commands_file:?}");

    let skip_extraction =
        environment::get_bool(environment::CODEQL_EXTRACTOR_CPP_BMN_SKIP_EXTRACTION);

    if skip_extraction {
        info!("Extraction skipped (CODEQL_EXTRACTOR_CPP_BMN_SKIP_EXTRACTION=true)");
        let telemetry_file = Path::new(log_dir.as_str()).join("telemetry.json");
        telemetry.write_combined_to_file(&telemetry_file);
        debug!("Telemetry written: {telemetry_file:?}");
    } else {
        info!("Running extraction commands.");
        debug!(
            "Running {} commands in {} threads...",
            extraction_commands.len(),
            threads
        );

        let extractor = get_extractor_executable()?;
        extraction_command_runner::perform_extraction_send_telemetry(
            telemetry,
            threads,
            &extractor,
            &project_dir,
            &extraction_commands,
        )?;
    }

    if let OverlaySettings::Base { metadata_out } = overlay_settings {
        let mut file = File::create(metadata_out)?;
        file.write_all(b"TODO")?;
    }

    Ok(())
}

fn extract() -> bool {
    let start_time = Instant::now();

    let Some(diagnostic_dir) = environment::get_optional(CODEQL_EXTRACTOR_CPP_DIAGNOSTIC_DIR)
    else {
        error!("{CODEQL_EXTRACTOR_CPP_DIAGNOSTIC_DIR} not set");
        return false;
    };
    let telemetry = match Telemetry::new(diagnostic_dir) {
        Ok(t) => t,
        Err(err) => {
            error!("Failed to initialize telemetry: {err}");
            return false;
        }
    };

    let result = panic::catch_unwind(|| extract_with_telemetry(&telemetry));

    let standalone_extraction_time_seconds = start_time.elapsed().as_secs();

    match result {
        Ok(Ok(())) => {
            info!("Extraction completed successfully.");
            telemetry.write_message(
                TelemetryMessage::new(
                    Severity::Note,
                    "cpp/bmn/standalone-extraction-completed",
                    "Standalone extraction completed",
                )
                .attributes(serde_json::json!({
                    "standalone_extraction_time_seconds": standalone_extraction_time_seconds
                })),
            );
            true
        }
        Ok(Err(err)) => {
            let msg = format!("{err}");
            error!("Extraction failed: {msg}");
            telemetry.write_message(
                TelemetryMessage::new(
                    Severity::Error,
                    "cpp/bmn/standalone-extraction-failure",
                    "Standalone extraction failure",
                )
                .plaintext_message(&msg)
                .attributes(serde_json::json!({
                    "standalone_extraction_time_seconds": standalone_extraction_time_seconds
                })),
            );
            false
        }
        Err(panic_payload) => {
            let panic_msg = if let Some(s) = panic_payload.downcast_ref::<&str>() {
                *s
            } else if let Some(s) = panic_payload.downcast_ref::<String>() {
                s
            } else {
                "Unknown panic occurred"
            };

            error!("Panic occurred during extraction: {panic_msg}");
            telemetry.write_message(
                TelemetryMessage::new(
                    Severity::Error,
                    "cpp/bmn/panic",
                    "Panic occurred during extraction",
                )
                .plaintext_message(panic_msg)
                .attributes(serde_json::json!({
                    "standalone_extraction_time_seconds": standalone_extraction_time_seconds
                })),
            );
            false
        }
    }
}

fn main() {
    if !extract() {
        std::process::exit(1);
    }
}
