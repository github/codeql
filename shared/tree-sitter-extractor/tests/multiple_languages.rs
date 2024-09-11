use codeql_extractor::extractor::simple;
use codeql_extractor::trap;
use tree_sitter_ql;

mod common;
use common::{create_source_dir, expect_trap_file, SourceArchive};

/// Like the `simple_extractor` test but with multiple languages.
/// This is in a separate crate because the simple extractor API sets up a
/// global thread pool, and therefore can't be called twice in the same process.
#[test]
fn multiple_language_extractor() {
    let lang_ql = simple::LanguageSpec {
        prefix: "ql",
        ts_language: tree_sitter_ql::LANGUAGE.into(),
        node_types: tree_sitter_ql::NODE_TYPES,
        file_globs: vec!["*.qll".into()],
    };
    let lang_json = simple::LanguageSpec {
        prefix: "json",
        ts_language: tree_sitter_json::LANGUAGE.into(),
        node_types: tree_sitter_json::NODE_TYPES,
        file_globs: vec!["*.json".into(), "*Jsonfile".into()],
    };

    let SourceArchive {
        root_dir,
        file_list,
        source_archive_dir,
        trap_dir,
    } = create_source_dir(vec![
        ("foo.qll", "predicate p(int a) { a = 1 }"),
        ("bar.json", "{\"a\": 1}"),
        ("Jsonfile", "{\"b\": 2}"),
    ]);

    let extractor = simple::Extractor {
        prefix: "ql".to_string(),
        languages: vec![lang_ql, lang_json],
        trap_dir,
        source_archive_dir,
        file_lists: vec![file_list],
        trap_compression: Ok(trap::Compression::Gzip),
    };

    extractor.run().unwrap();

    expect_trap_file(&root_dir, "foo.qll");
    expect_trap_file(&root_dir, "bar.json");
    expect_trap_file(&root_dir, "Jsonfile");
}
