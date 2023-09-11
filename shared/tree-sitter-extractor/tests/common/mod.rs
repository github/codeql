use std::io::{Read, Write};
use std::{
    fs::File,
    path::{Path, PathBuf},
};

use flate2::read::GzDecoder;

pub struct SourceArchive {
    pub root_dir: PathBuf,
    pub file_list: PathBuf,
    pub source_archive_dir: PathBuf,
    pub trap_dir: PathBuf,
}

pub fn create_source_dir(files: Vec<(&'static str, &'static str)>) -> SourceArchive {
    let root_dir = std::env::temp_dir().join(format!("codeql-extractor-{}", rand::random::<u16>()));
    std::fs::create_dir_all(&root_dir).unwrap();
    let root_dir = root_dir
        .canonicalize()
        .expect("failed to canonicalize root directory");

    let trap_dir = create_dir(&root_dir, "trap");
    let source_archive_dir = create_dir(&root_dir, "src");

    let mut file_paths = vec![];
    for (filename, contents) in files {
        let path = source_archive_dir.join(filename);
        let mut file = File::create(&path).unwrap();
        file.write_all(contents.as_bytes()).unwrap();
        file_paths.push(PathBuf::from(path));
    }

    let file_list = {
        let path = root_dir.join("files.txt");
        let mut file = File::create(&path).unwrap();
        for path in file_paths {
            file.write_all(path.as_path().display().to_string().as_bytes())
                .unwrap();
            file.write_all(b"\n").unwrap();
        }
        path
    };

    SourceArchive {
        root_dir,
        file_list,
        source_archive_dir,
        trap_dir,
    }
}

pub fn expect_trap_file(root_dir: &Path, filename: &str) {
    let root_dir_relative = {
        let r = root_dir.display().to_string();
        r.strip_prefix("/").unwrap().to_string()
    };
    let trap_gz = root_dir
        .join("trap")
        .join(root_dir_relative)
        .join("src")
        .join(format!("{filename}.trap.gz"));
    let mut decoder = GzDecoder::new(File::open(trap_gz).unwrap());
    let mut first_line = [0; 31];
    decoder.read_exact(&mut first_line).unwrap();
    assert_eq!(first_line.as_slice(), b"// Auto-generated TRAP file for");
}

fn create_dir(root: &Path, path: impl AsRef<Path>) -> PathBuf {
    let full_path = root.join(path);
    std::fs::create_dir_all(&full_path).expect("Failed to create directory");
    full_path.into()
}
