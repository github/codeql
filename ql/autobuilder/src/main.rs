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
        .arg("--size-limit=5m")
        .arg("--language=ql")
        .arg("--working-dir=.")
        .arg(db);

    let mut has_include_dir = false; // TODO: This is a horrible hack, wait for the post-merge discussion in https://github.com/github/codeql/pull/7444 to be resolved
    for line in env::var("LGTM_INDEX_FILTERS")
        .unwrap_or_default()
        .split('\n')
    {
        if let Some(stripped) = line.strip_prefix("include:") {
            cmd.arg("--include").arg(stripped);
            has_include_dir = true;
        } else if let Some(stripped) = line.strip_prefix("exclude:") {
            cmd.arg("--exclude").arg(stripped);
        }
    }
    if !has_include_dir {
        cmd.arg("--include-extension=.ql")
            .arg("--include-extension=.qll")
            .arg("--include-extension=.dbscheme")
            .arg("--include=**/qlpack.yml");
    }
    let exit = &cmd.spawn()?.wait()?;
    std::process::exit(exit.code().unwrap_or(1))
}
