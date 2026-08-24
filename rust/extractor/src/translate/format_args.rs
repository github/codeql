//! Reconstruction of the `format_args!` expansion of the format-family macros.
//!
//! On `rustc <1.94` sysroots the format-family macros (`format!`, `println!`,
//! `write!`, `panic!`, ...) no longer resolve, so `expand_macro_call` returns `None`
//! and we get a bare unexpanded `MacroCall`. The syntactic lowering of these macros
//! is a pure, sysroot-independent transform, so we rebuild the same token tree the
//! real (>=1.94) expansion produces and parse it ourselves, giving pre-1.94
//! toolchains the same AST as newer ones.
//!
//! This module owns the pure token-tree construction; [`super::base::Translator`]
//! handles parsing the result and emitting it as the macro expansion.

use ra_ap_hir_expand::intern::Symbol;
use ra_ap_hir_expand::tt;
use ra_ap_span::Span;

/// How a format-family macro wraps its `format_args!`. We rebuild the same shape the
/// real (>=1.94) expansion has, so older toolchains get the same AST.
#[derive(Clone, Copy, PartialEq, Eq)]
pub(crate) enum Wrap {
    /// `format_args!` and friends are themselves the `FormatArgsExpr`.
    Bare,
    /// Wrapped in a call to the given absolute path, e.g. `std::fmt::format(..)`.
    Call(&'static [&'static str]),
    /// `write!`/`writeln!`: `<dst>.write_fmt(format_args!(..))`.
    WriteMethod,
}

impl Wrap {
    /// Classifies a macro by its name, or returns `None` if it is not a
    /// format-family macro we reconstruct.
    ///
    /// `format_args_nl!`'s trailing newline is intentionally dropped: it is not
    /// relevant to flow or to the sinks keyed on the callee, so all variants map to
    /// the same `format_args` reconstruction.
    pub(crate) fn for_macro(name: &str) -> Option<Wrap> {
        Some(match name {
            "format_args" | "const_format_args" | "format_args_nl" => Wrap::Bare,
            "format" => Wrap::Call(&["std", "fmt", "format"]),
            "print" | "println" => Wrap::Call(&["std", "io", "_print"]),
            "eprint" | "eprintln" => Wrap::Call(&["std", "io", "_eprint"]),
            "panic" => Wrap::Call(&["core", "panicking", "panic_fmt"]),
            "write" | "writeln" => Wrap::WriteMethod,
            _ => return None,
        })
    }
}

/// Builds the reconstructed expansion token tree for `wrap` from the macro `input`.
///
/// Returns `None` if the input does not match the expected shape (currently only when
/// a `write!` argument list has no writer/format-args separating comma). `call_site`
/// is used to span the synthesized tokens; the format arguments keep their own spans.
pub(crate) fn reconstruct(
    wrap: Wrap,
    input: &tt::TopSubtree,
    call_site: Span,
) -> Option<tt::TopSubtree> {
    let (writer, content) = split_arguments(wrap, input)?;
    let emitter = Emitter {
        call_site,
        format_args_parens: input.view().top_subtree().delimiter,
    };

    let mut builder = tt::TopSubtreeBuilder::new(tt::Delimiter::invisible_spanned(call_site));
    match wrap {
        Wrap::Bare => emitter.push_format_args(&mut builder, content),
        Wrap::Call(path) => {
            emitter.push_path(&mut builder, path);
            emitter.push_parenthesized_format_args(&mut builder, content);
        }
        Wrap::WriteMethod => {
            builder.extend_with_tt(writer.expect("write! split always yields a writer"));
            builder.push(emitter.punct('.', tt::Spacing::Alone));
            builder.push(emitter.ident("write_fmt"));
            emitter.push_parenthesized_format_args(&mut builder, content);
        }
    }
    Some(builder.build())
}

/// Splits the macro argument list into the leading writer (for `write!`/`writeln!`,
/// everything up to the first top-level comma) and the format arguments.
fn split_arguments<'a>(
    wrap: Wrap,
    input: &'a tt::TopSubtree,
) -> Option<(Option<tt::TokenTreesView<'a>>, tt::TokenTreesView<'a>)> {
    if wrap != Wrap::WriteMethod {
        return Some((None, input.view().token_trees()));
    }
    let mut iter = input.view().iter();
    let start = iter.savepoint();
    let mut found_comma = false;
    while let Some(element) = iter.peek() {
        if let tt::TtElement::Leaf(tt::Leaf::Punct(punct)) = element
            && punct.char == ','
        {
            found_comma = true;
            break;
        }
        iter.next();
    }
    if !found_comma {
        return None;
    }
    let writer = iter.from_savepoint(start);
    iter.next(); // consume the comma
    Some((Some(writer), iter.remaining()))
}

/// Emits the synthesized tokens, tagging them with the macro call site span.
struct Emitter {
    call_site: Span,
    /// The delimiter of the macro input, reused for the `format_args(..)` parentheses
    /// so those spans point back at the original argument list.
    format_args_parens: tt::Delimiter,
}

impl Emitter {
    fn ident(&self, sym: &str) -> tt::Leaf {
        tt::Leaf::Ident(tt::Ident {
            sym: Symbol::intern(sym),
            span: self.call_site,
            is_raw: tt::IdentIsRaw::No,
        })
    }

    fn punct(&self, char: char, spacing: tt::Spacing) -> tt::Leaf {
        tt::Leaf::Punct(tt::Punct {
            char,
            spacing,
            span: self.call_site,
        })
    }

    /// Pushes `builtin # format_args ( <content> )`, the token form the parser turns
    /// into a `FormatArgsExpr`. Its argument leaves keep their real source spans.
    fn push_format_args(&self, builder: &mut tt::TopSubtreeBuilder, content: tt::TokenTreesView) {
        builder.push(self.ident("builtin"));
        builder.push(self.punct('#', tt::Spacing::Alone));
        builder.push(self.ident("format_args"));
        builder.open(tt::DelimiterKind::Parenthesis, self.format_args_parens.open);
        builder.extend_with_tt(content);
        builder.close(self.format_args_parens.close);
    }

    /// Pushes `:: seg :: seg ...`, an absolute path.
    fn push_path(&self, builder: &mut tt::TopSubtreeBuilder, path: &[&str]) {
        for segment in path {
            builder.push(self.punct(':', tt::Spacing::Joint));
            builder.push(self.punct(':', tt::Spacing::Alone));
            builder.push(self.ident(segment));
        }
    }

    /// Pushes `( builtin#format_args(<content>) )`, the argument list of the wrapping
    /// call or method.
    fn push_parenthesized_format_args(
        &self,
        builder: &mut tt::TopSubtreeBuilder,
        content: tt::TokenTreesView,
    ) {
        builder.open(tt::DelimiterKind::Parenthesis, self.call_site);
        self.push_format_args(builder, content);
        builder.close(self.call_site);
    }
}
