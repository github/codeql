use std::fs;
use std::path::Path;

use codeql_extractor::extractor::simple;
use yeast::{Runner, dump::dump_ast, dump::dump_ast_with_type_errors};

#[path = "../src/languages/mod.rs"]
mod languages;

#[derive(Debug)]
struct CorpusCase {
    input: String,
    raw: String,
    expected: String,
}

fn update_mode_enabled() -> bool {
    std::env::var("UNIFIED_UPDATE_CORPUS")
        .map(|v| matches!(v.to_ascii_lowercase().as_str(), "1" | "true" | "yes" | "on"))
        .unwrap_or(false)
}

/// Parse a corpus `.output` file. The file holds a single test case made of
/// three sections separated by `---` delimiter lines:
///
/// ```text
/// <test case source>
///
/// ---
///
/// <raw tree-sitter parse tree>
///
/// ---
///
/// <mapped AST>
/// ```
///
/// The test name is the file name, so there is no header section. Missing
/// trailing sections (e.g. a freshly added file) are treated as empty.
fn parse_corpus(content: &str) -> CorpusCase {
    let lines: Vec<&str> = content.split('\n').collect();
    let mut sections = lines
        .split(|line| line.trim() == "---")
        .map(|chunk| chunk.join("\n").trim().to_string());

    CorpusCase {
        input: sections.next().unwrap_or_default(),
        raw: sections.next().unwrap_or_default(),
        expected: sections.next().unwrap_or_default(),
    }
}

fn render_corpus(case: &CorpusCase) -> String {
    format!(
        "{}\n\n---\n\n{}\n\n---\n\n{}\n",
        case.input.trim(),
        case.raw.trim(),
        case.expected.trim()
    )
}

fn run_desugaring(lang: &simple::LanguageSpec, input: &str) -> Result<yeast::Ast, String> {
    match lang.desugar.as_deref() {
        Some(desugarer) => {
            // Parse the input ourselves so we don't depend on the desugarer
            // knowing about the language.
            let mut parser = tree_sitter::Parser::new();
            parser
                .set_language(&lang.ts_language)
                .map_err(|e| format!("Failed to set language: {e}"))?;
            let tree = parser
                .parse(input, None)
                .ok_or_else(|| "Failed to parse input".to_string())?;
            desugarer
                .run_from_tree(&tree, input.as_bytes())
                .map_err(|e| format!("Desugaring failed: {e}"))
        }
        None => {
            let runner: Runner = Runner::new(lang.ts_language.clone(), &[]);
            runner
                .run(input)
                .map_err(|e| format!("Failed to parse input: {e}"))
        }
    }
}

/// Produce the raw tree-sitter parse tree dump for `input`, with no
/// desugaring rules applied. Uses a `Runner` with an empty phase list and
/// the input grammar's own schema.
fn dump_raw_parse(lang: &simple::LanguageSpec, input: &str) -> Result<String, String> {
    let runner: Runner = Runner::new(lang.ts_language.clone(), &[]);
    let ast = runner
        .run(input)
        .map_err(|e| format!("Failed to parse input: {e}"))?;
    Ok(dump_ast(&ast, ast.get_root(), input))
}

/// Collect the set of corpus test "stems" (paths without an extension) under
/// `dir`. A stem is discovered from either a `.swift` source file or a
/// `.output` file, so that a `.swift` with no `.output` (a freshly added test)
/// and an orphaned `.output` with no `.swift` are both surfaced.
fn collect_corpus_stems(dir: &Path, out: &mut Vec<std::path::PathBuf>) {
    let entries = fs::read_dir(dir)
        .unwrap_or_else(|e| panic!("Failed to read corpus directory {}: {e}", dir.display()));
    for entry in entries {
        let path = entry.expect("Failed to read corpus entry").path();
        if path.is_dir() {
            collect_corpus_stems(&path, out);
        } else if path
            .extension()
            .is_some_and(|ext| ext == "swift" || ext == "output")
        {
            out.push(path.with_extension(""));
        }
    }
}

#[test]
fn test_corpus() {
    let update_mode = update_mode_enabled();
    let all_languages = languages::all_language_specs();
    let corpus_dir = Path::new("tests/corpus");

    for lang in all_languages {
        let output_schema = yeast::node_types_yaml::schema_from_yaml_with_language(
            languages::OUTPUT_AST_SCHEMA,
            &lang.ts_language,
        )
        .expect("Failed to parse OUTPUT_AST_SCHEMA YAML");

        let lang_corpus_dir = corpus_dir.join(&lang.prefix);
        if !lang_corpus_dir.exists() {
            continue;
        }

        let mut stems = Vec::new();
        collect_corpus_stems(&lang_corpus_dir, &mut stems);
        stems.sort();
        stems.dedup();

        for stem in stems {
            let swift_path = stem.with_extension("swift");
            let output_path = stem.with_extension("output");
            let mut failures = Vec::new();

            // The canonical test case lives in the `.swift` file and is the
            // source of truth. An `.output` file without a `.swift` sibling is
            // an orphan: there is nothing to drive it from.
            if !swift_path.exists() {
                panic!(
                    "Found {} with no corresponding test case; add {} or remove the output file",
                    output_path.display(),
                    swift_path.display()
                );
            }

            let swift_input = fs::read_to_string(&swift_path)
                .unwrap_or_else(|e| panic!("Failed to read {}: {e}", swift_path.display()))
                .trim()
                .to_string();

            // Build the case from the existing `.output` file when present.
            // When it is missing (a freshly added `.swift`), start from an
            // empty case: update mode will generate it, and a normal test run
            // reports the missing output.
            let mut case = if output_path.exists() {
                let content = fs::read_to_string(&output_path)
                    .unwrap_or_else(|e| panic!("Failed to read {}: {e}", output_path.display()));
                parse_corpus(&content)
            } else {
                if !update_mode {
                    failures.push(format!(
                        "Missing output file {}; run scripts/update-corpus.sh to generate it",
                        output_path.display()
                    ));
                }
                CorpusCase {
                    input: String::new(),
                    raw: String::new(),
                    expected: String::new(),
                }
            };

            {
                // The input section in the `.output` file is a generated copy
                // of the `.swift` source, kept only so reviewers can see the
                // source alongside its printed ASTs.
                if update_mode {
                    case.input = swift_input.clone();
                } else if output_path.exists() && case.input.trim() != swift_input {
                    failures.push(format!(
                        "Test case copy out of date in {}; rerun update-corpus to regenerate from {}",
                        output_path.display(),
                        swift_path.display()
                    ));
                }
                // Ensure the AST passes below operate on the source of truth.
                let case_input = swift_input.clone();

                match dump_raw_parse(&lang, &case_input) {
                    Err(e) => {
                        failures.push(format!(
                            "Raw parse failed in {}: {}",
                            output_path.display(),
                            e
                        ));
                    }
                    Ok(actual_raw) => {
                        if update_mode {
                            case.raw = actual_raw.trim().to_string();
                        } else if output_path.exists() && case.raw.trim() != actual_raw.trim() {
                            failures.push(format!(
                                "Raw parse mismatch in {}:\nEXPECTED:\n\n{}\n\nACTUAL:\n\n{}",
                                output_path.display(),
                                case.raw.trim(),
                                actual_raw.trim()
                            ));
                        }
                    }
                }

                match run_desugaring(&lang, &case_input) {
                    Err(e) => {
                        failures.push(format!(
                            "Desugaring failed in {}: {}",
                            output_path.display(),
                            e
                        ));
                    }
                    Ok(actual) => {
                        let actual_dump = dump_ast_with_type_errors(
                            &actual,
                            actual.get_root(),
                            &case_input,
                            &output_schema,
                        );
                        if update_mode {
                            case.expected = actual_dump.trim().to_string();
                        } else if output_path.exists()
                            && case.expected.trim() != actual_dump.trim()
                        {
                            failures.push(format!(
                                "Test failed in {}:\nEXPECTED:\n\n{}\n\nACTUAL:\n\n{}",
                                output_path.display(),
                                case.expected.trim(),
                                actual_dump.trim()
                            ));
                        }
                    }
                }
            }

            assert!(failures.is_empty(), "{}", failures.join("\n\n") + "\n\n");

            if update_mode {
                let updated = render_corpus(&case);
                let write_result = fs::write(&output_path, updated);
                assert!(
                    write_result.is_ok(),
                    "Failed to update corpus file {}: {}",
                    output_path.display(),
                    write_result
                        .err()
                        .map_or_else(String::new, |e| e.to_string())
                );
            }
        }
    }
}
