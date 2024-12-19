use std::path::PathBuf;
use codeql_extractor::autobuilder;

fn main() -> std::io::Result<()> {
    let database = std::env::var("CODEQL_EXTRACTOR_RUST_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_RUST_WIP_DATABASE not set");

    autobuilder::Autobuilder::new("rust", PathBuf::from(database))
        .include_extensions(&[".rs"])
        .exclude_globs(&["**/.git", "**/tests/**"])
        .size_limit("5m")
        .run()
}
