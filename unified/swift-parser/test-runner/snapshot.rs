use codeql_extractor::extractor::ParsedTree;
use serde_json::{Value, json};
use yeast::{Ast, TreeId};

use crate::{reference_adapter, swift_parse};

pub(super) fn reference(json: &str, source: &str) -> Result<Value, String> {
    let mut adapted = reference_adapter::json_to_ast(json)?;
    adapted.ast.set_source(source.as_bytes().to_vec());
    Ok(snapshot(&ParsedTree {
        ast: adapted.ast,
        extras: adapted.extras,
    }))
}

pub(super) fn candidate(source: &str) -> Value {
    match std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        swift_parse::parse(source.as_bytes()).map(|parsed| snapshot(&parsed))
    })) {
        Ok(Ok(snapshot)) => snapshot,
        Ok(Err(error)) => json!({ "parse_error": error }),
        Err(panic) => {
            let message = panic
                .downcast_ref::<String>()
                .map(String::as_str)
                .or_else(|| panic.downcast_ref::<&str>().copied())
                .unwrap_or("non-string panic");
            json!({ "panic": message })
        }
    }
}

fn snapshot(parsed: &ParsedTree) -> Value {
    let tree = tree(&parsed.ast);
    let extras: Vec<_> = parsed
        .extras
        .iter()
        .map(|extra| {
            json!({
                "kind": extra.kind,
                "range": extra.range,
                "text": extra.text,
            })
        })
        .collect();
    json!({ "tree": tree, "extras": extras })
}

// Preorder records ignore arena ids and storage choices, without recursive JSON.
fn tree<I: TreeId>(ast: &Ast<I>) -> Vec<Value> {
    let mut nodes = Vec::new();
    let mut parents = Vec::new();
    let mut cursor = ast.walk();
    loop {
        let id = cursor.node_id();
        let node = cursor.node();
        let field = cursor.field_name();
        let has_children = cursor.goto_first_child();
        let text = if has_children {
            node.opt_string_content().filter(|text| !text.is_empty())
        } else {
            Some(ast.source_text(id))
        };
        let index = nodes.len();
        nodes.push(json!({
            "parent": parents.last(),
            "field": field,
            "kind": node.kind_name(),
            "named": node.is_named(),
            "missing": node.is_missing(),
            "error": node.is_error(),
            "extra": node.is_extra(),
            "range": node.source_range(),
            "text": text,
        }));
        if has_children {
            parents.push(index);
            continue;
        }
        loop {
            if cursor.goto_next_sibling() {
                break;
            }
            if !cursor.goto_parent() {
                return nodes;
            }
            parents.pop();
        }
    }
}
