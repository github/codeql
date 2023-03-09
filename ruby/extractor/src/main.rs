mod diagnostics;
mod extractor;
mod trap;

#[macro_use]
extern crate lazy_static;
extern crate num_cpus;

use clap::arg;
use encoding::{self};
use rayon::prelude::*;
use std::borrow::Cow;
use std::fs;
use std::io::BufRead;
use std::path::{Path, PathBuf};
use tree_sitter::{Language, Parser, Range};

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
fn num_codeql_threads() -> Result<usize, String> {
    let threads_str = std::env::var("CODEQL_THREADS").unwrap_or_else(|_| "-1".to_owned());
    match threads_str.parse::<i32>() {
        Ok(num) if num <= 0 => {
            let reduction = -num as usize;
            Ok(std::cmp::max(1, num_cpus::get() - reduction))
        }
        Ok(num) => Ok(num as usize),

        Err(_) => Err(format!(
            "Unable to parse CODEQL_THREADS value '{}'",
            &threads_str
        )),
    }
}

lazy_static! {
    static ref CP_NUMBER: regex::Regex = regex::Regex::new("cp([0-9]+)").unwrap();
}

fn encoding_from_name(encoding_name: &str) -> Option<&(dyn encoding::Encoding + Send + Sync)> {
    match encoding::label::encoding_from_whatwg_label(encoding_name) {
        s @ Some(_) => s,
        None => CP_NUMBER.captures(encoding_name).and_then(|cap| {
            encoding::label::encoding_from_windows_code_page(
                str::parse(cap.get(1).unwrap().as_str()).unwrap(),
            )
        }),
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
    let diagnostics = diagnostics::DiagnosticLoggers::new("ruby");
    let mut main_thread_logger = diagnostics.logger();
    let num_threads = match num_codeql_threads() {
        Ok(num) => num,
        Err(e) => {
            main_thread_logger.write(
                main_thread_logger
                    .new_entry("configuration-error", "Configuration error")
                    .message(
                        "{}; defaulting to 1 thread.",
                        &[diagnostics::MessageArg::Code(&e)],
                    )
                    .severity(diagnostics::Severity::Warning),
            );
            1
        }
    };
    tracing::info!(
        "Using {} {}",
        num_threads,
        if num_threads == 1 {
            "thread"
        } else {
            "threads"
        }
    );
    let trap_compression = match trap::Compression::from_env("CODEQL_RUBY_TRAP_COMPRESSION") {
        Ok(x) => x,
        Err(e) => {
            main_thread_logger.write(
                main_thread_logger
                    .new_entry("configuration-error", "Configuration error")
                    .message("{}; using gzip.", &[diagnostics::MessageArg::Code(&e)])
                    .severity(diagnostics::Severity::Warning),
            );
            trap::Compression::Gzip
        }
    };
    drop(main_thread_logger);
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
            let mut diagnostics_writer = diagnostics.logger();
            let path = PathBuf::from(line).canonicalize()?;
            let src_archive_file = path_for(&src_archive_dir, &path, "");
            let mut source = std::fs::read(&path)?;
            let mut needs_conversion = false;
            let code_ranges;
            let mut trap_writer = trap::Writer::new();
            if path.extension().map_or(false, |x| x == "erb") {
                tracing::info!("scanning: {}", path.display());
                extractor::extract(
                    erb,
                    "erb",
                    &erb_schema,
                    &mut diagnostics_writer,
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
                if let Some(encoding_name) = scan_coding_comment(&source) {
                    // If the input is already UTF-8 then there is no need to recode the source
                    // If the declared encoding is 'binary' or 'ascii-8bit' then it is not clear how
                    // to interpret characters. In this case it is probably best to leave the input
                    // unchanged.
                    if !encoding_name.eq_ignore_ascii_case("utf-8")
                        && !encoding_name.eq_ignore_ascii_case("ascii-8bit")
                        && !encoding_name.eq_ignore_ascii_case("binary")
                    {
                        if let Some(encoding) = encoding_from_name(&encoding_name) {
                            needs_conversion =
                                encoding.whatwg_name().unwrap_or_default() != "utf-8";
                            if needs_conversion {
                                match encoding
                                    .decode(&source, encoding::types::DecoderTrap::Replace)
                                {
                                    Ok(str) => source = str.as_bytes().to_owned(),
                                    Err(msg) => {
                                        needs_conversion = false;
                                        diagnostics_writer.write(
                                            diagnostics_writer
                                                .new_entry(
                                                    "character-decoding-error",
                                                    "Character decoding error",
                                                )
                                                .file(&path.to_string_lossy())
                                                .message(
                                                    "Could not decode the file contents as {}: {}. The contents of the file must match the character encoding specified in the {} {}.",
                                                    &[
                                                        diagnostics::MessageArg::Code(&encoding_name),
                                                        diagnostics::MessageArg::Code(&msg),
                                                        diagnostics::MessageArg::Code("encoding:"),
                                                        diagnostics::MessageArg::Link("directive", "https://docs.ruby-lang.org/en/master/syntax/comments_rdoc.html#label-encoding+Directive")
                                                    ],
                                                )
                                                .status_page()
                                                .severity(diagnostics::Severity::Warning),
                                        );
                                    }
                                }
                            }
                        } else {
                            diagnostics_writer.write(
                                diagnostics_writer
                                    .new_entry("unknown-character-encoding", "Unknown character encoding")
                                    .file(&path.to_string_lossy())
                                    .message(
                                        "Unknown character encoding {} in {} {}.",
                                        &[
                                            diagnostics::MessageArg::Code(&encoding_name),
                                            diagnostics::MessageArg::Code("#encoding:"),
                                            diagnostics::MessageArg::Link("directive", "https://docs.ruby-lang.org/en/master/syntax/comments_rdoc.html#label-encoding+Directive")
                                        ],
                                    )
                                    .status_page()
                                    .severity(diagnostics::Severity::Warning),
                            );
                        }
                    }
                }
                code_ranges = vec![];
            }
            extractor::extract(
                language,
                "ruby",
                &schema,
                &mut diagnostics_writer,
                &mut trap_writer,
                &path,
                &source,
                &code_ranges,
            )?;
            std::fs::create_dir_all(&src_archive_file.parent().unwrap())?;
            if needs_conversion {
                std::fs::write(&src_archive_file, &source)?;
            } else {
                std::fs::copy(&path, &src_archive_file)?;
            }
            write_trap(&trap_dir, path, &trap_writer, trap_compression)
        })
        .expect("failed to extract files");

    let path = PathBuf::from("extras");
    let mut trap_writer = trap::Writer::new();
    extractor::populate_empty_location(&mut trap_writer);
    write_trap(&trap_dir, path, &trap_writer, trap_compression)
}

fn write_trap(
    trap_dir: &Path,
    path: PathBuf,
    trap_writer: &trap::Writer,
    trap_compression: trap::Compression,
) -> std::io::Result<()> {
    let trap_file = path_for(trap_dir, &path, trap_compression.extension());
    std::fs::create_dir_all(&trap_file.parent().unwrap())?;
    trap_writer.write_to_file(&trap_file, trap_compression)
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

fn skip_space(content: &[u8], index: usize) -> usize {
    let mut index = index;
    while index < content.len() {
        let c = content[index] as char;
        // white space except \n
        let is_space = c == ' ' || ('\t'..='\r').contains(&c) && c != '\n';
        if !is_space {
            break;
        }
        index += 1;
    }
    index
}

fn scan_coding_comment(content: &[u8]) -> std::option::Option<Cow<str>> {
    let mut index = 0;
    // skip UTF-8 BOM marker if there is one
    if content.len() >= 3 && content[0] == 0xef && content[1] == 0xbb && content[2] == 0xbf {
        index += 3;
    }
    // skip #! line if there is one
    if index + 1 < content.len()
        && content[index] as char == '#'
        && content[index + 1] as char == '!'
    {
        index += 2;
        while index < content.len() && content[index] as char != '\n' {
            index += 1
        }
        index += 1
    }
    index = skip_space(content, index);

    if index >= content.len() || content[index] as char != '#' {
        return None;
    }
    index += 1;

    const CODING: [char; 12] = ['C', 'c', 'O', 'o', 'D', 'd', 'I', 'i', 'N', 'n', 'G', 'g'];
    let mut word_index = 0;
    while index < content.len() && word_index < CODING.len() && content[index] as char != '\n' {
        if content[index] as char == CODING[word_index]
            || content[index] as char == CODING[word_index + 1]
        {
            word_index += 2
        } else {
            word_index = 0;
        }
        index += 1;
    }
    if word_index < CODING.len() {
        return None;
    }
    index = skip_space(content, index);

    if index < content.len() && content[index] as char != ':' && content[index] as char != '=' {
        return None;
    }
    index += 1;
    index = skip_space(content, index);

    let start = index;
    while index < content.len() {
        let c = content[index] as char;
        if c == '-' || c == '_' || c.is_ascii_alphanumeric() {
            index += 1;
        } else {
            break;
        }
    }
    if index > start {
        return Some(String::from_utf8_lossy(&content[start..index]));
    }
    None
}

#[test]
fn test_scan_coding_comment() {
    let text = "# encoding: utf-8";
    let result = scan_coding_comment(text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "#coding:utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "# foo\n# encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, None);

    let text = "# encoding: latin1 encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("latin1".into()));

    let text = "# encoding: nonsense";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("nonsense".into()));

    let text = "# coding = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "# CODING = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "# CoDiNg = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "# blah blahblahcoding = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    // unicode BOM is ignored
    let text = "\u{FEFF}# encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "\u{FEFF} # encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "#! /usr/bin/env ruby\n # encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    let text = "\u{FEFF}#! /usr/bin/env ruby\n # encoding: utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));

    // A #! must be the first thing on a line, otherwise it's a normal comment
    let text = " #! /usr/bin/env ruby encoding = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, Some("utf-8".into()));
    let text = " #! /usr/bin/env ruby \n # encoding = utf-8";
    let result = scan_coding_comment(&text.as_bytes());
    assert_eq!(result, None);
}
