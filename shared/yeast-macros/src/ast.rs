use proc_macro2::{Ident, Literal};

pub(crate) enum Template {
    /// A parenthesized node template such as `(call method: {name})`.
    Node(Node),
    /// An embedded Rust block such as `{args}`.
    Splice(syn::Block),
}

pub(crate) struct Node {
    /// The node kind at the start of the template, such as `call` in `(call)`.
    pub(crate) kind: Ident,
    /// Optional leaf content such as `"foo"` or `#{name}` in
    /// `(identifier "foo")` or `(identifier #{name})`.
    pub(crate) content: Option<Content>,
    /// Named fields such as `method: {name}` in `(call method: {name})`.
    pub(crate) fields: Vec<Field>,
}

pub(crate) enum Content {
    /// Static leaf content such as `"foo"` in `(identifier "foo")`.
    Static(Literal),
    /// Computed leaf content such as `#{name}` in `(identifier #{name})`.
    Computed(syn::Block),
}

pub(crate) enum Field {
    /// A named field such as `argument: {args}` or
    /// `label: (identifier #{name})?`.
    Named {
        /// The field name before `:`, such as `argument`.
        name: Ident,
        /// The node or Rust splice after `:`, such as `(identifier "x")` or
        /// `{args}`.
        value: Template,
        /// Whether the field value has a trailing `?`.
        optional: bool,
    },
}
