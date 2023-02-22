use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() -> std::io::Result<()> {
    let dist = env::var("CODEQL_DIST").expect("CODEQL_DIST not set");
    let db = env::var("CODEQL_EXTRACTOR_QL_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_QL_WIP_DATABASE not set");
    let codeql = if env::consts::OS == "windows" {
        "codeql.exe"
    } else {
        "codeql"
    };
    let codeql: PathBuf = [&dist, codeql].iter().collect();
    let mut cmd = Command::new(codeql);
    cmd.arg("database")
        .arg("index-files")
        .arg("--include-extension=.ql")
        .arg("--include-extension=.qll")
        .arg("--include-extension=.dbscheme")
        .arg("--include-extension=.json")
        .arg("--include-extension=.jsonc")
        .arg("--include-extension=.jsonl")
        .arg("--include=**/qlpack.yml")
        .arg("--include=deprecated.blame")
        .arg("--size-limit=10m")
        .arg("--language=ql")
        .arg("--working-dir=.")
        .arg(db);

    for line in env::var("LGTM_INDEX_FILTERS")
        .unwrap_or_default()
        .split('\n')
    {
        if let Some(stripped) = line.strip_prefix("include:") {
            cmd.arg("--also-match=".to_owned() + stripped);
        } else if let Some(stripped) = line.strip_prefix("exclude:") {
            cmd.arg("--exclude=".to_owned() + stripped);
        }
    }
    let exit = &cmd.spawn()?.wait()?;
    std::process::exit(exit.code().unwrap_or(1))
}
