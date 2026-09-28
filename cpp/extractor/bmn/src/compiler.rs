use super::environment;
use super::extraction_command_runner::ExtractionCommand;
use super::gnu_compiler_default_include_finder::get_default_include_for_compiler_or_warn;
use super::include_finder::{AggregatedIncludeStats, InferredIncludes};
use super::logger::{debug, info, log, warning};
use super::project_definitions::{Language, SourceDirectory};
use super::telemetry::{Severity, Telemetry, TelemetryMessage};
use crate::directory_tree::all_files_in;
use anyhow::{Result, anyhow};
use os_str_bytes::OsStrBytes;
use std::collections::HashSet;
use std::ffi::OsStr;
use std::ffi::OsString;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::Duration;
use which::which;

/// Statistics collected during the extraction command creation process.
pub struct MakeCommandStatistics {
    performed_system_scan: bool,
    all_files_count: usize,
    sources_count: usize,
    explicit_headers_count: usize,
    total_duration: Duration,
    all_includes_missing: usize,
    include_directories_added: usize,
}

impl MakeCommandStatistics {
    /// Merges two statistics objects by summing timing fields, taking `performed_system_scan`, file
    /// counts, and include statistics from `stat_2`.
    pub fn merge(stat_1: &Self, stat_2: &Self) -> Self {
        MakeCommandStatistics {
            performed_system_scan: stat_2.performed_system_scan,
            all_files_count: stat_2.all_files_count,
            sources_count: stat_2.sources_count,
            explicit_headers_count: stat_2.explicit_headers_count,
            total_duration: stat_1.total_duration + stat_2.total_duration,
            all_includes_missing: stat_2.all_includes_missing,
            include_directories_added: stat_2.include_directories_added,
        }
    }

    /// Generates telemetry content for local and system folder (if any) scans.
    pub fn get_telemetry_content(self) -> serde_json::Value {
        if self.performed_system_scan {
            serde_json::json!({
                    "project_stats": { "#all_files": self.all_files_count,
                                       "#source_files": self.sources_count,
                                       "#header_files": self.explicit_headers_count, },
                    "folder_indexing_time_seconds": self.total_duration.as_secs_f32(),
                    "include_directories_added": self.include_directories_added,
                    "missing_includes": self.all_includes_missing,
            })
        } else {
            serde_json::json!({
                    "project_stats": { "#all_files": self.all_files_count,
                                       "#source_files": self.sources_count,
                                       "#header_files": self.explicit_headers_count, },
                    "folder_indexing_time_seconds": self.total_duration.as_secs_f32(),
                    "missing_includes": self.all_includes_missing,
            })
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Compiler {
    Clang,
    Gnu,
    Msvc,
}

impl Compiler {
    fn name(self) -> &'static str {
        match self {
            Compiler::Clang => "Clang",
            Compiler::Gnu => "GNU",
            Compiler::Msvc => "MSVC",
        }
    }
    fn version_flag(self) -> &'static str {
        match self {
            Compiler::Clang => "-dumpversion",
            Compiler::Gnu => "-dumpfullversion",
            Compiler::Msvc => "",
        }
    }
}

/// Represents the compiler family for platform-specific flag handling.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CompilerFamily {
    Posix,
    Msvc,
}

/// Struct used to check if an include directive is satisfied by the compiler's default include
/// folders
#[derive(Clone, Debug, Default)]
pub struct CompilerDefaultIncludes {
    // Each of those is a set of relative paths (to the containing folder root) which correspond to
    // includes that are satisfied by default folders
    default_c_include_dir_content: HashSet<PathBuf>,
    default_cpp_include_dir_content: HashSet<PathBuf>,
}

impl CompilerDefaultIncludes {
    pub fn new(c_default_folders: &[PathBuf], cpp_default_folders: &[PathBuf]) -> Self {
        Self {
            default_c_include_dir_content: compute_include_files(c_default_folders),
            default_cpp_include_dir_content: compute_include_files(cpp_default_folders),
        }
    }

    /// Create a new instance by querying the compiler for its default include folders and log if
    /// there is a failure getting them.
    fn from(telemetry: &Telemetry, c_compiler: &OsStr, cpp_compiler: &OsStr) -> Self {
        let c_default_folders =
            get_default_include_for_compiler_or_warn(telemetry, c_compiler, Language::C);
        let cpp_default_folders =
            get_default_include_for_compiler_or_warn(telemetry, cpp_compiler, Language::Cpp);
        Self::new(&c_default_folders, &cpp_default_folders)
    }

    /// For the given language, get the set of include paths that are satisfied by header files in
    /// the compilers default search path.
    pub fn defaults_for(&self, language: Language) -> &HashSet<PathBuf> {
        match language {
            Language::C => &self.default_c_include_dir_content,
            Language::Cpp => &self.default_cpp_include_dir_content,
        }
    }
}

/// Compiler configuration used to generate extraction commands.
#[derive(Debug, Clone)]
pub struct CompilerConfig {
    pub family: CompilerFamily,
    pub mimic_c_flags: Vec<OsString>,
    pub mimic_cpp_flags: Vec<OsString>,
    pub compiler_default_includes: CompilerDefaultIncludes,
}

impl CompilerConfig {
    /// Generates a complete extraction command for a source file with its inferred includes.
    fn make_extraction_command(
        &self,
        file: &super::project_definitions::SourceFile,
        include_dirs: &[PathBuf],
    ) -> ExtractionCommand {
        let mut args = match (self.family, file.language) {
            (CompilerFamily::Posix, Language::C) => self.mimic_c_flags.clone(),
            (CompilerFamily::Posix, Language::Cpp) => {
                let mut a = self.mimic_cpp_flags.clone();
                a.extend(vec![
                    OsString::from("-std=c++17"),
                    OsString::from("-fexceptions"),
                    OsString::from("-Xcodeql"),
                    OsString::from("--pending_instantiations"),
                    OsString::from("-Xcodeql"),
                    OsString::from("512"),
                ]);
                a
            }
            (CompilerFamily::Msvc, Language::C) => {
                let mut a = self.mimic_c_flags.clone();
                a.push(OsString::from("/Zs"));
                a
            }
            (CompilerFamily::Msvc, Language::Cpp) => {
                let mut a = self.mimic_cpp_flags.clone();
                a.extend(vec![
                    OsString::from("/std:c++latest"),
                    OsString::from("/Zs"),
                    OsString::from("/EHs"),
                    OsString::from("/permissive"),
                ]);
                a
            }
        };

        let include_flag = match self.family {
            CompilerFamily::Posix => "-I",
            CompilerFamily::Msvc => "/I",
        };
        args.extend(include_dirs.iter().map(|p| {
            let mut flag = OsString::from(include_flag);
            flag.push(p);
            flag
        }));

        if self.family == CompilerFamily::Posix {
            args.push(OsString::from("-c"));
        }
        args.push(file.path.as_os_str().to_owned());

        ExtractionCommand::new(args, file)
    }
}

pub fn compute_include_files(dirs: &[PathBuf]) -> HashSet<PathBuf> {
    dirs.iter()
        .filter_map(|d| d.canonicalize().ok())
        .flat_map(|dir| {
            all_files_in(&dir)
                .into_iter()
                // Strip `dir` from `files`
                .filter_map(move |file| file.strip_prefix(&dir).ok().map(Path::to_path_buf))
        })
        .collect()
}

fn get_compiler_version(compiler: Compiler, command: &OsStr) -> Option<(OsString, String)> {
    let version_flag = compiler.version_flag();
    info!("Searching for {:?}...", command);
    let command_path = if let Ok(path) = which(command) {
        path.as_os_str().to_owned()
    } else {
        info!("Command {:?} not found.", command);
        return None;
    };
    info!("Found {:?} at: {:?}", command, command_path);
    let version = if let Ok(output) = Command::new(&command_path).arg(version_flag).output() {
        output.stdout
    } else {
        warning!("Failed to get {:?} version.", command);
        return None;
    };
    Some((
        command_path,
        String::from_utf8_lossy(&version).trim().to_string(),
    ))
}

fn log_include_scan_stats(stats: &MakeCommandStatistics, dirs_added: &HashSet<PathBuf>) {
    debug!(
        "Resolved includes in {} seconds",
        stats.total_duration.as_secs_f32()
    );

    debug!(
        "Added {} include directories",
        stats.include_directories_added
    );

    for f in dirs_added {
        debug!("  {:?}", f);
    }

    debug!("{} includes still missing", stats.all_includes_missing);
}

/// Generates extraction commands from pre-computed inferred includes.
pub fn generate_extraction_commands(
    compiler_config: &CompilerConfig,
    source_dir: &SourceDirectory,
    inferred_includes: Vec<InferredIncludes>,
) -> (Vec<ExtractionCommand>, MakeCommandStatistics) {
    let commands = source_dir
        .sources
        .iter()
        .zip(inferred_includes.iter())
        .map(|(file, inferred)| {
            compiler_config.make_extraction_command(file, &inferred.include_directories)
        })
        .collect();

    let aggregated_stats = inferred_includes.into_iter().fold(
        AggregatedIncludeStats::default(),
        AggregatedIncludeStats::aggregate,
    );

    let (all_files_count, sources_count, explicit_headers_count) = source_dir.get_stats();

    let stats = MakeCommandStatistics {
        performed_system_scan: compiler_config.family == CompilerFamily::Posix,
        all_files_count,
        sources_count,
        explicit_headers_count,
        total_duration: aggregated_stats.total_duration,
        all_includes_missing: aggregated_stats.all_includes_missing.len(),
        include_directories_added: aggregated_stats.include_directories_added.len(),
    };

    log_include_scan_stats(&stats, &aggregated_stats.include_directories_added);

    (commands, stats)
}

pub struct FoundCompiler {
    pub telemetry: serde_json::Value,
    pub config: CompilerConfig,
}

fn find_posix(
    telemetry: &Telemetry,
    kind: Compiler,
    name: &OsStr,
    namepp: &OsStr,
) -> Option<FoundCompiler> {
    let (command_path, command_version) = get_compiler_version(kind, name)?;
    let (commandpp_path, commandpp_version) = get_compiler_version(kind, namepp)?;

    let mimic_c_flags = vec![OsString::from("--mimic"), command_path.clone()];
    let mimic_cpp_flags = vec![OsString::from("--mimic"), commandpp_path.clone()];

    let default_compiler_include_checker = CompilerDefaultIncludes::from(telemetry, name, namepp);

    let name = kind.name();
    Some(FoundCompiler {
        telemetry: serde_json::json!({
            "family": name,
            format!("{name} C compiler version"): command_version,
            format!("{name} C++ compiler version"): commandpp_version,
        }),
        config: CompilerConfig {
            family: CompilerFamily::Posix,
            mimic_c_flags,
            mimic_cpp_flags,
            compiler_default_includes: default_compiler_include_checker,
        },
    })
}

fn find_clang(telemetry: &Telemetry) -> Option<FoundCompiler> {
    find_posix(
        telemetry,
        Compiler::Clang,
        OsStr::new("clang"),
        OsStr::new("clang++"),
    )
}

fn find_gcc(telemetry: &Telemetry) -> Option<FoundCompiler> {
    find_posix(
        telemetry,
        Compiler::Gnu,
        OsStr::new("gcc"),
        OsStr::new("g++"),
    )
}

fn find_msvc(_telemetry: &Telemetry) -> Option<FoundCompiler> {
    info!("Searching for msvc...");
    find_cl().or_else(find_cl_with_vswhere)
}

fn use_cl(command: &OsStr) -> Option<FoundCompiler> {
    info!("Searching for cl as {command:?}...");
    let command_path = if let Ok(path) = which(command) {
        path.as_os_str().to_owned()
    } else {
        info!("Command {command:?} not found.");
        return None;
    };

    Some(FoundCompiler {
        telemetry: serde_json::json!({
            "family": Compiler::Msvc.name(),
        }),
        config: CompilerConfig {
            family: CompilerFamily::Msvc,
            mimic_c_flags: vec![OsString::from("--mimic"), command_path.clone()],
            mimic_cpp_flags: vec![OsString::from("--mimic"), command_path],
            compiler_default_includes: CompilerDefaultIncludes::default(),
        },
    })
}

fn find_cl() -> Option<FoundCompiler> {
    info!("Searching for cl...");
    use_cl(OsStr::new("cl"))
}

fn find_cl_with_vswhere() -> Option<FoundCompiler> {
    info!("Searching for vswhere...");
    let vswhere_command = "vswhere";
    let vswhere_command_path = if let Ok(path) = which(vswhere_command) {
        path
    } else {
        info!("Command {vswhere_command} not found on the path.");
        let env_program_files_x86 = "ProgramFiles(x86)";
        if let Some(program_files_x86) = std::env::var_os(env_program_files_x86) {
            let mut vswhere_path = PathBuf::from(&program_files_x86);
            vswhere_path.push("Microsoft Visual Studio");
            vswhere_path.push("Installer");
            vswhere_path.push("vswhere.exe");
            if vswhere_path.exists() {
                vswhere_path
            } else {
                warning!("Failed to find vswhere.exe at {:?}", vswhere_path);
                return None;
            }
        } else {
            info!("Env var {} not set.", env_program_files_x86);
            return None;
        }
    };

    info!("Using vswhere at {:?}", vswhere_command_path);
    let install_dir: Vec<u8> = if let Ok(output) = Command::new(&vswhere_command_path)
        .arg("-latest")
        .arg("-products")
        .arg("*")
        .arg("-requires")
        .arg("Microsoft.VisualStudio.Component.VC.Tools.x86.x64")
        .arg("-property")
        .arg("installationPath")
        .output()
    {
        output.stdout.trim_ascii_end().to_vec()
    } else {
        warning!("Failed to get installationPath.");
        return None;
    };
    let mut install_path = PathBuf::new();
    if let Some(install_dir2) = OsStr::from_io_bytes(&install_dir) {
        install_path.push(install_dir2);
    } else {
        warning!(
            "Failed to convert installation path to OsString: {:?}",
            install_dir
        );
        return None;
    }
    let default_txt_path = install_path
        .join("VC")
        .join("Auxiliary")
        .join("Build")
        .join("Microsoft.VCToolsVersion.default.txt");
    if !default_txt_path.exists() {
        warning!(
            "Failed to find Microsoft.VCToolsVersion.default.txt at {:?}",
            default_txt_path
        );
        return None;
    }
    let Ok(version) = std::fs::read_to_string(&default_txt_path) else {
        warning!(
            "Failed to read Microsoft.VCToolsVersion.default.txt at {:?}",
            default_txt_path
        );
        return None;
    };
    info!("Found MSVC version: {}", version);
    let cl_path = install_path
        .join("VC")
        .join("Tools")
        .join("MSVC")
        .join(version.trim())
        .join("bin")
        .join("Hostx64")
        .join("x64")
        .join("cl.exe");
    use_cl(cl_path.as_os_str())
}

/// Construct a fallback compiler.
///
/// This function will always return `Some(...)`, but is using the `Option` type
/// to have the same signature as other compiler constructions.
#[allow(clippy::unnecessary_wraps)]
fn fallback_msvc(_telemetry: &Telemetry) -> Option<FoundCompiler> {
    info!("Using msvc fallback compiler.");
    Some(FoundCompiler {
        telemetry: serde_json::json!({
            "family": "mimic-cl",
        }),
        config: CompilerConfig {
            family: CompilerFamily::Msvc,
            mimic_c_flags: vec![OsString::from("--mimic-cl")],
            mimic_cpp_flags: vec![OsString::from("--mimic-cl")],
            compiler_default_includes: CompilerDefaultIncludes::default(),
        },
    })
}

/// Construct a fallback compiler.
///
/// This function will always return `Some(...)`, but is using the `Option` type
/// to have the same signature as other compiler constructions.
#[allow(clippy::unnecessary_wraps)]
fn fallback_clang(_telemetry: &Telemetry) -> Option<FoundCompiler> {
    info!("Using clang fallback compiler.");
    Some(FoundCompiler {
        telemetry: serde_json::json!({
            "family": "mimic-clang",
        }),
        config: CompilerConfig {
            family: CompilerFamily::Posix,
            mimic_c_flags: vec![OsString::from("--mimic-clang")],
            mimic_cpp_flags: vec![OsString::from("--mimic-clang")],
            compiler_default_includes: CompilerDefaultIncludes::default(),
        },
    })
}

fn get_compiler_override(
    telemetry: &Telemetry,
    override_instruction: &OsStr,
) -> Result<FoundCompiler> {
    if override_instruction == "fallback clang" {
        Ok(fallback_clang(telemetry).expect("fallback always succeeds"))
    } else if override_instruction == "fallback msvc" {
        Ok(fallback_msvc(telemetry).expect("fallback always succeeds"))
    } else if override_instruction == "clang" {
        // These can be just a command name, e.g. "clang-18", or a full path, e.g.
        // "/usr/bin/clang-18"
        let clang_c_compiler =
            environment::get_required_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_C)?;
        let clang_cpp_compiler =
            environment::get_required_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_CPP)?;
        find_posix(
            telemetry,
            Compiler::Clang,
            &clang_c_compiler,
            &clang_cpp_compiler,
        )
        .ok_or(anyhow!(
            "Could not find clang compilers: {clang_c_compiler:?}, {clang_cpp_compiler:?}"
        ))
    } else if override_instruction == "gnu" {
        // These can be just a command name, e.g. "gcc-18", or a full path, e.g.
        // "/usr/bin/gcc-18"
        let gnu_c_compiler =
            environment::get_required_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_C)?;
        let gnu_cpp_compiler =
            environment::get_required_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_CPP)?;
        find_posix(telemetry, Compiler::Gnu, &gnu_c_compiler, &gnu_cpp_compiler).ok_or(anyhow!(
            "Could not find gnu compilers: {gnu_c_compiler:?}, {gnu_cpp_compiler:?}"
        ))
    } else if override_instruction == "msvc" {
        // These can be just a command name, e.g. "cl", or a full path, e.g.
        // "c:\msvc\cl.exe"
        let msvc_compiler =
            environment::get_required_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER_MSVC)?;
        use_cl(&msvc_compiler).ok_or(anyhow!("Could not find msvc compiler: {msvc_compiler:?}"))
    } else {
        Err(anyhow!(
            "Unsupported compiler override instruction: {override_instruction:?}"
        ))
    }
}

pub fn find_compiler(telemetry: &Telemetry) -> Result<FoundCompiler> {
    if let Some(override_instruction) =
        environment::get_optional_os(environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER)
    {
        info!(
            "Using compiler override from {}: {:?}",
            environment::CODEQL_EXTRACTOR_CPP_BMN_COMPILER,
            override_instruction
        );
        return get_compiler_override(telemetry, &override_instruction);
    }

    let unix_finders = vec![find_clang, find_gcc, fallback_clang];
    let windows_finders = vec![find_msvc, find_clang, find_gcc, fallback_msvc];
    let finders = match std::env::consts::FAMILY {
        "unix" => unix_finders,
        "windows" => windows_finders,
        family => {
            warning!("Unexpected operating system family {family}.");
            telemetry.write_message(
                TelemetryMessage::new(
                    Severity::Warning,
                    "cpp/bmn/unexpected-operating-system-family",
                    "Unexpected operating system family",
                )
                .attributes(serde_json::json!({
                    "family": family,
                })),
            );
            unix_finders // Behave like Linux by default
        }
    };
    finders
        .iter()
        .find_map(|finder| finder(telemetry))
        .ok_or_else(|| anyhow!("No compiler found"))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_utils::create_populate_tmp_dir;
    use all_asserts::assert_true;

    #[test]
    fn test_indexing_compiler_default_folders() {
        let tmp_dir = create_populate_tmp_dir();
        let dirname = tmp_dir.path().to_path_buf();

        let include_finder = CompilerDefaultIncludes::new(&[dirname.clone()], &[dirname]);
        let default_c_include_dir_content = &include_finder.default_c_include_dir_content;
        let default_cpp_include_dir_content = &include_finder.default_cpp_include_dir_content;

        assert_eq!(default_c_include_dir_content.len(), 3);

        assert_true!(default_c_include_dir_content.contains(&PathBuf::from("sub1/file1.h")));
        assert_true!(default_c_include_dir_content.contains(&PathBuf::from("sub2/file2.hpp")));
        assert_true!(default_c_include_dir_content.contains(&PathBuf::from("root.h")));

        assert_eq!(
            default_c_include_dir_content,
            default_cpp_include_dir_content
        );
    }
}
