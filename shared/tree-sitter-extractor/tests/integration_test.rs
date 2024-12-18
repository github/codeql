use codeql_extractor::extractor::simple;
use codeql_extractor::trap;

use tree_sitter_ql;

mod common;
use common::{create_source_dir, expect_trap_file, SourceArchive};

/// A very simple happy-path test.
/// We run the extractor using the tree-sitter-ql grammar and a single source file,
/// and check that we get a reasonable-looking trap file in the expected location.
#[test]
fn simple_extractor() {
    let language = simple::LanguageSpec {
        prefix: "ql",
        ts_language: tree_sitter_ql::LANGUAGE.into(),
        node_types: tree_sitter_ql::NODE_TYPES,
        file_globs: vec!["*.qll".into()],
    };

    let SourceArchive {
        root_dir,
        file_list,
        source_archive_dir,
        trap_dir,
    } = create_source_dir(vec![("foo.qll", "predicate p(int a) { a = 1 }")]);

    let extractor = simple::Extractor {
        prefix: "ql".to_string(),
        languages: vec![language],
        trap_dir,
        source_archive_dir,
        file_lists: vec![file_list],
        trap_compression: Ok(trap::Compression::Gzip),
    };

    extractor.run().unwrap();

    expect_trap_file(&root_dir, "foo.qll");
}
