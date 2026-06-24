use std::fs;
use std::path::Path;

use codeql_extractor::extractor::simple;
use yeast::{dump::dump_ast, dump::dump_ast_with_type_errors, Runner};

#[path = "../src/languages/mod.rs"]
mod languages;

#[derive(Debug)]
struct CorpusCase {
    name: String,
    input: String,
    raw: String,
    expected: String,
}

fn update_mode_enabled() -> bool {
    std::env::var("UNIFIED_UPDATE_CORPUS")
        .map(|v| matches!(v.to_ascii_lowercase().as_str(), "1" | "true" | "yes" | "on"))
        .unwrap_or(false)
}

fn is_header_rule(line: &str) -> bool {
    let trimmed = line.trim();
    trimmed.len() >= 3 && trimmed.chars().all(|c| c == '=')
}

fn is_next_case_header(lines: &[&str], i: usize) -> bool {
    is_header_rule(lines[i])
        && i + 2 < lines.len()
        && !lines[i + 1].trim().is_empty()
        && is_header_rule(lines[i + 2])
}

fn parse_corpus(content: &str) -> Vec<CorpusCase> {
    let lines: Vec<&str> = content.lines().collect();
    let mut i = 0;
    let mut cases = Vec::new();

    while i < lines.len() {
        while i < lines.len() && lines[i].trim().is_empty() {
            i += 1;
        }
        if i >= lines.len() {
            break;
        }

        assert!(
            is_header_rule(lines[i]),
            "Expected header delimiter at line {}",
            i + 1
        );
        i += 1;

        assert!(i < lines.len(), "Missing test name at line {}", i + 1);
        let name = lines[i].trim().to_string();
        i += 1;

        assert!(
            i < lines.len() && is_header_rule(lines[i]),
            "Missing closing header delimiter for case {name}"
        );
        i += 1;

        let input_start = i;
        while i < lines.len() && lines[i].trim() != "---" {
            if is_next_case_header(&lines, i) {
                break;
            }
            i += 1;
        }
        let input = lines[input_start..i].join("\n").trim_end().to_string();
        let raw;
        let expected;
        if i >= lines.len() || lines[i].trim() != "---" {
            // No `---` separator before next case (or EOF). Treat the
            // remaining sections as empty.
            raw = String::new();
            expected = String::new();
        } else {
            i += 1;

            // Raw tree-sitter parse section. New-format files have a second
            // `---` separator between the raw tree and the mapped AST. Legacy
            // files (with only one separator) have no raw section — in that
            // case `raw` stays empty and update mode will populate it.
            let raw_start = i;
            let mut next_sep = i;
            while next_sep < lines.len() && lines[next_sep].trim() != "---" {
                if is_next_case_header(&lines, next_sep) {
                    break;
                }
                next_sep += 1;
            }
            raw = if next_sep < lines.len() && lines[next_sep].trim() == "---" {
                let raw_text = lines[raw_start..next_sep].join("\n").trim().to_string();
                i = next_sep + 1;
                raw_text
            } else {
                String::new()
            };

            let expected_start = i;
            while i < lines.len() {
                if is_next_case_header(&lines, i) {
                    break;
                }
                i += 1;
            }
            expected = lines[expected_start..i].join("\n").trim().to_string();
        }

        cases.push(CorpusCase {
            name,
            input,
            raw,
            expected,
        });
    }

    cases
}

fn render_corpus(cases: &[CorpusCase]) -> String {
    let mut out = String::new();

    for (idx, case) in cases.iter().enumerate() {
        if idx > 0 {
            // Blank line between cases.
            out.push('\n');
        }
        out.push_str("===\n");
        out.push_str(case.name.trim());
        out.push_str("\n===\n\n");
        out.push_str(case.input.trim());
        out.push_str("\n\n---\n\n");
        out.push_str(case.raw.trim());
        out.push_str("\n\n---\n\n");
        out.push_str(case.expected.trim());
        // Single trailing newline per case; the inter-case blank line is
        // added by the prefix above, and the file ends with exactly one `\n`.
        out.push('\n');
    }

    out
}

fn run_desugaring(
    lang: &simple::LanguageSpec,
    input: &str,
) -> Result<yeast::Ast, String> {
    let runner = match lang.desugar.as_ref() {
        Some(config) => Runner::from_config(lang.ts_language.clone(), config)
            .map_err(|e| format!("Failed to create yeast runner: {e}"))?,
        None => Runner::new(lang.ts_language.clone(), &[]),
    };

    runner
        .run(input)
        .map_err(|e| format!("Failed to parse input: {e}"))
}

/// Produce the raw tree-sitter parse tree dump for `input`, with no
/// desugaring rules applied. Uses a `Runner` with an empty phase list and
/// the input grammar's own schema.
fn dump_raw_parse(
    lang: &simple::LanguageSpec,
    input: &str,
) -> Result<String, String> {
    let runner: Runner = Runner::new(lang.ts_language.clone(), &[]);
    let ast = runner
        .run(input)
        .map_err(|e| format!("Failed to parse input: {e}"))?;
    Ok(dump_ast(&ast, ast.get_root(), input))
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

        let mut corpus_files: Vec<_> = fs::read_dir(&lang_corpus_dir)
            .unwrap_or_else(|e| {
                panic!(
                    "Failed to read corpus directory {}: {e}",
                    lang_corpus_dir.display()
                )
            })
            .map(|entry| entry.expect("Failed to read corpus entry").path())
            .filter(|path| path.extension().is_some_and(|ext| ext == "txt"))
            .collect();
        corpus_files.sort();

        for corpus_path in corpus_files {
            let content = fs::read_to_string(&corpus_path)
                .unwrap_or_else(|e| panic!("Failed to read {}: {e}", corpus_path.display()));
            let mut cases = parse_corpus(&content);
            let mut failures = Vec::new();
            assert!(
                !cases.is_empty(),
                "No corpus cases found in {}",
                corpus_path.display()
            );

            for case in &mut cases {
                match dump_raw_parse(&lang, &case.input) {
                    Err(e) => {
                        failures.push(format!(
                            "Raw parse failed for {} in {}: {}",
                            case.name,
                            corpus_path.display(),
                            e
                        ));
                    }
                    Ok(actual_raw) => {
                        if update_mode {
                            case.raw = actual_raw.trim().to_string();
                        } else if case.raw.trim() != actual_raw.trim() {
                            failures.push(format!(
                                "Raw parse mismatch in {}: \"{}\"\nEXPECTED:\n\n{}\n\nACTUAL:\n\n{}",
                                corpus_path.display(),
                                case.name,
                                case.raw.trim(),
                                actual_raw.trim()
                            ));
                        }
                    }
                }

                match run_desugaring(&lang, &case.input) {
                    Err(e) => {
                        failures.push(format!(
                            "Desugaring failed for {} in {}: {}",
                            case.name,
                            corpus_path.display(),
                            e
                        ));
                    }
                    Ok(actual) => {
                        let actual_dump = dump_ast_with_type_errors(
                            &actual,
                            actual.get_root(),
                            &case.input,
                            &output_schema,
                        );
                        if update_mode {
                            case.expected = actual_dump.trim().to_string();
                        } else if case.expected.trim() != actual_dump.trim() {
                            failures.push(format!(
                                "Test failed in {}: \"{}\"\nEXPECTED:\n\n{}\n\nACTUAL:\n\n{}",
                                corpus_path.display(),
                                case.name,
                                case.expected.trim(),
                                actual_dump.trim()
                            ));
                        }
                    }
                }
            }

            assert!(
                failures.is_empty(),
                "{}",
                failures.join("\n\n") + "\n\n"
            );

            if update_mode {
                let updated = render_corpus(&cases);
                let write_result = fs::write(&corpus_path, updated);
                assert!(
                    write_result.is_ok(),
                    "Failed to update corpus file {}: {}",
                    corpus_path.display(),
                    write_result.err().map_or_else(String::new, |e| e.to_string())
                );
            }
        }
    }
}
