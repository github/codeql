use proc_macro2::{Ident, Literal};

/// A complete rewrite rule such as `(input) where guard => (output)`.
pub(crate) struct Rule {
    /// Input pattern before `where` or `=>`.
    pub(crate) pattern: Pattern,
    /// Optional Rust guard expression after `where`.
    pub(crate) guard: Option<syn::Expr>,
    /// Template or annotated Rust replacement after `=>`.
    pub(crate) replacement: Replacement,
}

pub(crate) enum Replacement {
    /// One or more output templates such as `(call ...) {extra_nodes}`.
    Templates(Vec<Template>),
    /// Annotated Rust body such as `expr? { ... }`.
    Rust {
        /// Retained in the rule AST for validation and analysis; runtime
        /// lowering only needs the Rust body.
        #[allow(dead_code)]
        annotation: ReturnAnnotation,
        body: syn::Block,
    },
}

#[allow(dead_code)]
pub(crate) struct ReturnAnnotation {
    /// Declared output kind before the Rust body.
    pub(crate) kind: Ident,
    /// Declared output cardinality (`kind`, `kind?`, or `kind*`).
    pub(crate) cardinality: Cardinality,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct Cardinality {
    pub(crate) multiple: bool,
    pub(crate) required: bool,
}

impl Cardinality {
    pub(crate) const SINGLE: Self = Self {
        multiple: false,
        required: true,
    };
    pub(crate) const OPTIONAL: Self = Self {
        multiple: false,
        required: false,
    };
    pub(crate) const ZERO_OR_MORE: Self = Self {
        multiple: true,
        required: false,
    };
    pub(crate) const ONE_OR_MORE: Self = Self {
        multiple: true,
        required: true,
    };
}

/// An input pattern such as `(call method: (identifier) @name)`.
pub(crate) enum Pattern {
    /// `_` or `(_)`, distinguished by whether unnamed nodes may match.
    Any { match_unnamed: bool },
    /// A named node and the pattern matched against each field.
    Node {
        kind: String,
        fields: Vec<(String, Pattern)>,
    },
    /// An unnamed token pattern such as `"+"`.
    Unnamed(String),
    /// A captured pattern such as `(identifier) @name` or `_ @@raw`.
    Capture {
        capture: Capture,
        pattern: Box<Pattern>,
    },
    /// An ordered sequence of patterns within a field.
    Sequence(Vec<Pattern>),
    /// A repeated or optional pattern.
    Repeated {
        pattern: Box<Pattern>,
        cardinality: Cardinality,
    },
}

#[derive(Clone)]
pub(crate) struct Capture {
    /// Capture identifier after `@` or `@@`.
    pub(crate) name: Ident,
    /// Whether `@@` keeps the captured input node untranslated.
    pub(crate) raw: bool,
}

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
