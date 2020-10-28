use std::path::PathBuf;

pub struct Language {
    pub name: String,
    pub node_types: &'static str,
    pub dbscheme_path: PathBuf,
    pub ql_library_path: PathBuf,
}
