//! Small demo CLI: parse Swift source and print the syntax tree as JSON.
//!
//! Usage:
//!   swift-syntax-parse [FILE]
//!
//! Reads from FILE if given, otherwise from standard input.

use std::io::Read;
use std::process::ExitCode;

fn main() -> ExitCode {
    let source = match read_source() {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error reading source: {e}");
            return ExitCode::FAILURE;
        }
    };

    match swift_syntax_rs::parse_to_json(&source) {
        Ok(json) => {
            println!("{json}");
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}

fn read_source() -> std::io::Result<String> {
    let mut args = std::env::args().skip(1);
    match args.next() {
        Some(path) => std::fs::read_to_string(path),
        None => {
            let mut buf = String::new();
            std::io::stdin().read_to_string(&mut buf)?;
            Ok(buf)
        }
    }
}
