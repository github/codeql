use anyhow::Context;
use clap::{ArgAction, Parser, ValueEnum};
use codeql_extractor::trap;
use figment::{
    providers::{Env, Serialized},
    Figment,
};
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, PartialEq, Eq, Default, Serialize, Deserialize, Clone, Copy, ValueEnum)]
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

#[serde_with::apply(_ => #[serde(default)])]
#[derive(Debug, Deserialize, Default)]
pub struct Config {
    pub scratch_dir: PathBuf,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub verbose: u8,
    pub compression: Compression,
    pub inputs: Vec<PathBuf>,
}

#[serde_with::apply(_ => #[serde(skip_serializing_if = "is_default")])]
#[derive(clap::Parser, Serialize)]
#[command(about, long_about = None)]
struct CliArgs {
    #[arg(long)]
    scratch_dir: Option<PathBuf>,
    #[arg(long)]
    trap_dir: Option<PathBuf>,
    #[arg(long)]
    source_archive_dir: Option<PathBuf>,
    #[arg(long)]
    compression: Option<Compression>,
    #[arg(short, long, action = ArgAction::Count)]
    verbose: u8,
    #[arg(long)]
    inputs_file: Option<PathBuf>,

    inputs: Vec<PathBuf>,
}

fn is_default<T: Default + PartialEq>(t: &T) -> bool {
    *t == Default::default()
}

impl Config {
    pub fn extract() -> anyhow::Result<Config> {
        let mut cli_args = CliArgs::parse();
        if let Some(inputs_file) = cli_args.inputs_file.take() {
            let inputs_list = std::fs::read_to_string(inputs_file).context("reading file list")?;
            cli_args
                .inputs
                .extend(inputs_list.split("\n").map(PathBuf::from));
        }
        Figment::new()
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_"))
            .merge(Serialized::defaults(cli_args))
            .extract()
            .context("loading configuration")
    }
}
