use anyhow::Context;
use clap::Parser;
use codeql_extractor::trap;
use figment::{
    providers::{Env, Format, Serialized, Yaml},
    value::Value,
    Figment,
};
use itertools::Itertools;
use log::warn;
use num_traits::Zero;
use ra_ap_cfg::{CfgAtom, CfgDiff};
use ra_ap_intern::Symbol;
use ra_ap_paths::Utf8PathBuf;
use ra_ap_project_model::{CargoConfig, CargoFeatures, CfgOverrides, RustLibSource};
use rust_extractor_macros::extractor_cli_config;
use serde::{Deserialize, Deserializer, Serialize};
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

// required by the extractor_cli_config macro.
fn deserialize_newline_or_comma_separated<'a, D: Deserializer<'a>, T: for<'b> From<&'b str>>(
    deserializer: D,
) -> Result<Vec<T>, D::Error> {
    let value = String::deserialize(deserializer)?;
    Ok(value.split(['\n', ',']).map(T::from).collect())
}

#[extractor_cli_config]
pub struct Config {
    pub scratch_dir: PathBuf,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub cargo_target_dir: Option<PathBuf>,
    pub cargo_target: Option<String>,
    pub cargo_features: Vec<String>,
    pub cargo_cfg_overrides: Vec<String>,
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

    pub fn to_cargo_config(&self) -> CargoConfig {
        let sysroot = Some(RustLibSource::Discover);

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
    let mut enabled_cfgs = Vec::new();
    let mut disabled_cfgs = Vec::new();
    let mut has_test_explicitly_enabled = false;
    for spec in specs {
        if spec.starts_with("-") {
            disabled_cfgs.push(to_cfg_override(&spec[1..]));
        } else {
            enabled_cfgs.push(to_cfg_override(spec));
            if spec == "test" {
                has_test_explicitly_enabled = true;
            }
        }
    }
    if !has_test_explicitly_enabled {
        disabled_cfgs.push(to_cfg_override("test"));
    }
    if let Some(global) = CfgDiff::new(enabled_cfgs, disabled_cfgs) {
        CfgOverrides {
            global,
            ..Default::default()
        }
    } else {
        warn!("non-disjoint cfg overrides, ignoring: {}", specs.join(", "));
        CfgOverrides {
            global: CfgDiff::new(Vec::new(), vec![to_cfg_override("test")])
                .expect("disabling one cfg should always succeed"),
            ..Default::default()
        }
    }
}
