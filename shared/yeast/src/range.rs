//! (de)-serialize helpers for tree_sitter::Range

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(remote = "tree_sitter::Point")]
pub struct Point {
    pub row: usize,
    pub column: usize,
}

#[derive(Serialize, Deserialize)]
#[serde(remote = "tree_sitter::Range")]
pub struct Range {
    pub start_byte: usize,
    pub end_byte: usize,
    #[serde(with = "Point")]
    pub start_point: tree_sitter::Point,
    #[serde(with = "Point")]
    pub end_point: tree_sitter::Point,
}
