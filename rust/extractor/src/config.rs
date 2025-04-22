mod deserialize;

use anyhow::Context;
use clap::Parser;
use codeql_extractor::trap;
use figment::{
    Figment,
    providers::{Env, Format, Serialized, Yaml},
    value::Value,
};
use itertools::Itertools;
use ra_ap_cfg::{CfgAtom, CfgDiff};
use ra_ap_ide_db::FxHashMap;
use ra_ap_intern::Symbol;
use ra_ap_load_cargo::{LoadCargoConfig, ProcMacroServerChoice};
use ra_ap_paths::{AbsPath, AbsPathBuf, Utf8PathBuf};
use ra_ap_project_model::{CargoConfig, CargoFeatures, CfgOverrides, RustLibSource, Sysroot};
use rust_extractor_macros::extractor_cli_config;
use serde::{Deserialize, Serialize};
use std::collections::HashSet;
use std::fmt::Debug;
use std::ops::Not;
use std::path::{Path, PathBuf};

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
    pub cargo_extra_env: FxHashMap<String, String>,
    pub cargo_extra_args: Vec<String>,
    pub cargo_all_targets: bool,
    pub logging_flamegraph: Option<PathBuf>,
    pub logging_verbosity: Option<String>,
    pub compression: Compression,
    pub inputs: Vec<PathBuf>,
    pub qltest: bool,
    pub qltest_cargo_check: bool,
    pub qltest_dependencies: Vec<String>,
    pub sysroot: Option<PathBuf>,
    pub sysroot_src: Option<PathBuf>,
    pub rustc_src: Option<PathBuf>,
    pub build_script_command: Vec<String>,
    pub extra_includes: Vec<PathBuf>,
    pub proc_macro_server: Option<PathBuf>,
    pub skip_path_resolution: bool,
}

impl Config {
    pub fn extract() -> anyhow::Result<Config> {
        let args = argfile::expand_args(argfile::parse_fromfile, argfile::PREFIX)
            .context("expanding parameter files")?;
        let cli_args = CliConfig::parse_from(args);
        let mut figment = Figment::new()
            .merge(Env::raw().filter_map(|f| {
                if f.eq("CODEQL_VERBOSITY") {
                    Some("LOGGING_VERBOSITY".into())
                } else {
                    None
                }
            }))
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

    fn sysroot(&self, dir: &AbsPath) -> Sysroot {
        let sysroot_input = self.sysroot.as_ref().map(|p| join_path_buf(dir, p));
        let sysroot_src_input = self.sysroot_src.as_ref().map(|p| join_path_buf(dir, p));
        match (sysroot_input, sysroot_src_input) {
            (None, None) => Sysroot::discover(dir, &self.cargo_extra_env),
            (Some(sysroot), None) => Sysroot::discover_rust_lib_src_dir(sysroot),
            (None, Some(sysroot_src)) => {
                Sysroot::discover_with_src_override(dir, &self.cargo_extra_env, sysroot_src)
            }
            (Some(sysroot), Some(sysroot_src)) => Sysroot::new(Some(sysroot), Some(sysroot_src)),
        }
    }

    fn proc_macro_server_choice(&self, dir: &AbsPath) -> ProcMacroServerChoice {
        match &self.proc_macro_server {
            Some(path) => match path.to_str() {
                Some("none") => ProcMacroServerChoice::None,
                Some("sysroot") => ProcMacroServerChoice::Sysroot,
                _ => ProcMacroServerChoice::Explicit(join_path_buf(dir, path)),
            },
            None => ProcMacroServerChoice::Sysroot,
        }
    }

    pub fn to_cargo_config(&self, dir: &AbsPath) -> (CargoConfig, LoadCargoConfig) {
        let sysroot = self.sysroot(dir);
        (
            CargoConfig {
                all_targets: self.cargo_all_targets,
                sysroot_src: sysroot.rust_lib_src_root().map(ToOwned::to_owned),
                rustc_source: self
                    .rustc_src
                    .as_ref()
                    .map(|p| join_path_buf(dir, p))
                    .or_else(|| sysroot.discover_rustc_src().map(AbsPathBuf::from))
                    .map(RustLibSource::Path),
                sysroot: sysroot
                    .root()
                    .map(ToOwned::to_owned)
                    .map(RustLibSource::Path),

                extra_env: self.cargo_extra_env.clone(),
                extra_args: self.cargo_extra_args.clone(),
                extra_includes: self
                    .extra_includes
                    .iter()
                    .map(|p| join_path_buf(dir, p))
                    .collect(),
                target_dir: Utf8PathBuf::from_path_buf(
                    self.cargo_target_dir
                        .clone()
                        .unwrap_or_else(|| self.scratch_dir.join("target")),
                )
                .ok(),
                features: if self.cargo_features.is_empty() {
                    Default::default()
                } else if self.cargo_features.contains(&"*".to_string()) {
                    CargoFeatures::All
                } else {
                    CargoFeatures::Selected {
                        features: self.cargo_features.clone(),
                        no_default_features: false,
                    }
                },
                target: self.cargo_target.clone(),
                cfg_overrides: to_cfg_overrides(&self.cargo_cfg_overrides),
                wrap_rustc_in_build_scripts: false,
                run_build_script_command: if self.build_script_command.is_empty() {
                    None
                } else {
                    Some(self.build_script_command.clone())
                },
                ..Default::default()
            },
            LoadCargoConfig {
                load_out_dirs_from_check: true,
                with_proc_macro_server: self.proc_macro_server_choice(dir),
                prefill_caches: false,
            },
        )
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
    let global = CfgDiff::new(enabled_cfgs, disabled_cfgs);
    CfgOverrides {
        global,
        ..Default::default()
    }
}

fn join_path_buf(lhs: &AbsPath, rhs: &Path) -> AbsPathBuf {
    let Ok(path) = Utf8PathBuf::from_path_buf(rhs.into()) else {
        panic!("non utf8 input: {}", rhs.display())
    };
    lhs.join(path)
}
