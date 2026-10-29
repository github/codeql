use std::collections::BTreeSet;

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
        /// Capture identifier after `@` or `@@`.
        name: Ident,
        /// Whether `@@` keeps the captured input node untranslated.
        raw: bool,
        pattern: Box<Pattern>,
        cardinality: Cardinality,
    },
    /// An ordered sequence of patterns within a field.
    Sequence(Vec<Pattern>),
    /// A repeated or optional pattern.
    Repeated {
        pattern: Box<Pattern>,
        cardinality: Cardinality,
    },
}

impl Pattern {
    pub(crate) fn matches_single_node(&self) -> bool {
        match self {
            Pattern::Any { .. } | Pattern::Node { .. } | Pattern::Unnamed(_) => true,
            Pattern::Capture { cardinality, .. } => *cardinality == Cardinality::SINGLE,
            Pattern::Sequence(_) | Pattern::Repeated { .. } => false,
        }
    }
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
    /// Named fields and source-location metadata.
    pub(crate) fields: Vec<Field>,
}

pub(crate) enum Content {
    /// Static leaf content such as `"foo"` in `(identifier "foo")`.
    Static(Literal),
    /// Computed leaf content such as `#{name}` in `(identifier #{name})`.
    Computed(syn::Block),
    /// Value inherited from the node matched by the enclosing rule.
    Inherited,
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
    /// Source-location metadata such as `location: {source}`.
    Location {
        /// A Rust block yielding the node or nodes whose locations should be combined.
        block: syn::Block,
    },
}

impl Rule {
    pub(crate) fn resolve_bare_leaf_content(
        &mut self,
        leaf_kinds: &BTreeSet<String>,
    ) -> syn::Result<()> {
        let Replacement::Templates(templates) = &mut self.replacement else {
            return Ok(());
        };
        for template in templates {
            template.resolve_bare_leaf_content(leaf_kinds, true)?;
        }
        Ok(())
    }
}

impl Template {
    fn resolve_bare_leaf_content(
        &mut self,
        leaf_kinds: &BTreeSet<String>,
        is_rule_result: bool,
    ) -> syn::Result<()> {
        let Template::Node(node) = self else {
            return Ok(());
        };

        for field in &mut node.fields {
            if let Field::Named { value, .. } = field {
                value.resolve_bare_leaf_content(leaf_kinds, false)?;
            }
        }

        if node.content.is_none()
            && node.fields.is_empty()
            && leaf_kinds.contains(node.kind.to_string().as_str())
        {
            if !is_rule_result {
                return Err(syn::Error::new_spanned(
                    &node.kind,
                    format!(
                        "bare leaf `{}` must be a top-level rule result or have explicit content",
                        node.kind
                    ),
                ));
            }
            node.content = Some(Content::Inherited);
        }

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use quote::quote;

    fn output_leaf_kinds() -> BTreeSet<String> {
        yeast_schema::node_types_yaml::leaf_kinds_from_yaml(
            r#"
named:
  assignment:
    left: identifier
  identifier:
"#,
        )
        .unwrap()
    }

    #[test]
    fn marks_top_level_bare_leaves_as_inherited() {
        let mut rule = crate::rule_parse::parse_rule(quote!((source) => (identifier))).unwrap();
        rule.resolve_bare_leaf_content(&output_leaf_kinds())
            .unwrap();

        let Replacement::Templates(templates) = rule.replacement else {
            panic!("expected template replacement");
        };
        let [Template::Node(node)] = templates.as_slice() else {
            panic!("expected one output node");
        };
        assert!(matches!(node.content, Some(Content::Inherited)));
    }

    #[test]
    fn rejects_nested_bare_leaves() {
        let mut rule =
            crate::rule_parse::parse_rule(quote!((source) => (assignment left: (identifier))))
                .unwrap();
        let error = rule
            .resolve_bare_leaf_content(&output_leaf_kinds())
            .unwrap_err();

        assert_eq!(
            error.to_string(),
            "bare leaf `identifier` must be a top-level rule result or have explicit content"
        );
    }

    #[test]
    fn leaves_fieldless_structural_nodes_unchanged() {
        let mut rule = crate::rule_parse::parse_rule(quote!((source) => (assignment))).unwrap();
        rule.resolve_bare_leaf_content(&output_leaf_kinds())
            .unwrap();

        let Replacement::Templates(templates) = rule.replacement else {
            panic!("expected template replacement");
        };
        let [Template::Node(node)] = templates.as_slice() else {
            panic!("expected one output node");
        };
        assert!(node.content.is_none());
    }
}
