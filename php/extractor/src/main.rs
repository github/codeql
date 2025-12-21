/// CodeQL Extractor for PHP
///
/// This extractor processes PHP source code and generates CodeQL database facts
/// using the tree-sitter PHP grammar.

use anyhow::{Result, Context};
use clap::{Parser, Subcommand};
use std::path::PathBuf;
use tracing_subscriber::EnvFilter;

mod extractor;
mod generator;
mod autobuilder;
mod php8_features;
mod stats_generator;
mod dbscheme_parser;

/// CodeQL PHP Extractor
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
#[command(name = "codeql-extractor-php")]
struct Cli {
    /// Enable verbose output
    #[arg(global = true, short, long)]
    verbose: bool,

    /// Logging level (trace, debug, info, warn, error)
    #[arg(global = true, long, default_value = "info")]
    log_level: String,

    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Extract PHP source code into CodeQL database facts
    Extract(extractor::ExtractOptions),

    /// Generate database schema from tree-sitter grammar
    Generate(generator::Options),

    /// Generate statistics file for CodeQL query optimization
    StatsGenerate(StatsGenerateOptions),

    /// Discover PHP files in a directory tree
    Autobuild(autobuilder::AutobuildOptions),

    /// Print diagnostic information
    Diag,
}

/// Options for the stats-generate command
#[derive(Parser, Debug)]
pub struct StatsGenerateOptions {
    /// Path to php.dbscheme file
    #[arg(short, long)]
    pub dbscheme: PathBuf,

    /// Output path for generated stats file
    #[arg(short, long)]
    pub stats_output: PathBuf,

    /// Optional: source root for data-driven cardinality analysis
    #[arg(short, long)]
    pub source_root: Option<PathBuf>,

    /// Stats generation mode: 'basic' or 'advanced'
    #[arg(short, long, default_value = "basic")]
    pub mode: String,
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    // Initialize logging
    initialize_logging(&cli.log_level)?;

    // Dispatch to subcommand
    match cli.command {
        Commands::Extract(opts) => extractor::extract(opts)?,
        Commands::Generate(opts) => generator::run(opts)?,
        Commands::StatsGenerate(opts) => stats_generate(opts)?,
        Commands::Autobuild(opts) => autobuilder::autobuild(opts)?,
        Commands::Diag => print_diagnostics(),
    }

    Ok(())
}

/// Generate statistics file for CodeQL query optimization
fn stats_generate(opts: StatsGenerateOptions) -> Result<()> {
    tracing::info!("Generating stats file: {}", opts.stats_output.display());

    // Create stats generator with appropriate mode
    let mode = match opts.mode.as_str() {
        "basic" => stats_generator::StatsMode::Basic,
        "advanced" => stats_generator::StatsMode::Advanced,
        _ => return Err(anyhow::anyhow!("Unknown mode: {}. Use 'basic' or 'advanced'", opts.mode)),
    };

    let mut generator = stats_generator::StatsGenerator::new(opts.dbscheme.clone(), mode);

    // Parse the dbscheme file
    generator.parse_dbscheme()
        .context("Failed to parse dbscheme")?;

    // If source root provided, analyze actual code for accurate counts
    if let Some(source_root) = &opts.source_root {
        tracing::info!("Analyzing source code at: {}", source_root.display());
        generator.load_source_analysis(source_root)
            .context("Failed to analyze source")?;
    } else {
        // Use heuristic-based defaults
        tracing::info!("Using heuristic cardinality estimates");
        generator.estimate_cardinalities()
            .context("Failed to estimate cardinalities")?;
    }

    // Generate the stats file
    generator.generate_stats_file(&opts.stats_output)
        .context("Failed to generate stats file")?;

    tracing::info!("✓ Stats file generated: {}", opts.stats_output.display());
    eprintln!("✓ Stats file generated: {}", opts.stats_output.display());
    Ok(())
}

/// Initialize the logging subsystem
fn initialize_logging(level: &str) -> Result<()> {
    let env_filter = EnvFilter::try_from_default_env()
        .or_else(|_| EnvFilter::try_new(level))
        .unwrap_or_else(|_| EnvFilter::new("info"));

    tracing_subscriber::fmt()
        .with_env_filter(env_filter)
        .with_writer(std::io::stderr)
        .init();

    Ok(())
}

/// Print diagnostic information
fn print_diagnostics() {
    println!("CodeQL PHP Extractor Diagnostics");
    println!("=================================");
    println!();

    println!("Tree-sitter PHP version: {}", env!("CARGO_PKG_VERSION"));
    println!("Extractor version: {}", env!("CARGO_PKG_VERSION"));
    println!();

    println!("Supported file extensions:");
    println!("  - .php");
    println!("  - .php5");
    println!("  - .php7");
    println!("  - .php8");
    println!("  - .phtml");
    println!("  - .inc");
    println!();

    println!("Supported PHP versions: 5.6 - 8.3+");
    println!();

    println!("Build features:");
    println!("  - ZSTD compression: enabled");
    println!("  - Gzip compression: enabled");

    println!();
    println!("For more information, run with --help");
}
