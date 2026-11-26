use std::io::Read;
use std::path::Path;

use anyhow::Result;
use clap::{Arg, Command};

mod parser;

const BUILD_VERSION: &str = env!("CARGO_PKG_VERSION");

fn main() -> Result<()> {
    let matches = Command::new("yeast-python")
        .version(BUILD_VERSION)
        .about("Extracts a Python AST with YEAST")
        .arg(Arg::new("source").index(1).required(true))
        .get_matches();

    let source_path = Path::new(matches.get_one::<String>("source").unwrap());
    let mut source = String::new();
    std::io::stdin().read_to_string(&mut source)?;

    let result = parser::parse(source_path, &source)?;
    serde_json::to_writer(std::io::stdout().lock(), &result)?;
    Ok(())
}
