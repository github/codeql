use std::path::PathBuf;
use serde::{Deserialize, Serialize, Serializer, Deserializer};
use serde_with;
use figment::{Figment, providers::{Env, Serialized}};
use clap::{Parser, ArgAction, ValueEnum};
use clap::builder::PossibleValue;
use codeql_extractor::trap;

#[derive(Debug, PartialEq, Eq, Default, Serialize, Deserialize, Clone, Copy, ValueEnum)]
#[serde(rename_all = "lowercase")]
#[clap(rename_all = "lowercase")]
pub enum Compression {
    #[default] // TODO make gzip default
    None,
    Gzip,
}

impl Into<trap::Compression> for Compression {
    fn into(self) -> trap::Compression {
        match self {
            Compression::None => trap::Compression::None,
            Compression::Gzip => trap::Compression::Gzip,
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
