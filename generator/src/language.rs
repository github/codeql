use std::path::PathBuf;

pub struct Language<'a> {
    pub name: String,
    pub node_types: &'a str,
    pub dbscheme_path: PathBuf,
}
