//! Builds the extraction AST directly from native parser callbacks.

use std::cell::RefCell;
use std::collections::BTreeMap;
use std::sync::OnceLock;

use codeql_extractor::extractor::{ExtraToken, ParsedTree};
use swift_parser::{
    Child, Diagnostic, FieldKind, NodeFlags, Parser, Span, SyntaxKind, SyntaxSink, TriviaKind,
};
use yeast::{Ast, Id, NodeContent, Point, Range, schema::Schema};

thread_local! {
    static PARSER: RefCell<Parser> = const { RefCell::new(Parser::new()) };
}

struct SchemaTables {
    schema: Schema,
    kinds: Vec<u16>,
    fields: Vec<u16>,
}

fn schema_tables() -> Result<&'static SchemaTables, String> {
    static TABLES: OnceLock<Result<SchemaTables, String>> = OnceLock::new();
    TABLES
        .get_or_init(|| {
            let mut schema = yeast::node_types_yaml::schema_from_yaml(include_str!(
                "../../../swift_node_types.yml"
            ))?;
            let kinds = SyntaxKind::ALL
                .iter()
                .map(|kind| {
                    if kind.is_named() {
                        schema.register_kind(kind.name())
                    } else {
                        schema.register_unnamed_kind(kind.name())
                    }
                })
                .collect();
            let fields = FieldKind::ALL
                .iter()
                .map(|field| schema.register_field(field.name()))
                .collect();
            Ok(SchemaTables {
                schema,
                kinds,
                fields,
            })
        })
        .as_ref()
        .map_err(Clone::clone)
}

struct YeastSink<'a> {
    source: &'a str,
    tables: &'static SchemaTables,
    ast: Ast,
    extras: Vec<ExtraToken>,
    line_starts: Vec<usize>,
}

impl<'a> YeastSink<'a> {
    fn new(source: &'a str) -> Result<Self, String> {
        let tables = schema_tables()?;
        let mut ast = Ast::with_schema(tables.schema.clone());
        ast.set_source(source.as_bytes().to_vec());
        let mut line_starts = vec![0];
        let bytes = source.as_bytes();
        let mut offset = 0;
        while offset < bytes.len() {
            match bytes[offset] {
                b'\r' => {
                    offset += 1;
                    if bytes.get(offset) == Some(&b'\n') {
                        offset += 1;
                    }
                    line_starts.push(offset);
                }
                b'\n' => {
                    offset += 1;
                    line_starts.push(offset);
                }
                _ => offset += 1,
            }
        }
        Ok(Self {
            source,
            tables,
            ast,
            extras: Vec::new(),
            line_starts,
        })
    }

    fn point(&self, offset: usize) -> Point {
        let row = self.line_starts.partition_point(|start| *start <= offset) - 1;
        Point::new(row, offset - self.line_starts[row])
    }

    fn range(&self, span: Span) -> Range {
        Range {
            start_byte: span.start,
            end_byte: span.end,
            start_point: self.point(span.start),
            end_point: self.point(span.end),
        }
    }

    fn finish(mut self, root: Id) -> ParsedTree {
        self.ast.set_root(root);
        ParsedTree {
            ast: self.ast,
            extras: self.extras,
        }
    }
}

impl SyntaxSink for YeastSink<'_> {
    type Node = Id;

    fn node(
        &mut self,
        kind: SyntaxKind,
        span: Span,
        flags: NodeFlags,
        children: &[Child<Id>],
    ) -> Id {
        let mut fields: BTreeMap<u16, Vec<Id>> = BTreeMap::new();
        for child in children {
            fields
                .entry(self.tables.fields[child.field as usize])
                .or_default()
                .push(child.node);
        }
        let range = self.range(span);
        let content = if kind.is_token() {
            NodeContent::Range(range)
        } else {
            NodeContent::DynamicString(String::new())
        };
        let id = self.ast.create_node_with_range(
            self.tables.kinds[kind as usize],
            content,
            fields,
            kind.is_named(),
            Some(range),
        );
        self.ast
            .set_node_flags(id, flags.is_missing, flags.is_error);
        id
    }

    fn trivia(&mut self, kind: TriviaKind, span: Span) {
        self.extras.push(ExtraToken {
            kind: kind as usize,
            range: self.range(span),
            text: self.source[span.start..span.end].to_owned(),
        });
    }

    fn diagnostic(&mut self, diagnostic: Diagnostic) {
        tracing::warn!(
            start_byte = diagnostic.span.start,
            end_byte = diagnostic.span.end,
            "Swift parser: {}",
            diagnostic.message
        );
    }
}

pub(super) fn parse(source: &str) -> Result<ParsedTree, String> {
    let mut sink = YeastSink::new(source)?;
    let root = PARSER
        .with_borrow_mut(|parser| parser.parse_into(source, &mut sink))
        .map_err(|error| format!("Swift parser failed: {error}"))?;
    Ok(sink.finish(root))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn builds_source_backed_tokens_and_ordered_fields_with_recovery_flags() {
        let mut sink = YeastSink::new("ab cd").unwrap();
        let first = sink.node(
            SyntaxKind::Identifier,
            Span { start: 0, end: 2 },
            NodeFlags::default(),
            &[],
        );
        let second = sink.node(
            SyntaxKind::Identifier,
            Span { start: 3, end: 5 },
            NodeFlags::default(),
            &[],
        );
        let missing = sink.node(
            SyntaxKind::EndOfFile,
            Span { start: 5, end: 5 },
            NodeFlags {
                is_missing: true,
                is_error: false,
            },
            &[],
        );
        let root = sink.node(
            SyntaxKind::SourceFile,
            Span { start: 0, end: 5 },
            NodeFlags {
                is_missing: false,
                is_error: true,
            },
            &[
                Child {
                    field: FieldKind::Statements,
                    node: first,
                },
                Child {
                    field: FieldKind::EndOfFileToken,
                    node: missing,
                },
                Child {
                    field: FieldKind::Statements,
                    node: second,
                },
            ],
        );
        let parsed = sink.finish(root);
        let statements = parsed.ast.field_id_for_name("statements").unwrap();
        let node = parsed.ast.get_node(parsed.ast.get_root()).unwrap();
        assert_eq!(node.field_children(statements), &[first, second]);
        assert!(node.is_error());
        assert_eq!(parsed.ast.source_text(first), "ab");
        assert_eq!(parsed.ast.source_text(second), "cd");
        assert_eq!(
            parsed.ast.get_node(first).unwrap().opt_string_content(),
            None
        );
        let missing = parsed.ast.get_node(missing).unwrap();
        assert!(missing.is_missing());
        assert!(!missing.is_named());
        assert_eq!(missing.byte_range(), 5..5);
    }

    #[test]
    fn preserves_trivia_and_utf8_locations_across_all_swift_line_endings() {
        let source = "// \u{e9}\u{1f600}\r\nx\ry\nz";
        let mut sink = YeastSink::new(source).unwrap();
        sink.trivia(TriviaKind::LineComment, Span { start: 0, end: 9 });
        for (text, row) in [("x", 1), ("y", 2), ("z", 3)] {
            let start = source.find(text).unwrap();
            let id = sink.node(
                SyntaxKind::Identifier,
                Span {
                    start,
                    end: start + 1,
                },
                NodeFlags::default(),
                &[],
            );
            let node = sink.ast.get_node(id).unwrap();
            assert_eq!(node.start_position(), Point::new(row, 0));
            assert_eq!(node.end_position(), Point::new(row, 1));
            assert_eq!(sink.ast.source_text(id), text);
        }
        assert_eq!(sink.extras.len(), 1);
        let comment = &sink.extras[0];
        assert_eq!(comment.kind, 1);
        assert_eq!(comment.text, "// \u{e9}\u{1f600}");
        assert_eq!(comment.range.end_point, Point::new(0, 9));
    }
}
