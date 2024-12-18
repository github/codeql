// -*- coding: utf-8 -*-
// ------------------------------------------------------------------------------------------------
// Copyright © 2021, GitHub.
// Licensed under either of Apache License, Version 2.0, or MIT license, at your option.
// Please see the LICENSE-APACHE or LICENSE-MIT files in this distribution for license details.
// ------------------------------------------------------------------------------------------------

use std::path::Path;

use anyhow::anyhow;
use anyhow::Context as _;
use anyhow::Result;
use clap::App;
use clap::Arg;
use tree_sitter::Parser;
use tree_sitter_graph::ast::File;
use tree_sitter_graph::functions::Functions;
use tree_sitter_graph::ExecutionConfig;
use tree_sitter_graph::Identifier;
use tree_sitter_graph::NoCancellation;
use tree_sitter_graph::Variables;

const BUILD_VERSION: &'static str = env!("CARGO_PKG_VERSION");

pub mod extra_functions {
    use tree_sitter_graph::functions::{Function, Parameters};
    use tree_sitter_graph::graph::{Graph, Value};
    use tree_sitter_graph::{ExecutionError, Identifier};

    pub struct Location;

    fn get_location(node: Value, graph: &Graph) -> Result<Value, ExecutionError> {
        let node = graph[node.into_syntax_node_ref()?];
        let start = node.start_position();
        let end = node.end_position();
        Ok(Value::List(
            vec![start.row, start.column, end.row, end.column]
                .into_iter()
                .map(|v| Value::from(v as u32))
                .collect(),
        ))
    }

    impl Function for Location {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = parameters.param()?;
            parameters.finish()?;
            get_location(node, graph)
        }
    }

    pub struct LocationStart;

    impl Function for LocationStart {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let start = node.start_position();
            Ok(Value::List(
                vec![start.row, start.column]
                    .into_iter()
                    .map(|v| Value::from(v as u32))
                    .collect(),
            ))
        }
    }

    pub struct LocationEnd;

    impl Function for LocationEnd {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let end = node.end_position();
            Ok(Value::List(
                vec![end.row, end.column]
                    .into_iter()
                    .map(|v| Value::from(v as u32))
                    .collect(),
            ))
        }
    }

    pub struct AstNode;

    impl Function for AstNode {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let tree_sitter_node = parameters.param()?;
            let kind = parameters.param()?;
            parameters.finish()?;
            let node = graph.add_graph_node();
            let loc = get_location(tree_sitter_node, graph)?;
            graph[node]
                .attributes
                .add(Identifier::from("_location"), loc)
                .map_err(|_| {
                    ExecutionError::DuplicateAttribute(format!(
                        " _location on graph node ({:?})",
                        node
                    ))
                })?;
            graph[node]
                .attributes
                .add(Identifier::from("_kind"), kind)
                .map_err(|_| {
                    ExecutionError::DuplicateAttribute(format!(" _kind on graph node ({:?})", node))
                })?;
            Ok(Value::GraphNode(node))
        }
    }

    /// A struct representing the prefix on a Python string.
    struct Prefix {
        flags: String,
        quotes: String,
    }

    impl Prefix {
        fn full(&self) -> String {
            format!("{}{}", self.flags, self.quotes)
        }

        fn safe(&self) -> Prefix {
            Prefix {
                flags: self.flags.clone().replace("f", "").replace("F", ""),
                quotes: self.quotes.clone(),
            }
        }
    }

    fn get_prefix(s: &str) -> Prefix {
        let flags_matcher = regex::Regex::new("^[bfurBFUR]{0,2}").unwrap();
        let mut end = 0;
        let flags = match flags_matcher.find(s) {
            Some(m) => {
                end = m.end();
                &s[m.start()..m.end()]
            }
            None => "",
        };
        let mut quotes = "";
        if s[end..].starts_with("\"\"\"") {
            quotes = "\"\"\"";
        } else if s[end..].starts_with("'''") {
            quotes = "'''";
        } else if s[end..].starts_with('"') {
            quotes = "\"";
        } else if s[end..].starts_with('\'') {
            quotes = "'";
        } else if s[end..].starts_with('}') {
            quotes = "}";
        }
        Prefix {
            flags: flags.to_lowercase().to_owned(),
            quotes: quotes.to_owned(),
        }
    }

    #[test]
    fn test_get_prefix() {
        let p = get_prefix("rb'''hello'''");
        assert_eq!(p.flags, "rb");
        assert_eq!(p.quotes, "'''");
        let p = get_prefix("Br\"\"\"hello\"\"\"");
        assert_eq!(p.flags, "Br");
        assert_eq!(p.quotes, "\"\"\"");
        let p = get_prefix("FR\"hello\"");
        assert_eq!(p.flags, "FR");
        assert_eq!(p.quotes, "\"");
        let p = get_prefix("uR'hello'");
        assert_eq!(p.flags, "uR");
        assert_eq!(p.quotes, "'");
        let p = get_prefix("''");
        assert_eq!(p.flags, "");
        assert_eq!(p.quotes, "'");
        let p = get_prefix("\"\"");
        assert_eq!(p.flags, "");
        assert_eq!(p.quotes, "\"");
        let p = get_prefix("\"\"\"\"\"\"");
        assert_eq!(p.flags, "");
        assert_eq!(p.quotes, "\"\"\"");
    }

    fn get_string_contents(s: String) -> String {
        let prefix = get_prefix(&s);
        let contents = s.clone();
        let contents = contents.strip_prefix(prefix.full().as_str()).unwrap();
        let contents = contents.strip_suffix(prefix.quotes.as_str()).unwrap();

        contents.to_owned()
    }

    #[test]
    fn test_get_string_contents() {
        let s = "rb'''hello'''";
        assert_eq!(get_string_contents(s.to_owned()), "hello");
        let s = "Br\"\"\"hello\"\"\"";
        assert_eq!(get_string_contents(s.to_owned()), "hello");
        let s = "FR\"hello\"";
        assert_eq!(get_string_contents(s.to_owned()), "hello");
        let s = "uR'hello'";
        assert_eq!(get_string_contents(s.to_owned()), "hello");
        let s = "''";
        assert_eq!(get_string_contents(s.to_owned()), "");
        let s = "\"\"";
        assert_eq!(get_string_contents(s.to_owned()), "");
        let s = "\"\"\"\"\"\"";
        assert_eq!(get_string_contents(s.to_owned()), "");
        let s = "''''''";
        assert_eq!(get_string_contents(s.to_owned()), "");
    }

    pub struct StringPrefix;

    impl Function for StringPrefix {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let prefix = get_prefix(&source[node.byte_range()]).full();
            Ok(Value::String(prefix))
        }
    }

    pub struct StringContents;

    impl Function for StringContents {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let contents = get_string_contents(source[node.byte_range()].to_owned());
            Ok(Value::String(contents))
        }
    }

    pub struct StringQuotes;

    impl Function for StringQuotes {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let prefix = get_prefix(&source[node.byte_range()]);
            Ok(Value::String(prefix.quotes))
        }
    }

    // Gets a version of the prefix that can be used in a call to `literal_eval`. To do so, we must remove
    // any `f` or `F` characters, if present.
    pub struct StringSafePrefix;

    impl Function for StringSafePrefix {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let prefix = get_prefix(&source[node.byte_range()]).full();
            let prefix = prefix.replace("f", "").replace("F", "");
            Ok(Value::String(prefix))
        }
    }

    // Gets a version of the string where `f` and `F` have been stripped from the prefix.
    pub struct SafeString;

    impl Function for SafeString {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let prefix = get_prefix(&source[node.byte_range()]);
            let contents = get_string_contents(source[node.byte_range()].to_owned());
            let s = format!("{}{}{}", prefix.safe().full(), contents, prefix.quotes);
            Ok(Value::String(s))
        }
    }

    pub struct UnnamedChildIndex;

    impl Function for UnnamedChildIndex {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let parent = match node.parent() {
                Some(parent) => parent,
                None => {
                    return Err(ExecutionError::FunctionFailed(
                        "unnamed-child-index".into(),
                        format!("Cannot call child-index on the root node"),
                    ))
                }
            };
            let mut tree_cursor = parent.walk();
            let index = parent
                .children(&mut tree_cursor)
                .position(|child| child == node)
                .ok_or_else(|| {
                    ExecutionError::FunctionFailed(
                        "unnamed-child-index".into(),
                        format!("Called child-index on a non-named child"),
                    )
                })?;
            Ok(Value::Integer(index as u32))
        }
    }

    pub struct ConcatenateStrings;

    impl Function for ConcatenateStrings {
        fn call(
            &self,
            _graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let mut result = String::new();
            while let Ok(param) = parameters.param() {
                let string = param.into_string()?;
                result.push_str(string.as_str());
            }
            Ok(Value::String(result))
        }
    }

    pub struct InstanceOf;

    impl Function for InstanceOf {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            let class_name = parameters.param()?.into_string()?;
            parameters.finish()?;
            let node_type = node.kind();
            let class_name = class_name.as_str();
            let is_instance = node_type == class_name;
            Ok(Value::Boolean(is_instance))
        }
    }

    pub struct GetParent;

    impl Function for GetParent {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            parameters.finish()?;
            let parent = node.parent().ok_or_else(|| {
                ExecutionError::FunctionFailed(
                    "get-parent".into(),
                    format!("Cannot call get-parent on the root node"),
                )
            })?;
            Ok(Value::SyntaxNode(graph.add_syntax_node(parent)))
        }
    }

    pub struct HasNamedChild;

    impl Function for HasNamedChild {
        fn call(
            &self,
            graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            let field_name = parameters.param()?.into_string()?;
            parameters.finish()?;
            let field_name = field_name.as_str();
            let has_named_child = node.child_by_field_name(field_name).is_some();
            Ok(Value::Boolean(has_named_child))
        }
    }

    pub struct IsBooleanOperator;

    impl Function for IsBooleanOperator {
        fn call(
            &self,
            graph: &mut Graph,
            source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let node = graph[parameters.param()?.into_syntax_node_ref()?];
            let expected_op_type = parameters.param()?.into_string()?;
            parameters.finish()?;
            if let Some(op) = node.child_by_field_name("operator") {
                let op_type = source[op.byte_range()].to_string();
                let is_boolean_op = expected_op_type == op_type;
                Ok(Value::Boolean(is_boolean_op))
            } else {
                Ok(Value::Boolean(false))
            }
        }
    }

    pub struct Modulo;

    impl Function for Modulo {
        fn call(
            &self,
            _graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let left = parameters.param()?.into_integer()?;
            let right = parameters.param()?.into_integer()?;
            parameters.finish()?;
            Ok(Value::Integer(left % right))
        }
    }

    pub struct GetLastElement;

    impl Function for GetLastElement {
        fn call(
            &self,
            _graph: &mut Graph,
            _source: &str,
            parameters: &mut dyn Parameters,
        ) -> Result<Value, ExecutionError> {
            let list = parameters.param()?.into_list()?;
            parameters.finish()?;
            let last = list.last().unwrap_or(&Value::Null).clone();
            Ok(last)
        }
    }
}

fn main() -> Result<()> {
    let matches = App::new("tsg-python")
        .version(BUILD_VERSION)
        .author("Taus Brock-Nannestad <tausbn@github.com>")
        .about("Extracts a Python AST from the parse tree given by tree-sitter-python")
        .arg(
            Arg::with_name("tsg")
                .short("t")
                .long("tsg")
                .takes_value(true)
                .required(false),
        )
        .arg(Arg::with_name("source").index(1).required(true))
        .get_matches();

    let tsg_path = if matches.is_present("tsg") {
        Path::new(matches.value_of("tsg").unwrap())
            .display()
            .to_string()
    } else {
        "bundled `python.tsg`".to_owned()
    };
    let source_path = Path::new(matches.value_of("source").unwrap());
    let language = tsp::language();
    let mut parser = Parser::new();
    parser.set_language(language)?;
    // Statically include `python.tsg`:
    let tsg = if matches.is_present("tsg") {
        std::fs::read(&tsg_path).with_context(|| format!("Error reading TSG file {}", tsg_path))?
    } else {
        include_bytes!("../python.tsg").to_vec()
    };
    let tsg = String::from_utf8(tsg)?;
    let source = std::fs::read(source_path)
        .with_context(|| format!("Error reading source file {}", source_path.display()))?;
    let source = String::from_utf8(source)?;
    let tree = parser
        .parse(&source, None)
        .ok_or_else(|| anyhow!("Could not parse {}", source_path.display()))?;
    let file = File::from_str(language, &tsg)
        .with_context(|| anyhow!("Error parsing TSG file {}", tsg_path))?;
    let mut functions = Functions::stdlib();
    functions.add(Identifier::from("location"), extra_functions::Location);
    functions.add(
        Identifier::from("location-start"),
        extra_functions::LocationStart,
    );
    functions.add(
        Identifier::from("location-end"),
        extra_functions::LocationEnd,
    );
    functions.add(
        Identifier::from("string-prefix"),
        extra_functions::StringPrefix,
    );
    functions.add(
        Identifier::from("string-contents"),
        extra_functions::StringContents,
    );

    functions.add(
        Identifier::from("string-quotes"),
        extra_functions::StringQuotes,
    );

    functions.add(
        Identifier::from("string-safe-prefix"),
        extra_functions::StringSafePrefix,
    );

    functions.add(Identifier::from("safe-string"), extra_functions::SafeString);

    functions.add(
        Identifier::from("unnamed-child-index"),
        extra_functions::UnnamedChildIndex,
    );
    functions.add(Identifier::from("ast-node"), extra_functions::AstNode);

    functions.add(
        Identifier::from("concatenate-strings"),
        extra_functions::ConcatenateStrings,
    );

    functions.add(Identifier::from("instance-of"), extra_functions::InstanceOf);

    functions.add(Identifier::from("get-parent"), extra_functions::GetParent);

    functions.add(
        Identifier::from("has-named-child"),
        extra_functions::HasNamedChild,
    );
    functions.add(
        Identifier::from("is-boolean-operator"),
        extra_functions::IsBooleanOperator,
    );

    functions.add(Identifier::from("mod"), extra_functions::Modulo);

    functions.add(
        Identifier::from("get-last-element"),
        extra_functions::GetLastElement,
    );

    let globals = Variables::new();
    let mut config = ExecutionConfig::new(&mut functions, &globals).lazy(false);
    let graph = file
        .execute(&tree, &source, &mut config, &NoCancellation)
        .with_context(|| format!("Could not execute TSG file {}", tsg_path))?;
    print!("{}", graph.pretty_print());
    Ok(())
}
