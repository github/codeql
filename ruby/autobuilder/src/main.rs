use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() -> std::io::Result<()> {
    let dist = env::var("CODEQL_DIST").expect("CODEQL_DIST not set");
    let db = env::var("CODEQL_EXTRACTOR_RUBY_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_RUBY_WIP_DATABASE not set");
    let codeql = if env::consts::OS == "windows" {
        "codeql.exe"
    } else {
        "codeql"
    };
    let codeql: PathBuf = [&dist, codeql].iter().collect();
    let mut includes = Vec::new();
    let mut excludes = Vec::new();
    let lgtm_index_filters = env::var("LGTM_INDEX_FILTERS").unwrap_or_default();
    for line in lgtm_index_filters.split('\n') {
        if let Some(stripped) = line.strip_prefix("include:") {
            includes.push(stripped);
        } else if let Some(stripped) = line.strip_prefix("exclude:") {
            excludes.push(stripped);
        }
    }
    let mut cmd = Command::new(codeql);
    cmd.arg("database")
        .arg("index-files")
        .arg("--include-extension=.rb")
        .arg("--include-extension=.erb")
        .arg("--include-extension=.gemspec")
        .arg("--size-limit=5m")
        .arg("--language=ruby")
        .arg("--working-dir=.");
    if includes.len() > 0 {
        // exclude everything by default
        cmd.arg("--include").arg("!**");
    }
    cmd.arg("--include=**/Gemfile");
    for pattern in includes {
        cmd.arg("--include").arg(pattern);
    }
    for pattern in excludes {
        cmd.arg("--exclude").arg(pattern);
    }
    cmd.arg("--");
    cmd.arg(db);

    let exit = &cmd.spawn()?.wait()?;
    std::process::exit(exit.code().unwrap_or(1))
}
