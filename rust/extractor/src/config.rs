mod deserialize_vec;

use anyhow::Context;
use clap::Parser;
use codeql_extractor::trap;
use deserialize_vec::deserialize_newline_or_comma_separated;
use figment::{
    providers::{Env, Format, Serialized, Yaml},
    value::Value,
    Figment,
};
use itertools::Itertools;
use num_traits::Zero;
use ra_ap_cfg::{CfgAtom, CfgDiff};
use ra_ap_ide_db::FxHashMap;
use ra_ap_intern::Symbol;
use ra_ap_paths::{AbsPath, Utf8PathBuf};
use ra_ap_project_model::{CargoConfig, CargoFeatures, CfgOverrides, RustLibSource, Sysroot};
use rust_extractor_macros::extractor_cli_config;
use serde::{Deserialize, Serialize};
use std::collections::HashSet;
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
    pub diagnostic_dir: PathBuf,
    pub cargo_target_dir: Option<PathBuf>,
    pub cargo_target: Option<String>,
    pub cargo_features: Vec<String>,
    pub cargo_cfg_overrides: Vec<String>,
    pub verbose: u8,
    pub compression: Compression,
    pub inputs: Vec<PathBuf>,
    pub qltest: bool,
    pub qltest_cargo_check: bool,
    pub qltest_dependencies: Vec<String>,
}

impl Config {
    pub fn extract() -> anyhow::Result<Config> {
        let args = argfile::expand_args(argfile::parse_fromfile, argfile::PREFIX)
            .context("expanding parameter files")?;
        let cli_args = CliConfig::parse_from(args);
        let mut figment = Figment::new()
            .merge(Env::raw().only(["CODEQL_VERBOSE"].as_slice()))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_"))
            .merge(Env::prefixed("CODEQL_EXTRACTOR_RUST_OPTION_"))
            .merge(Serialized::defaults(cli_args));
        if let Ok(Value::Bool(_, true)) = figment.find_value("qltest") {
            let cwd = std::env::current_dir()?;
            let mut option_files = cwd
                .ancestors()
                // only travel up while we're within the test pack
                .take_while_inclusive(|p| !p.join("qlpack.yml").exists())
                .map(|p| p.join("options.yml"))
                .filter(|p| p.exists())
                .collect_vec();
            option_files.reverse();
            for path in option_files {
                figment = figment.merge(Yaml::file_exact(path));
            }
        }
        figment.extract().context("loading configuration")
    }

    pub fn to_cargo_config(&self, dir: &AbsPath) -> CargoConfig {
        let sysroot = Sysroot::discover(dir, &FxHashMap::default());
        let sysroot_src = sysroot.src_root().map(ToOwned::to_owned);
        let sysroot = sysroot
            .root()
            .map(ToOwned::to_owned)
            .map(RustLibSource::Path);

        let target_dir = self
            .cargo_target_dir
            .clone()
            .unwrap_or_else(|| self.scratch_dir.join("target"));
        let target_dir = Utf8PathBuf::from_path_buf(target_dir).ok();

        let features = if self.cargo_features.is_empty() {
            Default::default()
        } else if self.cargo_features.contains(&"*".to_string()) {
            CargoFeatures::All
        } else {
            CargoFeatures::Selected {
                features: self.cargo_features.clone(),
                no_default_features: false,
            }
        };

        let target = self.cargo_target.clone();

        let cfg_overrides = to_cfg_overrides(&self.cargo_cfg_overrides);

        CargoConfig {
            sysroot,
            sysroot_src,
            target_dir,
            features,
            target,
            cfg_overrides,
            ..Default::default()
        }
    }
}

fn to_cfg_override(spec: &str) -> CfgAtom {
    if let Some((key, value)) = spec.split_once("=") {
        CfgAtom::KeyValue {
            key: Symbol::intern(key),
            value: Symbol::intern(value),
        }
    } else {
        CfgAtom::Flag(Symbol::intern(spec))
    }
}

fn to_cfg_overrides(specs: &Vec<String>) -> CfgOverrides {
    let mut enabled_cfgs = HashSet::new();
    enabled_cfgs.insert(to_cfg_override("test"));
    let mut disabled_cfgs = HashSet::new();
    for spec in specs {
        if let Some(spec) = spec.strip_prefix("-") {
            let cfg = to_cfg_override(spec);
            enabled_cfgs.remove(&cfg);
            disabled_cfgs.insert(cfg);
        } else {
            let cfg = to_cfg_override(spec);
            disabled_cfgs.remove(&cfg);
            enabled_cfgs.insert(cfg);
        }
    }
    let enabled_cfgs = enabled_cfgs.into_iter().collect();
    let disabled_cfgs = disabled_cfgs.into_iter().collect();
    let global = CfgDiff::new(enabled_cfgs, disabled_cfgs)
        .expect("There should be no duplicate cfgs by construction");
    CfgOverrides {
        global,
        ..Default::default()
    }
}
