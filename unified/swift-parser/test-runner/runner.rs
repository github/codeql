use std::collections::BTreeSet;
use std::fmt::Write;
use std::fs;
use std::num::NonZeroUsize;
use std::path::{Path, PathBuf};
use std::process::Command;

use clap::Parser;
use serde::Deserialize;
use serde_json::Value;

#[path = "snapshot.rs"]
mod snapshot;

#[derive(Parser)]
#[command(about = "Compare the native Swift parser with the SwiftSyntax oracle")]
pub(crate) struct Options {
    /// Fixture name relative to test-fixtures, with or without .swift. Repeatable.
    #[arg(long, value_name = "NAME")]
    fixture: Vec<String>,

    /// Corpus repository slug, e.g. signalapp/Signal-iOS. Repeatable.
    #[arg(long, value_name = "OWNER/REPO")]
    project: Vec<String>,

    /// Select corpus source paths relative to each checkout. Repeatable.
    #[arg(
        long,
        value_name = "PATH",
        requires = "project",
        conflicts_with = "project_start_at"
    )]
    project_file: Vec<PathBuf>,

    /// Start corpus comparison at this checkout-relative path, inclusively.
    #[arg(long, value_name = "PATH", requires = "project")]
    project_start_at: Option<PathBuf>,

    /// Stop each project after this many syntax-tree mismatches.
    #[arg(long, default_value = "1")]
    max_project_failures: NonZeroUsize,

    /// Print mismatch locations without writing snapshots or running git diff.
    #[arg(long)]
    no_failure_artifacts: bool,

    /// Run all fixtures, without cloning corpus projects.
    #[arg(long, conflicts_with_all = ["project", "corpus_only"])]
    fixtures_only: bool,

    /// Run all corpus projects, without running fixtures.
    #[arg(long, conflicts_with_all = ["fixture", "fixtures_only"])]
    corpus_only: bool,

    /// Regenerate reference output in memory and check existing JSON against it.
    #[arg(long)]
    check_json: bool,

    /// Prepare reference JSON without testing the native parser.
    #[arg(long)]
    generate_only: bool,

    /// Use this swift-syntax-parse executable instead of building one lazily.
    #[arg(long, value_name = "EXECUTABLE")]
    swift_syntax_parser: Option<PathBuf>,

    #[arg(long, value_name = "DIRECTORY")]
    fixtures_dir: Option<PathBuf>,

    #[arg(long, value_name = "FILE")]
    corpus_file: Option<PathBuf>,

    /// Location for pinned checkouts, corpus JSON, and mismatch artifacts.
    #[arg(long, value_name = "DIRECTORY")]
    cache_dir: Option<PathBuf>,

    /// Maximum number of diff lines printed per failure; artifacts are complete.
    #[arg(long, default_value_t = 80)]
    diff_lines: usize,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Corpus {
    version: u32,
    projects: Vec<Project>,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Project {
    slug: String,
    sha: String,
}

struct Case {
    name: PathBuf,
    source: PathBuf,
    json: PathBuf,
}

enum Comparison {
    Match,
    Invalid(&'static str),
    Mismatch(String),
}

struct Oracle {
    executable: Option<PathBuf>,
    build_error: Option<String>,
    workspace: PathBuf,
}

impl Oracle {
    fn parse(&mut self, source: &Path) -> Result<String, String> {
        if let Some(error) = &self.build_error {
            return Err(error.clone());
        }
        if self.executable.is_none() {
            match self.build() {
                Ok(executable) => self.executable = Some(executable),
                Err(error) => {
                    self.build_error = Some(error.clone());
                    return Err(error);
                }
            }
        }
        let executable = self.executable.as_ref().unwrap();
        let output = Command::new(executable)
            .arg(source)
            .output()
            .map_err(|error| format!("could not run {}: {error}", executable.display()))?;
        if !output.status.success() {
            return Err(format!(
                "{} failed ({}):\n{}",
                executable.display(),
                output.status,
                String::from_utf8_lossy(&output.stderr)
            ));
        }
        String::from_utf8(output.stdout)
            .map_err(|error| format!("reference parser returned invalid UTF-8: {error}"))
    }

    fn build(&self) -> Result<PathBuf, String> {
        eprintln!("Building swift-syntax-parse for reference JSON...");
        let package = self.workspace.join("unified/swift-parser/oracle");
        let mut command = Command::new("swift");
        command
            .current_dir(&package)
            .args(["build", "-c", "release", "--product", "swift-syntax-parse"])
            .stdout(std::process::Stdio::inherit())
            .stderr(std::process::Stdio::inherit());
        if std::env::var("GIT_CONFIG_KEY_0").as_deref() == Ok("safe.bareRepository") {
            command.env("GIT_CONFIG_VALUE_0", "all");
        }
        let status = command
            .status()
            .map_err(|error| format!("could not build swift-syntax-parse: {error}"))?;
        if !status.success() {
            return Err("building swift-syntax-parse failed; check the Swift toolchain or use --swift-syntax-parser".into());
        }
        Ok(package.join(".build/release/swift-syntax-parse"))
    }
}

struct Runner<'a> {
    options: &'a Options,
    cache: PathBuf,
    oracle: Oracle,
    passed: usize,
    failed: usize,
    generated: usize,
    skipped: usize,
}

impl Runner<'_> {
    fn case(&mut self, case: &Case, corpus: bool) -> bool {
        let result = self.compare(case, corpus);
        match &result {
            Ok(Comparison::Match) => {
                self.passed += 1;
                let label = if self.options.generate_only {
                    "REFERENCE"
                } else {
                    "PASS"
                };
                eprintln!("{label} {}", case.name.display());
            }
            Ok(Comparison::Invalid(reason)) => {
                self.skipped += 1;
                eprintln!("SKIP {}: {reason}", case.name.display());
            }
            Ok(Comparison::Mismatch(error)) | Err(error) => {
                self.failed += 1;
                eprintln!("FAIL {}\n{error}\n", case.name.display());
            }
        }
        matches!(result, Ok(Comparison::Mismatch(_)))
    }

    fn compare(&mut self, case: &Case, corpus: bool) -> Result<Comparison, String> {
        let source = match fs::read_to_string(&case.source) {
            Ok(source) => source,
            Err(error) if corpus && error.kind() == std::io::ErrorKind::InvalidData => {
                return Ok(Comparison::Invalid(
                    "invalid UTF-8 source (neither parser frontend accepts this encoding)",
                ));
            }
            Err(error) => return Err(format!("{}: {error}", case.source.display())),
        };
        let mut live_reference = if case.json.exists() {
            None
        } else {
            let json = self.oracle.parse(&case.source)?;
            let mut deserializer = serde_json::Deserializer::from_str(&json);
            deserializer.disable_recursion_limit();
            let value = Value::deserialize(&mut deserializer).map_err(|error| error.to_string())?;
            deserializer.end().map_err(|error| error.to_string())?;
            if create_reference(&case.json, &value)? {
                self.generated += 1;
                eprintln!("GENERATED {}", case.json.display());
            }
            Some(json)
        };
        let cached = fs::read_to_string(&case.json)
            .map_err(|error| format!("{}: {error}", case.json.display()))?;
        if corpus && !self.options.generate_only {
            let has_error = if let Some(has_error) = Self::reference_has_errors(&cached)? {
                has_error
            } else {
                // Older caches omit missing tokens, so their tree cannot establish validity.
                let live = self.oracle.parse(&case.source)?;
                let has_error = Self::reference_has_errors(&live)?
                    .ok_or("reference parser omitted `$hasError`; rebuild swift-syntax-parse")?;
                live_reference = Some(live);
                has_error
            };
            if has_error {
                return Ok(Comparison::Invalid("swift-syntax reports syntax errors"));
            }
        }
        let expected = snapshot::reference(&cached, &source)
            .map_err(|error| format!("invalid reference {}: {error}", case.json.display()))?;
        if self.options.check_json {
            let live = match live_reference {
                Some(json) => json,
                None => self.oracle.parse(&case.source)?,
            };
            let live = snapshot::reference(&live, &source)?;
            if expected != live {
                return Ok(Comparison::Mismatch(self.mismatch(
                    case,
                    "cached JSON disagrees with live swift-syntax (JSON was not overwritten)",
                    &source,
                    &expected,
                    &live,
                )?));
            }
        }
        if !self.options.generate_only {
            let actual = snapshot::candidate(&source);
            if expected != actual {
                return Ok(Comparison::Mismatch(self.mismatch(
                    case,
                    "Rust parser disagrees with swift-syntax",
                    &source,
                    &expected,
                    &actual,
                )?));
            }
        }
        Ok(Comparison::Match)
    }

    fn reference_has_errors(json: &str) -> Result<Option<bool>, String> {
        #[derive(Deserialize)]
        struct Metadata {
            #[serde(rename = "$hasError")]
            has_error: Option<bool>,
        }

        let mut deserializer = serde_json::Deserializer::from_str(json);
        deserializer.disable_recursion_limit();
        let metadata =
            Metadata::deserialize(&mut deserializer).map_err(|error| error.to_string())?;
        deserializer.end().map_err(|error| error.to_string())?;
        Ok(metadata.has_error)
    }

    fn mismatch(
        &self,
        case: &Case,
        reason: &str,
        source: &str,
        expected: &Value,
        actual: &Value,
    ) -> Result<String, String> {
        let difference =
            first_difference(expected, actual, String::new()).unwrap_or_else(|| "/".into());
        let mut message = format!(
            "{reason}\nSource: {}\nReference JSON: {}\nFirst difference: {difference}\n",
            case.source.display(),
            case.json.display()
        );
        if let Some(error) = actual.get("parse_error").or_else(|| actual.get("panic")) {
            writeln!(message, "Native parser error: {error}").unwrap();
        }
        let components: Vec<_> = difference.split('/').collect();
        let row = components
            .get(2)
            .and_then(|index| index.parse::<usize>().ok())
            .and_then(|index| {
                expected
                    .get(*components.get(1)?)
                    .and_then(|tree| tree.get(index))
            })
            .and_then(|node| node["range"]["start_point"]["row"].as_u64())
            .and_then(|row| usize::try_from(row).ok())
            .unwrap_or(0);
        for (index, line) in source
            .replace("\r\n", "\n")
            .replace('\r', "\n")
            .lines()
            .enumerate()
            .skip(row.saturating_sub(2))
            .take(5)
        {
            writeln!(message, "{:>5} | {line}", index + 1).unwrap();
        }
        if self.options.no_failure_artifacts {
            for (label, snapshot) in [("Expected", expected), ("Actual", actual)] {
                if let Some(value) = snapshot.pointer(&difference)
                    && !(value.is_array() || value.is_object())
                {
                    let preview: String = value.to_string().chars().take(200).collect();
                    writeln!(message, "{label}: {preview}").unwrap();
                }
            }
            return Ok(message);
        }
        let base = self.cache.join("failures").join(&case.name);
        let expected_path = base.with_extension("expected.json");
        let actual_path = base.with_extension("actual.json");
        write_json(&expected_path, expected)?;
        write_json(&actual_path, actual)?;
        let diff = Command::new("git")
            .args(["diff", "--no-index", "--no-color", "--"])
            .arg(&expected_path)
            .arg(&actual_path)
            .output()
            .map_err(|error| format!("could not produce diff: {error}"))?;
        let diff = String::from_utf8_lossy(&diff.stdout);
        let diff_path = base.with_extension("diff");
        fs::write(&diff_path, diff.as_bytes()).map_err(|error| error.to_string())?;
        let preview = diff
            .lines()
            .take(self.options.diff_lines)
            .collect::<Vec<_>>()
            .join("\n");
        write!(
            message,
            "{preview}\nExpected: {}\nActual: {}\nFull diff: {}",
            expected_path.display(),
            actual_path.display(),
            diff_path.display()
        )
        .unwrap();
        Ok(message)
    }
}

fn first_difference(expected: &Value, actual: &Value, path: String) -> Option<String> {
    if expected == actual {
        return None;
    }
    match (expected, actual) {
        (Value::Object(expected), Value::Object(actual)) => {
            for key in expected.keys().chain(actual.keys()) {
                let child = format!("{path}/{}", key.replace('~', "~0").replace('/', "~1"));
                match (expected.get(key), actual.get(key)) {
                    (Some(expected), Some(actual)) => {
                        if let Some(difference) = first_difference(expected, actual, child) {
                            return Some(difference);
                        }
                    }
                    _ => return Some(child),
                }
            }
        }
        (Value::Array(expected), Value::Array(actual)) => {
            for (index, (expected, actual)) in expected.iter().zip(actual).enumerate() {
                if let Some(difference) =
                    first_difference(expected, actual, format!("{path}/{index}"))
                {
                    return Some(difference);
                }
            }
            return Some(format!("{path}/length"));
        }
        _ => {}
    }
    Some(path)
}

fn write_json(path: &Path, value: &Value) -> Result<(), String> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).map_err(|error| error.to_string())?;
    }
    let json = serde_json::to_string_pretty(value).map_err(|error| error.to_string())?;
    fs::write(path, format!("{json}\n")).map_err(|error| format!("{}: {error}", path.display()))
}

fn create_reference(path: &Path, value: &Value) -> Result<bool, String> {
    use std::io::Write as _;

    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).map_err(|error| error.to_string())?;
    }
    let json = serde_json::to_string_pretty(value).map_err(|error| error.to_string())?;
    let mut file = match fs::OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
    {
        Ok(file) => file,
        Err(error) if error.kind() == std::io::ErrorKind::AlreadyExists => return Ok(false),
        Err(error) => return Err(format!("{}: {error}", path.display())),
    };
    writeln!(file, "{json}").map_err(|error| format!("{}: {error}", path.display()))?;
    Ok(true)
}

fn swift_files(root: &Path) -> Result<Vec<PathBuf>, String> {
    let mut files = Vec::new();
    let mut pending = vec![root.to_path_buf()];
    while let Some(directory) = pending.pop() {
        for entry in
            fs::read_dir(&directory).map_err(|error| format!("{}: {error}", directory.display()))?
        {
            let entry = entry.map_err(|error| error.to_string())?;
            let kind = entry.file_type().map_err(|error| error.to_string())?;
            if kind.is_dir() && entry.file_name() != ".git" {
                pending.push(entry.path());
            } else if kind.is_file() && entry.path().extension().is_some_and(|ext| ext == "swift") {
                files.push(entry.path());
            }
        }
    }
    files.sort();
    Ok(files)
}

fn git(directory: &Path, args: &[&str]) -> Result<String, String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(directory)
        .args(args)
        .output()
        .map_err(|error| error.to_string())?;
    if !output.status.success() {
        return Err(format!(
            "git {} in {} failed ({}):\n{}",
            args.join(" "),
            directory.display(),
            output.status,
            String::from_utf8_lossy(&output.stderr)
        ));
    }
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_owned())
}

fn checkout(project: &Project, cache: &Path) -> Result<PathBuf, String> {
    let directory = cache.join("sources").join(&project.slug).join(&project.sha);
    let remote = format!("https://github.com/{}.git", project.slug);
    if !directory.exists() {
        eprintln!("CHECKOUT {}@{}", project.slug, project.sha);
        fs::create_dir_all(&directory).map_err(|error| error.to_string())?;
        git(&directory, &["init", "--quiet"])?;
        git(&directory, &["remote", "add", "origin", &remote])?;
    }
    if git(&directory, &["rev-parse", "--verify", "HEAD"]).is_err() {
        if git(&directory, &["remote", "get-url", "origin"])? != remote
            || !git(&directory, &["status", "--porcelain"])?.is_empty()
        {
            return Err(format!(
                "{} is not a clean, incomplete corpus checkout; refusing to change it",
                directory.display()
            ));
        }
        git(
            &directory,
            &["fetch", "--quiet", "--depth=1", "origin", &project.sha],
        )?;
        git(
            &directory,
            &["checkout", "--quiet", "--detach", &project.sha],
        )?;
    }
    let head = git(&directory, &["rev-parse", "HEAD"])?;
    if head != project.sha {
        return Err(format!(
            "{} is at {head}, expected {}; refusing to change an existing checkout",
            directory.display(),
            project.sha
        ));
    }
    if !git(
        &directory,
        &[
            "status",
            "--porcelain",
            "--untracked-files=normal",
            "--ignore-submodules=none",
        ],
    )?
    .is_empty()
    {
        return Err(format!(
            "{} has changes; refusing to use a modified corpus checkout",
            directory.display()
        ));
    }
    Ok(directory)
}

fn read_projects(path: &Path, selected: &[String]) -> Result<Vec<Project>, String> {
    let contents =
        fs::read_to_string(path).map_err(|error| format!("{}: {error}", path.display()))?;
    let corpus: Corpus = toml::from_str(&contents).map_err(|error| error.to_string())?;
    if corpus.version != 1 {
        return Err(format!("unsupported corpus version {}", corpus.version));
    }
    let mut slugs = BTreeSet::new();
    for project in &corpus.projects {
        let components: Vec<_> = project.slug.split('/').collect();
        if components.len() != 2
            || components.iter().any(|component| {
                component.is_empty()
                    || *component == "."
                    || *component == ".."
                    || !component
                        .bytes()
                        .all(|byte| byte.is_ascii_alphanumeric() || b"._-".contains(&byte))
            })
            || project.sha.len() != 40
            || !project.sha.bytes().all(|byte| byte.is_ascii_hexdigit())
        {
            return Err(format!(
                "invalid pinned project: {}@{}",
                project.slug, project.sha
            ));
        }
        if !slugs.insert(project.slug.to_ascii_lowercase()) {
            return Err(format!("duplicate corpus project: {}", project.slug));
        }
    }
    for selection in selected {
        if !slugs.contains(&selection.to_ascii_lowercase()) {
            return Err(format!("unknown corpus project: {selection}"));
        }
    }
    Ok(corpus
        .projects
        .into_iter()
        .filter(|project| {
            selected.is_empty()
                || selected
                    .iter()
                    .any(|selection| selection.eq_ignore_ascii_case(&project.slug))
        })
        .collect())
}

fn fixture_cases(options: &Options, fixtures: &Path) -> Result<Vec<Case>, String> {
    let mut cases = Vec::new();
    let mut matches = BTreeSet::new();
    let fixtures_enabled = !options.corpus_only
        && (options.project.is_empty() || !options.fixture.is_empty() || options.fixtures_only);
    if fixtures_enabled {
        for source in swift_files(fixtures)? {
            let relative = source.strip_prefix(fixtures).unwrap();
            let name = relative.with_extension("");
            let selections: Vec<_> = options
                .fixture
                .iter()
                .filter(|selection| {
                    Path::new(selection.as_str()) == relative
                        || Path::new(selection.as_str()) == name
                })
                .collect();
            if options.fixture.is_empty() || !selections.is_empty() {
                matches.extend(selections.into_iter().cloned());
                cases.push(Case {
                    name: Path::new("fixtures").join(relative),
                    json: source.with_extension("json"),
                    source,
                });
            }
        }
    }
    for selection in &options.fixture {
        if !matches.contains(selection) {
            return Err(format!("unknown test fixture: {selection}"));
        }
    }
    Ok(cases)
}

fn project_files(options: &Options, directory: &Path, slug: &str) -> Result<Vec<PathBuf>, String> {
    let files = swift_files(directory)?;
    for path in &options.project_file {
        if !files.iter().any(|source| {
            source
                .strip_prefix(directory)
                .is_ok_and(|relative| relative == path)
        }) {
            return Err(format!("{slug}: no Swift source at {}", path.display()));
        }
    }
    if let Some(path) = &options.project_start_at {
        eprintln!("SELECT {slug}: paths at or after {}", path.display());
    } else if !options.project_file.is_empty() {
        eprintln!(
            "SELECT {slug}: {} explicit paths",
            options.project_file.len()
        );
    }
    Ok(files
        .into_iter()
        .filter(|source| {
            let relative = source.strip_prefix(directory).unwrap();
            (options.project_file.is_empty()
                || options.project_file.iter().any(|path| path == relative))
                && options
                    .project_start_at
                    .as_ref()
                    .is_none_or(|path| relative >= path.as_path())
        })
        .collect())
}

pub(crate) fn run(options: &Options) -> Result<bool, String> {
    let workspace = std::env::var_os("BUILD_WORKSPACE_DIRECTORY")
        .map_or_else(
            || Path::new(env!("CARGO_MANIFEST_DIR")).join("../.."),
            PathBuf::from,
        )
        .canonicalize()
        .map_err(|error| error.to_string())?;
    let parser_dir = workspace.join("unified/swift-parser");
    let fixtures = options
        .fixtures_dir
        .clone()
        .unwrap_or_else(|| parser_dir.join("test-fixtures"));
    let corpus_file = options
        .corpus_file
        .clone()
        .unwrap_or_else(|| parser_dir.join("test-corpus.toml"));
    let cache = options
        .cache_dir
        .clone()
        .unwrap_or_else(|| workspace.join("target/swift-parser-tests"));
    let cases = fixture_cases(options, &fixtures)?;
    let corpus_enabled =
        !options.fixtures_only && (!options.project.is_empty() || options.corpus_only);
    let projects = if corpus_enabled {
        read_projects(&corpus_file, &options.project)?
    } else {
        Vec::new()
    };
    let mut runner = Runner {
        options,
        cache: cache.clone(),
        oracle: Oracle {
            executable: options.swift_syntax_parser.clone(),
            build_error: None,
            workspace,
        },
        passed: 0,
        failed: 0,
        generated: 0,
        skipped: 0,
    };
    for case in &cases {
        runner.case(case, false);
    }
    for project in projects {
        let directory = match checkout(&project, &cache) {
            Ok(directory) => directory,
            Err(error) => {
                runner.failed += 1;
                eprintln!("FAIL {}: {error}", project.slug);
                continue;
            }
        };
        let files = project_files(options, &directory, &project.slug)?;
        if files.is_empty() {
            runner.failed += 1;
            eprintln!("FAIL {}: no Swift source files found", project.slug);
        }
        let mut mismatches = 0;
        for source in files {
            let relative = source.strip_prefix(&directory).unwrap();
            let name = Path::new(&project.slug).join(&project.sha).join(relative);
            let mismatch = runner.case(
                &Case {
                    json: cache.join("references").join(&name).with_extension("json"),
                    name: Path::new("projects").join(name),
                    source,
                },
                true,
            );
            if mismatch && !options.generate_only {
                mismatches += 1;
                if mismatches >= options.max_project_failures.get() {
                    if mismatches == 1 {
                        eprintln!("STOP {}: first mismatch on valid Swift", project.slug);
                    } else {
                        eprintln!(
                            "STOP {}: {mismatches} mismatches on valid Swift",
                            project.slug
                        );
                    }
                    break;
                }
            }
        }
    }
    if runner.passed + runner.failed + runner.skipped == 0 {
        return Err("no Swift test cases selected".into());
    }
    eprintln!(
        "{} passed, {} failed, {} skipped; {} reference JSON files generated",
        runner.passed, runner.failed, runner.skipped, runner.generated
    );
    Ok(runner.failed == 0)
}
