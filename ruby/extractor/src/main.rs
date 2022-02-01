mod extractor;

extern crate num_cpus;

use clap::arg;
use flate2::write::GzEncoder;
use rayon::prelude::*;
use std::fs;
use std::io::{BufRead, BufWriter};
use std::path::{Path, PathBuf};
use tree_sitter::{Language, Parser, Range};

enum TrapCompression {
    None,
    Gzip,
}

impl TrapCompression {
    fn from_env() -> TrapCompression {
        match std::env::var("CODEQL_RUBY_TRAP_COMPRESSION") {
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
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new("ruby_extractor=warn")),
        )
        .init();
    tracing::warn!("Support for Ruby is currently in Beta: https://git.io/codeql-language-support");
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

    let matches = clap::App::new("Ruby extractor")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL Ruby extractor")
        .arg(arg!(--"source-archive-dir" <DIR> "Sets a custom source archive folder"))
        .arg(arg!(--"output-dir" <DIR>         "Sets a custom trap folder"))
        .arg(arg!(--"file-list" <FILE_LIST>    "A text file containing the paths of the files to extract"))
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

    let language = tree_sitter_ruby::language();
    let erb = tree_sitter_embedded_template::language();
    // Look up tree-sitter kind ids now, to avoid string comparisons when scanning ERB files.
    let erb_directive_id = erb.id_for_node_kind("directive", true);
    let erb_output_directive_id = erb.id_for_node_kind("output_directive", true);
    let erb_code_id = erb.id_for_node_kind("code", true);
    let schema = node_types::read_node_types_str("ruby", tree_sitter_ruby::NODE_TYPES)?;
    let erb_schema =
        node_types::read_node_types_str("erb", tree_sitter_embedded_template::NODE_TYPES)?;
    let lines: std::io::Result<Vec<String>> = std::io::BufReader::new(file_list).lines().collect();
    let lines = lines?;
    lines
        .par_iter()
        .try_for_each(|line| {
            let path = PathBuf::from(line).canonicalize()?;
            let src_archive_file = path_for(&src_archive_dir, &path, "");
            let mut source = std::fs::read(&path)?;
            let code_ranges;
            let mut trap_writer = extractor::new_trap_writer();
            if path.extension().map_or(false, |x| x == "erb") {
                tracing::info!("scanning: {}", path.display());
                extractor::extract(
                    erb,
                    "erb",
                    &erb_schema,
                    &mut trap_writer,
                    &path,
                    &source,
                    &[],
                )?;

                let (ranges, line_breaks) = scan_erb(
                    erb,
                    &source,
                    erb_directive_id,
                    erb_output_directive_id,
                    erb_code_id,
                );
                for i in line_breaks {
                    if i < source.len() {
                        source[i] = b'\n';
                    }
                }
                code_ranges = ranges;
            } else {
                code_ranges = vec![];
            }
            extractor::extract(
                language,
                "ruby",
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

fn scan_erb(
    erb: Language,
    source: &[u8],
    directive_id: u16,
    output_directive_id: u16,
    code_id: u16,
) -> (Vec<Range>, Vec<usize>) {
    let mut parser = Parser::new();
    parser.set_language(erb).unwrap();
    let tree = parser.parse(&source, None).expect("Failed to parse file");
    let mut result = Vec::new();
    let mut line_breaks = vec![];

    for n in tree.root_node().children(&mut tree.walk()) {
        let kind_id = n.kind_id();
        if kind_id == directive_id || kind_id == output_directive_id {
            for c in n.children(&mut tree.walk()) {
                if c.kind_id() == code_id {
                    let mut range = c.range();
                    if range.end_byte < source.len() {
                        line_breaks.push(range.end_byte);
                        range.end_byte += 1;
                        range.end_point.column += 1;
                    }
                    result.push(range);
                }
            }
        }
    }
    if result.is_empty() {
        let root = tree.root_node();
        // Add an empty range at the end of the file
        result.push(Range {
            start_byte: root.end_byte(),
            end_byte: root.end_byte(),
            start_point: root.end_position(),
            end_point: root.end_position(),
        });
    }
    (result, line_breaks)
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
