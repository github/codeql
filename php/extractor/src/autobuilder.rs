use std::env;
use std::path::PathBuf;

use clap::Args;

use codeql_extractor::autobuilder;

#[derive(Args)]
pub struct Options {}

pub fn run(_: Options) -> std::io::Result<()> {
    let database = env::var("CODEQL_EXTRACTOR_PHP_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_PHP_WIP_DATABASE not set");

    autobuilder::Autobuilder::new("php", PathBuf::from(database))
        .include_extensions(&[".php", ".phtml", ".inc", ".php3", ".php4", ".php5", ".php7", ".phps"])
        .exclude_globs(&["**/.git", "**/vendor"])
        .size_limit("10m")
        .run()
}
