mod extractor;

extern crate num_cpus;

use flate2::write::GzEncoder;
use rayon::prelude::*;
use std::fs;
use std::io::{BufRead, BufWriter};
use std::path::{Path, PathBuf};

enum TrapCompression {
    None,
    Gzip,
}

impl TrapCompression {
    fn from_env() -> TrapCompression {
        match std::env::var("CODEQL_QL_TRAP_COMPRESSION") {
            Ok(method) => match TrapCompression::from_string(&method) {
                Some(c) => c,
                None => {
                    tracing::error!("Unknown compression method '{}'; using gzip.", &method);
                    TrapCompression::Gzip
                }
            },
            // Default compression method if the env var isn't set:
            Err(_) => TrapCompression::Gzip,
        }
    }

    fn from_string(s: &str) -> Option<TrapCompression> {
        match s.to_lowercase().as_ref() {
            "none" => Some(TrapCompression::None),
            "gzip" => Some(TrapCompression::Gzip),
            _ => None,
        }
    }

    fn extension(&self) -> &str {
        match self {
            TrapCompression::None => "trap",
            TrapCompression::Gzip => "trap.gz",
        }
    }
}

/**
 * Gets the number of threads the extractor should use, by reading the
 * CODEQL_THREADS environment variable and using it as described in the
 * extractor spec:
 *
 * "If the number is positive, it indicates the number of threads that should
 * be used. If the number is negative or zero, it should be added to the number
 * of cores available on the machine to determine how many threads to use
 * (minimum of 1). If unspecified, should be considered as set to -1."
 */
fn num_codeql_threads() -> usize {
    let threads_str = std::env::var("CODEQL_THREADS").unwrap_or_else(|_| "-1".to_owned());
    match threads_str.parse::<i32>() {
        Ok(num) if num <= 0 => {
            let reduction = -num as usize;
            std::cmp::max(1, num_cpus::get() - reduction)
        }
        Ok(num) => num as usize,

        Err(_) => {
            tracing::error!(
                "Unable to parse CODEQL_THREADS value '{}'; defaulting to 1 thread.",
                &threads_str
            );
            1
        }
    }
}

fn main() -> std::io::Result<()> {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let num_threads = num_codeql_threads();
    tracing::info!(
        "Using {} {}",
        num_threads,
        if num_threads == 1 {
            "thread"
        } else {
            "threads"
        }
    );
    rayon::ThreadPoolBuilder::new()
        .num_threads(num_threads)
        .build_global()
        .unwrap();

    let matches = clap::App::new("QL extractor")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL QL extractor")
        .args_from_usage(
            "--source-archive-dir=<DIR> 'Sets a custom source archive folder'
                    --output-dir=<DIR>         'Sets a custom trap folder'
                    --file-list=<FILE_LIST>    'A text files containing the paths of the files to extract'",
        )
        .get_matches();
    let src_archive_dir = matches
        .value_of("source-archive-dir")
        .expect("missing --source-archive-dir");
    let src_archive_dir = PathBuf::from(src_archive_dir);

    let trap_dir = matches
        .value_of("output-dir")
        .expect("missing --output-dir");
    let trap_dir = PathBuf::from(trap_dir);
    let trap_compression = TrapCompression::from_env();

    let file_list = matches.value_of("file-list").expect("missing --file-list");
    let file_list = fs::File::open(file_list)?;

    let language = tree_sitter_ql::language();
    let schema = node_types::read_node_types_str("ql", tree_sitter_ql::NODE_TYPES)?;
    let lines: std::io::Result<Vec<String>> = std::io::BufReader::new(file_list).lines().collect();
    let lines = lines?;
    lines
        .par_iter()
        .try_for_each(|line| {
            // only consider files that end with .ql/.qll/.dbscheme/qlpack.yml
            // TODO: This is a bad fix, wait for the post-merge discussion in https://github.com/github/codeql/pull/7444 to be resolved
            if !line.ends_with(".ql")
                && !line.ends_with(".qll")
                && !line.ends_with(".dbscheme")
                && !line.ends_with("qlpack.yml")
            {
                return Ok(());
            }
            let path = PathBuf::from(line).canonicalize()?;
            let src_archive_file = path_for(&src_archive_dir, &path, "");
            let source = std::fs::read(&path)?;
            let code_ranges = vec![];
            let mut trap_writer = extractor::new_trap_writer();
            extractor::extract(
                language,
                "ql",
                &schema,
                &mut trap_writer,
                &path,
                &source,
                &code_ranges,
            )?;
            std::fs::create_dir_all(&src_archive_file.parent().unwrap())?;
            std::fs::copy(&path, &src_archive_file)?;
            write_trap(&trap_dir, path, trap_writer, &trap_compression)
        })
        .expect("failed to extract files");

    let path = PathBuf::from("extras");
    let mut trap_writer = extractor::new_trap_writer();
    trap_writer.populate_empty_location();
    write_trap(&trap_dir, path, trap_writer, &trap_compression)
}

fn write_trap(
    trap_dir: &Path,
    path: PathBuf,
    trap_writer: extractor::TrapWriter,
    trap_compression: &TrapCompression,
) -> std::io::Result<()> {
    let trap_file = path_for(trap_dir, &path, trap_compression.extension());
    std::fs::create_dir_all(&trap_file.parent().unwrap())?;
    let trap_file = std::fs::File::create(&trap_file)?;
    let mut trap_file = BufWriter::new(trap_file);
    match trap_compression {
        TrapCompression::None => trap_writer.output(&mut trap_file),
        TrapCompression::Gzip => {
            let mut compressed_writer = GzEncoder::new(trap_file, flate2::Compression::fast());
            trap_writer.output(&mut compressed_writer)
        }
    }
}

fn path_for(dir: &Path, path: &Path, ext: &str) -> PathBuf {
    let mut result = PathBuf::from(dir);
    for component in path.components() {
        match component {
            std::path::Component::Prefix(prefix) => match prefix.kind() {
                std::path::Prefix::Disk(letter) | std::path::Prefix::VerbatimDisk(letter) => {
                    result.push(format!("{}_", letter as char))
                }
                std::path::Prefix::Verbatim(x) | std::path::Prefix::DeviceNS(x) => {
                    result.push(x);
                }
                std::path::Prefix::UNC(server, share)
                | std::path::Prefix::VerbatimUNC(server, share) => {
                    result.push("unc");
                    result.push(server);
                    result.push(share);
                }
            },
            std::path::Component::RootDir => {
                // skip
            }
            std::path::Component::Normal(_) => {
                result.push(component);
            }
            std::path::Component::CurDir => {
                // skip
            }
            std::path::Component::ParentDir => {
                result.pop();
            }
        }
    }
    if !ext.is_empty() {
        match result.extension() {
            Some(x) => {
                let mut new_ext = x.to_os_string();
                new_ext.push(".");
                new_ext.push(ext);
                result.set_extension(new_ext);
            }
            None => {
                result.set_extension(ext);
            }
        }
    }
    result
}
