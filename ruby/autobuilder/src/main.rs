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
    let mut cmd = Command::new(codeql);
    cmd.arg("database")
        .arg("index-files")
        .arg("--include-extension=.rb")
        .arg("--include-extension=.erb")
        .arg("--include-extension=.gemspec")
        .arg("--include=**/Gemfile")
        .arg("--size-limit=5m")
        .arg("--language=ruby")
        .arg("--working-dir=.")
        .arg(db);

    for line in env::var("LGTM_INDEX_FILTERS")
        .unwrap_or_default()
        .split('\n')
    {
        if let Some(stripped) = line.strip_prefix("include:") {
            cmd.arg("--include").arg(stripped);
        } else if let Some(stripped) = line.strip_prefix("exclude:") {
            cmd.arg("--exclude").arg(stripped);
        }
    }
    let exit = &cmd.spawn()?.wait()?;
    std::process::exit(exit.code().unwrap_or(1))
}
