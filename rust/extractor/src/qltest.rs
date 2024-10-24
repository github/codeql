use crate::config::Config;
use anyhow::Context;
use glob::glob;
use itertools::Itertools;
use log::info;
use std::fs;
use std::process::Command;

fn dump_lib() -> anyhow::Result<()> {
    let path_iterator = glob("*.rs").context("globbing test sources")?;
    let paths = path_iterator
        .collect::<Result<Vec<_>, _>>()
        .context("fetching test sources")?;
    let lib = paths
        .iter()
        .filter(|p| !["lib.rs", "main.rs"].contains(&p.file_name().unwrap().to_str().unwrap()))
        .map(|p| format!("mod {};", p.file_stem().unwrap().to_str().unwrap()))
        .join("\n");
    fs::write("lib.rs", lib).context("writing lib.rs")
}

fn dump_cargo_manifest() -> anyhow::Result<()> {
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
    fs::write("Cargo.toml", manifest).context("writing Cargo.toml")
}

fn set_sources(config: &mut Config) -> anyhow::Result<()> {
    let path_iterator = glob("*.rs").context("globbing test sources")?;
    config.inputs = path_iterator
        .collect::<Result<Vec<_>, _>>()
        .context("fetching test sources")?;
    Ok(())
}

fn redirect_output(config: &Config) -> anyhow::Result<()> {
    let log_path = config.log_dir.join("qltest.log");
    let log = fs::OpenOptions::new()
        .append(true)
        .create(true)
        .open(&log_path)
        .context("opening qltest.log")?;
    Box::leak(Box::new(
        gag::Redirect::stderr(log).context("redirecting stderr")?,
    ));
    Ok(())
}

pub(crate) fn prepare(config: &mut Config) -> anyhow::Result<()> {
    redirect_output(config)?;
    dump_lib()?;
    set_sources(config)?;
    dump_cargo_manifest()?;
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
