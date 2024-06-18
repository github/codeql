use std::env;
use std::path::PathBuf;
use std::process::Command;

pub struct Autobuilder {
    include_extensions: Vec<String>,
    include_globs: Vec<String>,
    exclude_globs: Vec<String>,
    language: String,
    database: PathBuf,
    size_limit: Option<String>,
}

impl Autobuilder {
    pub fn new(language: &str, database: PathBuf) -> Self {
        Self {
            language: language.to_string(),
            database,
            include_extensions: vec![],
            include_globs: vec![],
            exclude_globs: vec![],
            size_limit: None,
        }
    }

    pub fn include_extensions(&mut self, exts: &[&str]) -> &mut Self {
        self.include_extensions = exts.iter().map(|s| String::from(*s)).collect();
        self
    }

    pub fn include_globs(&mut self, globs: &[&str]) -> &mut Self {
        self.include_globs = globs.iter().map(|s| String::from(*s)).collect();
        self
    }

    pub fn exclude_globs(&mut self, globs: &[&str]) -> &mut Self {
        self.exclude_globs = globs.iter().map(|s| String::from(*s)).collect();
        self
    }

    pub fn size_limit(&mut self, limit: &str) -> &mut Self {
        self.size_limit = Some(limit.to_string());
        self
    }

    pub fn run(&self) -> std::io::Result<()> {
        let dist = env::var("CODEQL_DIST").expect("CODEQL_DIST not set");
        let codeql = if env::consts::OS == "windows" {
            "codeql.exe"
        } else {
            "codeql"
        };
        let codeql: PathBuf = [&dist, codeql].iter().collect();
        let mut cmd = Command::new(codeql);
        cmd.arg("database").arg("index-files");

        let verbosity = env::var("CODEQL_VERBOSITY");

        if let Ok(verbosity) = verbosity {
            cmd.arg(format!("--verbosity={}", verbosity));
        }

        for ext in &self.include_extensions {
            cmd.arg(format!("--include-extension={}", ext));
        }

        for glob in &self.include_globs {
            cmd.arg(format!("--include={}", glob));
        }

        for glob in &self.exclude_globs {
            cmd.arg(format!("--exclude={}", glob));
        }

        if let Some(limit) = &self.size_limit {
            cmd.arg(format!("--size-limit={}", limit));
        }

        cmd.arg(format!("--language={}", &self.language));
        cmd.arg("--working-dir=.");
        cmd.arg(&self.database);

        // LGTM_INDEX_FILTERS is a prioritized list of include/exclude filters, where
        // later filters take priority over earlier ones.
        // 1) If we only see includes, we should ignore everything else, which is
        //    achieved by using `--also-match={filter}`.
        // 2) if we see both includes and excludes, we process them in order by using
        //    `--also-match={filter}` for includes and `--also-match=!{filter}` for
        //    excludes.
        // 3) If we only see excludes, we should accept everything else. Naive solution
        //    of just using `--also-match=!{filter}` is not good enough, since nothing
        //    will make the `--also-match`` pass for any file. In that case, we add a dummy
        //    initial `--also-match=**/*``to get the desired behavior.
        let tmp = env::var("LGTM_INDEX_FILTERS").unwrap_or_default();
        let lgtm_index_filters = tmp.split('\n');
        let lgtm_index_filters_has_include = lgtm_index_filters
            .clone()
            .any(|s| s.starts_with("include:"));
        let lgtm_index_filters_has_exclude = lgtm_index_filters
            .clone()
            .any(|s| s.starts_with("exclude:"));

        if !lgtm_index_filters_has_include && lgtm_index_filters_has_exclude {
            cmd.arg("--also-match=**/*");
        }

        for line in lgtm_index_filters {
            if let Some(stripped) = line.strip_prefix("include:") {
                cmd.arg("--also-match=".to_owned() + stripped);
            } else if let Some(stripped) = line.strip_prefix("exclude:") {
                cmd.arg("--also-match=!".to_owned() + stripped);
            }
        }
        let exit = &cmd.spawn()?.wait()?;
        std::process::exit(exit.code().unwrap_or(1))
    }
}
