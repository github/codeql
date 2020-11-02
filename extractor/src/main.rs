mod extractor;

use clap;
use flate2::write::GzEncoder;
use std::fs;
use std::io::{BufRead, BufWriter, Write};
use std::path::{Path, PathBuf};

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
            TrapCompression::None => ".trap",
            TrapCompression::Gzip => ".trap.gz",
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

    let matches = clap::App::new("Ruby extractor")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL Ruby extractor")
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

    let language = tree_sitter_ruby::language();
    let schema = node_types::read_node_types_str(tree_sitter_ruby::NODE_TYPES)?;
    let mut extractor = extractor::create(language, schema);
    for line in std::io::BufReader::new(file_list).lines() {
        let path = PathBuf::from(line?).canonicalize()?;
        let trap_file = path_for(&trap_dir, &path, trap_compression.extension());
        let src_archive_file = path_for(&src_archive_dir, &path, "");
        let trap = extractor.extract(&path)?;
        std::fs::create_dir_all(&src_archive_file.parent().unwrap())?;
        std::fs::copy(&path, &src_archive_file)?;
        std::fs::create_dir_all(&trap_file.parent().unwrap())?;
        let trap_file = std::fs::File::create(&trap_file)?;
        let mut trap_file = BufWriter::new(trap_file);
        match trap_compression {
            TrapCompression::None => {
                write!(trap_file, "{}", trap)?;
            }
            TrapCompression::Gzip => {
                let mut compressed_writer = GzEncoder::new(trap_file, flate2::Compression::fast());
                write!(compressed_writer, "{}", trap)?;
            }
        }
    }
    return Ok(());
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
    if let Some(x) = result.extension() {
        let mut new_ext = x.to_os_string();
        new_ext.push(ext);
        result.set_extension(new_ext);
    } else {
        result.set_extension(ext);
    }
    result
}
