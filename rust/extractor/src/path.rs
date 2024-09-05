use std::fs::canonicalize;
use std::path::{absolute, Path, PathBuf};

pub fn key(p: &Path) -> PathBuf {
    let normalized = canonicalize(p)
        .or_else(|_| absolute(p))
        .unwrap_or_else(|_| p.into());
    let root = normalized.ancestors().last().unwrap(); // ancestors always yields at least one
    normalized.strip_prefix(root).unwrap().into() // stripping an ancestor always works
}
