use std::path::PathBuf;
use serde::{Deserialize, Serialize};
use serde_with;
use figment::{Figment, providers::{Env, Serialized}};
use clap::{Parser, ArgAction};


#[serde_with::apply(_ => #[serde(default)])]
#[derive(Debug, Deserialize, Default)]
pub struct Config {
    pub scratch_dir: PathBuf,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub verbose: u8,
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
    #[arg(short, long, action = ArgAction::Count)]
    pub verbose: u8,

    inputs: Vec<PathBuf>,
}

fn is_default<T: Default + PartialEq>(t: &T) -> bool {
    *t == Default::default()
}

impl Config {
    pub fn extract() -> figment::Result<Config> {
        Figment::new()
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_"))
            .merge(Serialized::defaults(CliArgs::parse()))
            .extract()
    }
}
