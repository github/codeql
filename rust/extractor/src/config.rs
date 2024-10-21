use anyhow::Context;
use clap::Parser;
use codeql_extractor::trap;
use figment::{
    providers::{Env, Serialized},
    Figment,
};
use num_traits::Zero;
use rust_extractor_macros::extractor_cli_config;
use serde::{Deserialize, Serialize};
use std::ops::Not;
use std::path::PathBuf;

#[derive(Debug, PartialEq, Eq, Default, Serialize, Deserialize, Clone, Copy, clap::ValueEnum)]
#[serde(rename_all = "lowercase")]
#[clap(rename_all = "lowercase")]
pub enum Compression {
    #[default] // TODO make gzip default
    None,
    Gzip,
}

impl From<Compression> for trap::Compression {
    fn from(val: Compression) -> Self {
        match val {
            Compression::None => Self::None,
            Compression::Gzip => Self::Gzip,
        }
    }
}

#[extractor_cli_config]
pub struct Config {
    pub scratch_dir: PathBuf,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub extract_dependencies: bool,
    pub verbose: u8,
    pub compression: Compression,
    pub inputs: Vec<PathBuf>,
}

impl Config {
    pub fn extract() -> anyhow::Result<Config> {
        let args = argfile::expand_args(argfile::parse_fromfile, argfile::PREFIX)
            .context("expanding parameter files")?;
        let cli_args = CliConfig::parse_from(args);
        Figment::new()
            .merge(Env::prefixed("CODEQL_"))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_"))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_OPTION_"))
            .merge(Serialized::defaults(cli_args))
            .extract()
            .context("loading configuration")
    }
}
