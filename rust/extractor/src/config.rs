use anyhow::Context;
use clap::Parser;
use codeql_extractor::trap;
use figment::{
    providers::{Env, Format, Serialized, Yaml},
    value::Value,
    Figment,
};
use itertools::Itertools;
use num_traits::Zero;
use rust_extractor_macros::extractor_cli_config;
use serde::{Deserialize, Serialize};
use std::fmt::Debug;
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
    pub cargo_target_dir: Option<PathBuf>,
    pub verbose: u8,
    pub compression: Compression,
    pub inputs: Vec<PathBuf>,
    pub qltest: bool,
    pub qltest_cargo_check: bool,
}

impl Config {
    pub fn extract() -> anyhow::Result<Config> {
        let args = argfile::expand_args(argfile::parse_fromfile, argfile::PREFIX)
            .context("expanding parameter files")?;
        let cli_args = CliConfig::parse_from(args);
        let mut figment = Figment::new()
            .merge(Env::prefixed("CODEQL_"))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_"))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_OPTION_"))
            .merge(Serialized::defaults(cli_args));
        if let Ok(Value::Bool(_, true)) = figment.find_value("qltest") {
            let cwd = std::env::current_dir()?;
            let mut option_files = cwd
                .ancestors()
                // only travel up while we're within the test pack
                .take_while_inclusive(|p| !p.join("qlpack.yml").exists())
                .map(|p| p.join("options"))
                .filter(|p| p.exists())
                .collect_vec();
            option_files.reverse();
            for path in option_files {
                figment = figment.merge(Yaml::file_exact(path));
            }
        }
        figment.extract().context("loading configuration")
    }
}
