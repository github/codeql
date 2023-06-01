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
}
