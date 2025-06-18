use crate::config::Config;
use anyhow::Context;
use glob::glob;
use itertools::Itertools;
use std::ffi::OsStr;
use std::fs;
use std::path::Path;
use std::process::Command;
use tracing::info;

fn dump_lib() -> anyhow::Result<()> {
    let path_iterator = glob("*.rs").context("globbing test sources")?;
    let paths = path_iterator
        .collect::<Result<Vec<_>, _>>()
        .context("fetching test sources")?;
    let lib = paths
        .iter()
        .map(|p| p.file_stem().expect("results of glob must have a name"))
        .filter(|&p| !["main", "lib", "proc_macro"].map(OsStr::new).contains(&p))
        .map(|p| format!("mod {};", p.to_string_lossy()))
        .join("\n");
    fs::write("lib.rs", lib).context("writing lib.rs")
}

#[derive(serde::Serialize)]
enum TestCargoManifest<'a> {
    Workspace {},
    Lib {
        uses_proc_macro: bool,
        uses_main: bool,
        dependencies: &'a [String],
    },
    Macro {},
}

impl TestCargoManifest<'_> {
    pub fn dump(&self, path: impl AsRef<Path>) -> anyhow::Result<()> {
        static TEMPLATE: std::sync::LazyLock<mustache::Template> = std::sync::LazyLock::new(|| {
            mustache::compile_str(include_str!("qltest_cargo.mustache"))
                .expect("compiling template")
        });

        let path = path.as_ref();
        fs::create_dir_all(path).with_context(|| format!("creating {}", path.display()))?;
        let path = path.join("Cargo.toml");
        let rendered = TEMPLATE
            .render_to_string(&self)
            .with_context(|| format!("rendering {}", path.display()))?;
        fs::write(&path, rendered).with_context(|| format!("writing {}", path.display()))
    }
}
fn dump_cargo_manifest(dependencies: &[String]) -> anyhow::Result<()> {
    let uses_proc_macro =
        fs::exists("proc_macro.rs").context("checking existence of proc_macro.rs")?;
    let lib_manifest = TestCargoManifest::Lib {
        uses_proc_macro,
        uses_main: fs::exists("main.rs").context("checking existence of main.rs")?,
        dependencies,
    };
    if uses_proc_macro {
        TestCargoManifest::Workspace {}.dump("")?;
        lib_manifest.dump(".lib")?;
        TestCargoManifest::Macro {}.dump(".proc_macro")
    } else {
        lib_manifest.dump("")
    }
}

fn set_sources(config: &mut Config) -> anyhow::Result<()> {
    let path_iterator = glob("**/*.rs").context("globbing test sources")?;
    config.inputs = path_iterator
        .filter(|f| f.is_err() || !f.as_ref().unwrap().starts_with("target"))
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
