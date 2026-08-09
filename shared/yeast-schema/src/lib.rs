//! Schema definitions and YAML/JSON node-types loaders for YEAST.
//!
//! This crate carries the parts of the YEAST framework that don't need
//! `tree-sitter`: the [`schema::Schema`] type and its associated
//! [`schema::NodeType`] / [`schema::FieldCardinality`] helpers, plus the
//! YAML and JSON conversion helpers in [`node_types_yaml`].
//!
//! It exists so that both the runtime crate (`yeast`) and the
//! compile-time `rules!` proc macro (`yeast-macros`) can build against a
//! single source of truth without dragging tree-sitter (a heavy C-backed
//! dep) into the proc-macro toolchain.
//!
//! Tree-sitter-aware adapters — building a `Schema` from a
//! `tree_sitter::Language`, or loading a YAML schema on top of one —
//! live in `yeast::schema` and `yeast::node_types_yaml` respectively.

pub mod node_types_yaml;
pub mod schema;

/// Field IDs are stable `u16`s, matching tree-sitter's representation so a
/// schema built from a tree-sitter language can preserve the language's
/// existing IDs.
pub type FieldId = u16;

/// Kind IDs are stable `u16`s. Like `FieldId`, this matches tree-sitter's
/// representation.
pub type KindId = u16;

/// Sentinel field id used to mean "the implicit unfielded slot" (what the
/// tree-sitter docs call `children` and what YEAST surfaces in queries as
/// the bare `child:` field). Reserved to avoid clashing with real field
/// IDs allocated by `Schema::register_field`.
pub const CHILD_FIELD: u16 = u16::MAX;
