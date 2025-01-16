use crate::config::Config;
use anyhow::Context;
use glob::glob;
use itertools::Itertools;
use log::info;
use std::ffi::OsStr;
use std::fs;
use std::process::Command;

fn dump_lib() -> anyhow::Result<()> {
    let path_iterator = glob("*.rs").context("globbing test sources")?;
    let paths = path_iterator
        .collect::<Result<Vec<_>, _>>()
        .context("fetching test sources")?;
    let lib = paths
        .iter()
        .map(|p| p.file_stem().expect("results of glob must have a name"))
        .filter(|&p| !["main", "lib"].map(OsStr::new).contains(&p))
        .map(|p| format!("mod {};", p.to_string_lossy()))
        .join("\n");
    fs::write("lib.rs", lib).context("writing lib.rs")
}

fn dump_cargo_manifest(dependencies: &[String]) -> anyhow::Result<()> {
    let mut manifest = String::from(
        r#"[workspace]
[package]
name = "test"
version="0.0.1"
edition="2021"
[lib]
path="lib.rs"
"#,
    );
    if fs::exists("main.rs").context("checking existence of main.rs")? {
        manifest.push_str(
            r#"[[bin]]
name = "main"
path = "main.rs"
"#,
        );
    }
    if !dependencies.is_empty() {
        manifest.push_str("[dependencies]\n");
        for dep in dependencies {
            manifest.push_str(dep);
            manifest.push('\n');
        }
    }
    fs::write("Cargo.toml", manifest).context("writing Cargo.toml")
}

fn set_sources(config: &mut Config) -> anyhow::Result<()> {
    let path_iterator = glob("**/*.rs").context("globbing test sources")?;
    config.inputs = path_iterator
        .collect::<Result<Vec<_>, _>>()
        .context("fetching test sources")?;
    Ok(())
}

pub(crate) fn prepare(config: &mut Config) -> anyhow::Result<()> {
    dump_lib()?;
    set_sources(config)?;
    dump_cargo_manifest(&config.qltest_dependencies)?;
    if config.qltest_cargo_check {
        let status = Command::new("cargo")
            .env("RUSTFLAGS", "-Awarnings")
            .arg("check")
            .arg("-q")
            .status()
            .context("spawning cargo check")?;
        if status.success() {
            info!("cargo check successful");
        } else {
            anyhow::bail!("requested cargo check failed");
        }
    }
    Ok(())
}
