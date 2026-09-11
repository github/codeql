//! Location types for yeast ASTs.
//!
//! These are plain owned structs (mirroring tree-sitter's `Point`/`Range`) so
//! that code building an AST programmatically can populate node locations
//! without depending on tree-sitter. Conversions from the tree-sitter types
//! live in the crate root, next to the `from_tree` construction path.

use serde::{Deserialize, Serialize};

/// A position in a source file: a 0-based `row` (line) and 0-based `column`
/// (UTF-8 byte offset within the line), matching tree-sitter's convention.
#[derive(Serialize, Deserialize, Clone, Copy, Debug, Default, PartialEq, Eq, Hash)]
pub struct Point {
    pub row: usize,
    pub column: usize,
}

impl Point {
    pub fn new(row: usize, column: usize) -> Self {
        Self { row, column }
    }
}

/// A half-open source range: byte offsets plus start/end [`Point`]s. The end is
/// exclusive, matching tree-sitter's convention.
#[derive(Serialize, Deserialize, Clone, Copy, Debug, Default, PartialEq, Eq, Hash)]
pub struct Range {
    pub start_byte: usize,
    pub end_byte: usize,
    pub start_point: Point,
    pub end_point: Point,
}

impl Range {
    /// Return the smallest range containing both ranges.
    pub fn union(self, other: Self) -> Self {
        let (start_byte, start_point) = if self.start_byte <= other.start_byte {
            (self.start_byte, self.start_point)
        } else {
            (other.start_byte, other.start_point)
        };
        let (end_byte, end_point) = if self.end_byte >= other.end_byte {
            (self.end_byte, self.end_point)
        } else {
            (other.end_byte, other.end_point)
        };
        Self {
            start_byte,
            end_byte,
            start_point,
            end_point,
        }
    }

    /// Return an empty range anchored at this range's start.
    pub fn empty_at_start(self) -> Self {
        Self {
            end_byte: self.start_byte,
            end_point: self.start_point,
            ..self
        }
    }

    /// Return an empty range anchored at this range's end.
    pub fn empty_at_end(self) -> Self {
        Self {
            start_byte: self.end_byte,
            start_point: self.end_point,
            ..self
        }
    }
}
