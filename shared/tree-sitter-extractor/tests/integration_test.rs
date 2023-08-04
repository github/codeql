use std::fs::File;
use std::io::{Read, Write};
use std::path::{Path, PathBuf};

use codeql_extractor::extractor::simple;
use codeql_extractor::trap;
use flate2::read::GzDecoder;
use tree_sitter_ql;

/// An very simple happy-path test.
/// We run the extractor using the tree-sitter-ql grammar and a single source file,
/// and check that we get a reasonable-looking trap file in the expected location.
#[test]
fn simple_extractor() {
    let language = simple::LanguageSpec {
        prefix: "ql",
        ts_language: tree_sitter_ql::language(),
        node_types: tree_sitter_ql::NODE_TYPES,
        file_extensions: vec!["qll".into()],
    };

    let root_dir = std::env::temp_dir().join(format!("codeql-extractor-{}", rand::random::<u16>()));
    std::fs::create_dir_all(&root_dir).unwrap();

    let trap_dir = create_dir(&root_dir, "trap");
    let source_archive_dir = create_dir(&root_dir, "src");

    // Create foo.qll source file
    let foo_qll = {
        let path = source_archive_dir.join("foo.qll");
        let mut file = File::create(&path).expect("Failed to create src/foo.qll");
        file.write_all(b"predicate p(int a) { a = 1 }")
            .expect("Failed to write to foo.qll");
        PathBuf::from(path)
    };

    let file_list = {
        let path = root_dir.join("files.txt");
        let mut file = File::create(&path).expect("Failed to create files.txt");
        file.write_all(foo_qll.as_path().display().to_string().as_bytes())
            .expect("Failed to write to files.txt");
        path
    };

    let extractor = simple::Extractor {
        prefix: "ql".to_string(),
        languages: vec![language],
        trap_dir,
        source_archive_dir,
        file_list,
        trap_compression: Ok(trap::Compression::Gzip),
    };

    // The extractor should run successfully
    extractor.run().unwrap();

    // Check for the presence of $root/trap/$root/src/foo.qll
    {
        let root_dir_relative = {
            let r = root_dir.as_path().display().to_string();
            r.strip_prefix("/").unwrap().to_string()
        };
        let foo_qll_trap_gz = root_dir
            .join("trap")
            .join(root_dir_relative)
            .join("src/foo.qll.trap.gz");
        let mut decoder =
            GzDecoder::new(File::open(foo_qll_trap_gz).expect("Failed to open foo.qll.trap.gz"));
        let mut first_line = [0; 31];
        decoder
            .read_exact(&mut first_line)
            .expect("Failed to read from foo.qll.trap.gz");
        assert_eq!(first_line.as_slice(), b"// Auto-generated TRAP file for");
    }
}

fn create_dir(root: &Path, path: impl AsRef<Path>) -> PathBuf {
    let full_path = root.join(path);
    std::fs::create_dir_all(&full_path).expect("Failed to create directory");
    full_path.into()
}
