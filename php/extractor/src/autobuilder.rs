/// PHP CodeQL Autobuilder Module
/// Automatically detects PHP project types and configures extraction

use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use std::process::Command;
use std::env;
use clap::Parser;
use anyhow::Result;

/// Supported PHP project types
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ProjectType {
    WordPress,
    Laravel,
    Symfony,
    Drupal,
    Magento,
    Joomla,
    CodeIgniter,
    CakePHP,
    Yii,
    Laminas,
    Generic,
}

impl ProjectType {
    pub fn as_str(&self) -> &str {
        match self {
            ProjectType::WordPress => "wordpress",
            ProjectType::Laravel => "laravel",
            ProjectType::Symfony => "symfony",
            ProjectType::Drupal => "drupal",
            ProjectType::Magento => "magento",
            ProjectType::Joomla => "joomla",
            ProjectType::CodeIgniter => "codeigniter",
            ProjectType::CakePHP => "cakephp",
            ProjectType::Yii => "yii",
            ProjectType::Laminas => "laminas",
            ProjectType::Generic => "generic",
        }
    }
}

/// Command-line options for the autobuild command
#[derive(Parser, Debug)]
pub struct AutobuildOptions {
    /// Source root directory to analyze
    #[arg(long, default_value = ".")]
    pub source_root: PathBuf,

    /// Output directory for TRAP files
    #[arg(long, default_value = "out")]
    pub output: PathBuf,

    /// Verbose output
    #[arg(long, short)]
    pub verbose: bool,
}

/// Project information detected by autobuilder
#[derive(Debug, Clone)]
pub struct ProjectInfo {
    pub project_type: ProjectType,
    pub root: PathBuf,
    pub php_file_count: usize,
    pub has_composer: bool,
    pub has_npm: bool,
    pub has_config: bool,
    pub php_version: Option<String>,
    pub framework_version: Option<String>,
}

impl ProjectInfo {
    /// Create new project info
    pub fn new(project_type: ProjectType, root: PathBuf) -> Self {
        ProjectInfo {
            project_type,
            root,
            php_file_count: 0,
            has_composer: false,
            has_npm: false,
            has_config: false,
            php_version: None,
            framework_version: None,
        }
    }

    /// Get list of directories to analyze
    pub fn analysis_directories(&self) -> Vec<&str> {
        match self.project_type {
            ProjectType::WordPress => vec!["wp-admin", "wp-includes", "wp-content"],
            ProjectType::Laravel => vec!["app", "routes", "bootstrap"],
            ProjectType::Symfony => vec!["src", "config", "public"],
            ProjectType::Drupal => vec!["core", "modules", "themes"],
            ProjectType::Magento => vec!["app", "lib", "pub"],
            ProjectType::Joomla => vec!["administrator", "components", "modules"],
            ProjectType::CodeIgniter => vec!["app", "system"],
            ProjectType::CakePHP => vec!["src"],
            ProjectType::Yii => vec![""],
            ProjectType::Laminas => vec!["src", "config"],
            ProjectType::Generic => vec![""],
        }
    }

    /// Get list of directories to exclude from analysis
    pub fn exclude_directories(&self) -> Vec<&str> {
        vec![
            "vendor",
            "node_modules",
            ".git",
            "build",
            "dist",
            ".cache",
            "tmp",
            "temp",
            "tests",
            "test",
        ]
    }

    /// Get configuration file patterns for this project type
    pub fn config_patterns(&self) -> Vec<&str> {
        match self.project_type {
            ProjectType::WordPress => vec!["wp-config.php", "wp-settings.php"],
            ProjectType::Laravel => vec![".env", "config/app.php", "config/database.php"],
            ProjectType::Symfony => vec![".env", "config/services.yaml", "config/bundles.php"],
            ProjectType::Drupal => vec!["sites/default/settings.php"],
            ProjectType::Magento => vec!["app/etc/config.php", ".env"],
            ProjectType::Joomla => vec!["configuration.php"],
            ProjectType::CodeIgniter => vec![".env", "app/Config/App.php"],
            ProjectType::CakePHP => vec!["config/app.php", ".env"],
            ProjectType::Yii => vec!["config/web.php", "config/console.php"],
            ProjectType::Laminas => vec![".env", "config/config.php"],
            ProjectType::Generic => vec![".env"],
        }
    }

    /// Get entry point files for this project type
    pub fn entry_points(&self) -> Vec<&str> {
        match self.project_type {
            ProjectType::WordPress => vec!["index.php", "wp-blog-header.php"],
            ProjectType::Laravel => vec!["bootstrap/app.php", "artisan"],
            ProjectType::Symfony => vec!["public/index.php", "bin/console"],
            ProjectType::Drupal => vec!["index.php"],
            ProjectType::Magento => vec!["index.php"],
            ProjectType::Joomla => vec!["index.php"],
            ProjectType::CodeIgniter => vec!["index.php"],
            ProjectType::CakePHP => vec!["index.php", "bin/cake"],
            ProjectType::Yii => vec!["web/index.php"],
            ProjectType::Laminas => vec!["public/index.php"],
            ProjectType::Generic => vec!["index.php"],
        }
    }
}

/// Autobuilder for PHP projects
pub struct Autobuilder {
    pub info: ProjectInfo,
}

impl Autobuilder {
    /// Detect project type from source root
    pub fn detect(root: &Path) -> ProjectInfo {
        let project_type = Self::detect_type(root);
        let mut info = ProjectInfo::new(project_type, root.to_path_buf());

        // Count PHP files
        info.php_file_count = Self::count_php_files(root, &info);

        // Check for manifest files
        info.has_composer = root.join("composer.json").exists();
        info.has_npm = root.join("package.json").exists();
        info.has_config = info
            .config_patterns()
            .iter()
            .any(|pattern| root.join(pattern).exists());

        info
    }

    /// Detect the project type
    fn detect_type(root: &Path) -> ProjectType {
        // Check WordPress
        if root.join("wp-config-sample.php").exists()
            || root.join("wp-config.php").exists()
        {
            return ProjectType::WordPress;
        }

        // Check Laravel
        if root.join("artisan").exists() {
            if let Ok(content) = fs::read_to_string(root.join("composer.json")) {
                if content.contains("laravel") {
                    return ProjectType::Laravel;
                }
            }
        }

        // Check Symfony
        if root.join("symfony.lock").exists() || root.join("config/bundles.php").exists() {
            return ProjectType::Symfony;
        }

        // Check Drupal
        if root.join("core/core.info.yml").exists()
            || root.join("core/modules").exists()
        {
            return ProjectType::Drupal;
        }

        // Check Magento
        if root.join("app/code").exists() {
            if let Ok(content) = fs::read_to_string(root.join("composer.json")) {
                if content.contains("magento") {
                    return ProjectType::Magento;
                }
            }
        }

        // Check Joomla
        if root.join("configuration.php").exists() || root.join("components").exists() {
            return ProjectType::Joomla;
        }

        // Check CodeIgniter
        if root.join("spark").exists() || root.join("app/Controllers").exists() {
            return ProjectType::CodeIgniter;
        }

        // Check CakePHP
        if root.join("bin/cake").exists() || root.join("config/bootstrap.php").exists() {
            return ProjectType::CakePHP;
        }

        // Check Yii
        if root.join("yii").exists() || root.join("models").exists() {
            return ProjectType::Yii;
        }

        // Check Laminas/Zend
        if let Ok(content) = fs::read_to_string(root.join("composer.json")) {
            if content.contains("laminas") || content.contains("zend") {
                return ProjectType::Laminas;
            }
        }

        // Default to generic
        ProjectType::Generic
    }

    /// Count PHP files in the project
    fn count_php_files(root: &Path, info: &ProjectInfo) -> usize {
        let mut count = 0;

        // Walk through analysis directories
        for dir in info.analysis_directories() {
            if !dir.is_empty() {
                let dir_path = root.join(dir);
                if dir_path.exists() {
                    count += Self::count_in_dir(&dir_path, info);
                }
            } else {
                count = Self::count_in_dir(root, info);
            }
        }

        count
    }

    /// Count PHP files in a directory
    fn count_in_dir(path: &Path, info: &ProjectInfo) -> usize {
        let mut count = 0;

        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries {
                if let Ok(entry) = entry {
                    let path = entry.path();

                    // Skip excluded directories
                    if path.is_dir() {
                        if let Some(name) = path.file_name() {
                            if let Some(name_str) = name.to_str() {
                                if info.exclude_directories().contains(&name_str) {
                                    continue;
                                }
                            }
                        }

                        // Recurse into subdirectories
                        count += Self::count_in_dir(&path, info);
                    } else if path.extension().map_or(false, |ext| ext == "php") {
                        count += 1;
                    }
                }
            }
        }

        count
    }

    /// Get configuration for this project
    pub fn get_config(&self) -> HashMap<String, String> {
        let mut config = HashMap::new();

        config.insert(
            "project_type".to_string(),
            self.info.project_type.as_str().to_string(),
        );
        config.insert(
            "php_files".to_string(),
            self.info.php_file_count.to_string(),
        );
        config.insert(
            "has_composer".to_string(),
            self.info.has_composer.to_string(),
        );
        config.insert("has_npm".to_string(), self.info.has_npm.to_string());
        config.insert("has_config".to_string(), self.info.has_config.to_string());

        if let Some(version) = &self.info.php_version {
            config.insert("php_version".to_string(), version.clone());
        }

        if let Some(version) = &self.info.framework_version {
            config.insert("framework_version".to_string(), version.clone());
        }

        config
    }

    /// Log project information
    pub fn log_info(&self) {
        eprintln!("PHP Autobuilder Report:");
        eprintln!("  Project Type: {}", self.info.project_type.as_str());
        eprintln!("  Root: {}", self.info.root.display());
        eprintln!("  PHP Files: {}", self.info.php_file_count);
        eprintln!("  Has Composer: {}", self.info.has_composer);
        eprintln!("  Has NPM: {}", self.info.has_npm);
        eprintln!("  Has Config: {}", self.info.has_config);

        if let Some(version) = &self.info.php_version {
            eprintln!("  PHP Version: {}", version);
        }

        if let Some(version) = &self.info.framework_version {
            eprintln!("  Framework Version: {}", version);
        }
    }
}

/// Main autobuild entry point - integrates with CodeQL database indexing
/// Following the Kaleidoscope pattern, this function invokes CodeQL's database
/// index-files command to index PHP files into the database
pub fn autobuild(_opts: AutobuildOptions) -> Result<()> {
    // Get CodeQL CLI path from environment
    let codeql_dist = env::var("CODEQL_DIST")
        .or_else(|_| env::var("CODEQL_HOME"))
        .unwrap_or_else(|_| "codeql".to_string());

    // Get the work-in-progress database path from environment
    let wip_database = env::var("CODEQL_EXTRACTOR_PHP_WIP_DATABASE")
        .unwrap_or_else(|_| ".codeql-database".to_string());

    // Determine the platform
    let codeql_exe = if env::consts::OS == "windows" {
        format!("{}\\codeql.exe", codeql_dist)
    } else {
        format!("{}/codeql", codeql_dist)
    };

    // Build the CodeQL database index-files command
    // This follows the Kaleidoscope pattern of delegating to CodeQL CLI
    let mut cmd = Command::new(&codeql_exe);

    cmd.arg("database")
        .arg("index-files")
        .arg("--include-extension=.php")
        .arg("--include-extension=.php5")
        .arg("--include-extension=.php7")
        .arg("--size-limit=10m")
        .arg("--language=php")
        .arg("--working-dir=.")
        .arg(&wip_database);

    // Handle LGTM_INDEX_FILTERS environment variable for dynamic include/exclude patterns
    // This is a standard CodeQL environment variable for customizing file inclusion
    if let Ok(filters) = env::var("LGTM_INDEX_FILTERS") {
        for line in filters.lines() {
            if let Some(stripped) = line.strip_prefix("include:") {
                cmd.arg(format!("--also-match={}", stripped));
            } else if let Some(stripped) = line.strip_prefix("exclude:") {
                cmd.arg(format!("--exclude={}", stripped));
            }
        }
    }

    // Log what we're doing
    if env::var("CODEQL_VERBOSE").is_ok() {
        eprintln!("PHP Autobuilder: Invoking CodeQL CLI");
        eprintln!("  CodeQL: {}", codeql_exe);
        eprintln!("  Database: {}", wip_database);
        eprintln!("  Command: {:?}", cmd);
    }

    // Execute the CodeQL command
    let exit_status = cmd.spawn()
        .map_err(|e| anyhow::anyhow!("Failed to spawn CodeQL process: {}", e))?
        .wait()
        .map_err(|e| anyhow::anyhow!("Failed to wait for CodeQL process: {}", e))?;

    // Exit with the same code as CodeQL
    std::process::exit(exit_status.code().unwrap_or(1));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_project_type_names() {
        assert_eq!(ProjectType::WordPress.as_str(), "wordpress");
        assert_eq!(ProjectType::Laravel.as_str(), "laravel");
        assert_eq!(ProjectType::Symfony.as_str(), "symfony");
        assert_eq!(ProjectType::Drupal.as_str(), "drupal");
        assert_eq!(ProjectType::Magento.as_str(), "magento");
        assert_eq!(ProjectType::Joomla.as_str(), "joomla");
        assert_eq!(ProjectType::CodeIgniter.as_str(), "codeigniter");
        assert_eq!(ProjectType::CakePHP.as_str(), "cakephp");
        assert_eq!(ProjectType::Yii.as_str(), "yii");
        assert_eq!(ProjectType::Laminas.as_str(), "laminas");
        assert_eq!(ProjectType::Generic.as_str(), "generic");
    }

    #[test]
    fn test_project_info_creation() {
        let info = ProjectInfo::new(ProjectType::WordPress, PathBuf::from("/test"));
        assert_eq!(info.project_type, ProjectType::WordPress);
        assert_eq!(info.root, PathBuf::from("/test"));
        assert_eq!(info.php_file_count, 0);
        assert!(!info.has_composer);
    }

    #[test]
    fn test_wordpress_analysis_dirs() {
        let info = ProjectInfo::new(ProjectType::WordPress, PathBuf::from("/test"));
        let dirs = info.analysis_directories();
        assert_eq!(dirs.len(), 3);
        assert!(dirs.contains(&"wp-admin"));
        assert!(dirs.contains(&"wp-includes"));
        assert!(dirs.contains(&"wp-content"));
    }

    #[test]
    fn test_laravel_analysis_dirs() {
        let info = ProjectInfo::new(ProjectType::Laravel, PathBuf::from("/test"));
        let dirs = info.analysis_directories();
        assert_eq!(dirs.len(), 3);
        assert!(dirs.contains(&"app"));
        assert!(dirs.contains(&"routes"));
        assert!(dirs.contains(&"bootstrap"));
    }

    #[test]
    fn test_exclude_directories() {
        let info = ProjectInfo::new(ProjectType::WordPress, PathBuf::from("/test"));
        let exclude = info.exclude_directories();
        assert!(exclude.contains(&"vendor"));
        assert!(exclude.contains(&"node_modules"));
        assert!(exclude.contains(&".git"));
        assert!(exclude.contains(&"tests"));
    }
}
