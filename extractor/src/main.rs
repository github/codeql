mod extractor;

use clap;
use std::fs;
use std::io::BufRead;
use std::path::{Path, PathBuf};

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

    let file_list = matches.value_of("file-list").expect("missing --file-list");
    let file_list = fs::File::open(file_list)?;

    let language = tree_sitter_ruby::language();
    let schema = node_types::read_node_types_str(tree_sitter_ruby::NODE_TYPES)?;
    let mut extractor = extractor::create(language, schema);
    for line in std::io::BufReader::new(file_list).lines() {
        let path = PathBuf::from(line?);
        let trap_file = path_for(&trap_dir, &path, ".trap");
        let src_archive_file = path_for(&src_archive_dir, &path, "");
        let trap = extractor.extract(&path)?;
        std::fs::create_dir_all(&src_archive_file.parent().unwrap())?;
        std::fs::copy(&path, &src_archive_file)?;
        std::fs::create_dir_all(&trap_file.parent().unwrap())?;
        let mut trap_file = std::fs::File::create(&trap_file)?;
        let trap_file: &mut dyn std::io::Write = &mut trap_file;
        write!(trap_file, "{}", trap)?;
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
