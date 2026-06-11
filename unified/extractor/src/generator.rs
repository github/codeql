use clap::Args;
use std::path::PathBuf;

use codeql_extractor::generator::{generate, language::Language};

use crate::languages;

#[derive(Args)]
pub struct Options {
    /// Path of the generated dbscheme file
    #[arg(long)]
    dbscheme: PathBuf,

    /// Path of the generated QLL file
    #[arg(long)]
    library: PathBuf,
}

pub fn run(options: Options) -> std::io::Result<()> {
    codeql_extractor::extractor::set_tracing_level("unified");

    // The QL-visible schema is the unified output AST, not the per-language
    // input grammars. Pass it via `desugar.output_node_types_yaml` so the
    // generator converts the YAML to JSON node-types.
    let desugar = yeast::DesugaringConfig::new()
        .with_output_node_types_yaml(languages::OUTPUT_AST_SCHEMA);

    let languages = vec![Language {
        name: "Unified".to_owned(),
        node_types: "",   // unused: generator picks up output_node_types_yaml above
        desugar: Some(desugar),
    }];

    generate(languages, options.dbscheme, options.library, "run unified/scripts/create-extractor-pack.sh")
}
