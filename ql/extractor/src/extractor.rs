use node_types::{EntryKind, Field, NodeTypeMap, Storage, TypeName};
use std::borrow::Cow;
use std::collections::BTreeMap as Map;
use std::collections::BTreeSet as Set;
use std::fmt;
use std::io::Write;
use std::path::Path;

use tracing::{error, info, span, Level};
use tree_sitter::{Language, Node, Parser, Range, Tree};

pub struct TrapWriter {
    /// The accumulated trap entries
    trap_output: Vec<TrapEntry>,
    /// A counter for generating fresh labels
    counter: u32,
    /// cache of global keys
    global_keys: std::collections::HashMap<String, Label>,
}

pub fn new_trap_writer() -> TrapWriter {
    TrapWriter {
        counter: 0,
        trap_output: Vec::new(),
        global_keys: std::collections::HashMap::new(),
    }
}

impl TrapWriter {
    ///  Gets a label that will hold the unique ID of the passed string at import time.
    ///  This can be used for incrementally importable TRAP files -- use globally unique
    ///  strings to compute a unique ID for table tuples.
    ///
    ///  Note: You probably want to make sure that the key strings that you use are disjoint
    ///  for disjoint column types; the standard way of doing this is to prefix (or append)
    ///  the column type name to the ID. Thus, you might identify methods in Java by the
    ///  full ID "methods_com.method.package.DeclaringClass.method(argumentList)".

    fn fresh_id(&mut self) -> Label {
        let label = Label(self.counter);
        self.counter += 1;
        self.trap_output.push(TrapEntry::FreshId(label));
        label
    }

    fn global_id(&mut self, key: &str) -> (Label, bool) {
        if let Some(label) = self.global_keys.get(key) {
            return (*label, false);
        }
        let label = Label(self.counter);
        self.counter += 1;
        self.global_keys.insert(key.to_owned(), label);
        self.trap_output
            .push(TrapEntry::MapLabelToKey(label, key.to_owned()));
        (label, true)
    }

    fn add_tuple(&mut self, table_name: &str, args: Vec<Arg>) {
        self.trap_output
            .push(TrapEntry::GenericTuple(table_name.to_owned(), args))
    }

    fn populate_file(&mut self, absolute_path: &Path) -> Label {
        let (file_label, fresh) = self.global_id(&full_id_for_file(absolute_path));
        if fresh {
            self.add_tuple(
                "files",
                vec![
                    Arg::Label(file_label),
                    Arg::String(normalize_path(absolute_path)),
                ],
            );
            self.populate_parent_folders(file_label, absolute_path.parent());
        }
        file_label
    }

    fn populate_empty_file(&mut self) -> Label {
        let (file_label, fresh) = self.global_id("empty;sourcefile");
        if fresh {
            self.add_tuple(
                "files",
                vec![Arg::Label(file_label), Arg::String("".to_string())],
            );
        }
        file_label
    }

    pub fn populate_empty_location(&mut self) {
        let file_label = self.populate_empty_file();
        self.location(file_label, 0, 0, 0, 0);
    }

    fn populate_parent_folders(&mut self, child_label: Label, path: Option<&Path>) {
        let mut path = path;
        let mut child_label = child_label;
        loop {
            match path {
                None => break,
                Some(folder) => {
                    let (folder_label, fresh) = self.global_id(&full_id_for_folder(folder));
                    self.add_tuple(
                        "containerparent",
                        vec![Arg::Label(folder_label), Arg::Label(child_label)],
                    );
                    if fresh {
                        self.add_tuple(
                            "folders",
                            vec![
                                Arg::Label(folder_label),
                                Arg::String(normalize_path(folder)),
                            ],
                        );
                        path = folder.parent();
                        child_label = folder_label;
                    } else {
                        break;
                    }
                }
            }
        }
    }

    fn location(
        &mut self,
        file_label: Label,
        start_line: usize,
        start_column: usize,
        end_line: usize,
        end_column: usize,
    ) -> Label {
        let (loc_label, fresh) = self.global_id(&format!(
            "loc,{{{}}},{},{},{},{}",
            file_label, start_line, start_column, end_line, end_column
        ));
        if fresh {
            self.add_tuple(
                "locations_default",
                vec![
                    Arg::Label(loc_label),
                    Arg::Label(file_label),
                    Arg::Int(start_line),
                    Arg::Int(start_column),
                    Arg::Int(end_line),
                    Arg::Int(end_column),
                ],
            );
        }
        loc_label
    }

    fn comment(&mut self, text: String) {
        self.trap_output.push(TrapEntry::Comment(text));
    }

    pub fn output(self, writer: &mut dyn Write) -> std::io::Result<()> {
        write!(writer, "{}", Program(self.trap_output))
    }
}

/// Extracts the source file at `path`, which is assumed to be canonicalized.
pub fn extract(
    language: Language,
    language_prefix: &str,
    schema: &NodeTypeMap,
    trap_writer: &mut TrapWriter,
    path: &Path,
    source: &[u8],
    ranges: &[Range],
) -> std::io::Result<()> {
    let span = span!(
        Level::TRACE,
        "extract",
        file = %path.display()
    );

    let _enter = span.enter();

    info!("extracting: {}", path.display());

    let mut parser = Parser::new();
    parser.set_language(language).unwrap();
    parser.set_included_ranges(ranges).unwrap();
    let tree = parser.parse(&source, None).expect("Failed to parse file");
    trap_writer.comment(format!("Auto-generated TRAP file for {}", path.display()));
    let file_label = &trap_writer.populate_file(path);
    let mut visitor = Visitor {
        source,
        trap_writer,
        // TODO: should we handle path strings that are not valid UTF8 better?
        path: format!("{}", path.display()),
        file_label: *file_label,
        toplevel_child_counter: 0,
        stack: Vec::new(),
        language_prefix,
        schema,
    };
    traverse(&tree, &mut visitor);

    parser.reset();
    Ok(())
}

/// Escapes a string for use in a TRAP key, by replacing special characters with
/// HTML entities.
fn escape_key<'a, S: Into<Cow<'a, str>>>(key: S) -> Cow<'a, str> {
    fn needs_escaping(c: char) -> bool {
        matches!(c, '&' | '{' | '}' | '"' | '@' | '#')
    }

    let key = key.into();
    if key.contains(needs_escaping) {
        let mut escaped = String::with_capacity(2 * key.len());
        for c in key.chars() {
            match c {
                '&' => escaped.push_str("&amp;"),
                '{' => escaped.push_str("&lbrace;"),
                '}' => escaped.push_str("&rbrace;"),
                '"' => escaped.push_str("&quot;"),
                '@' => escaped.push_str("&commat;"),
                '#' => escaped.push_str("&num;"),
                _ => escaped.push(c),
            }
        }
        Cow::Owned(escaped)
    } else {
        key
    }
}

/// Normalizes the path according the common CodeQL specification. Assumes that
/// `path` has already been canonicalized using `std::fs::canonicalize`.
fn normalize_path(path: &Path) -> String {
    if cfg!(windows) {
        // The way Rust canonicalizes paths doesn't match the CodeQL spec, so we
        // have to do a bit of work removing certain prefixes and replacing
        // backslashes.
        let mut components: Vec<String> = Vec::new();
        for component in path.components() {
            match component {
                std::path::Component::Prefix(prefix) => match prefix.kind() {
                    std::path::Prefix::Disk(letter) | std::path::Prefix::VerbatimDisk(letter) => {
                        components.push(format!("{}:", letter as char));
                    }
                    std::path::Prefix::Verbatim(x) | std::path::Prefix::DeviceNS(x) => {
                        components.push(x.to_string_lossy().to_string());
                    }
                    std::path::Prefix::UNC(server, share)
                    | std::path::Prefix::VerbatimUNC(server, share) => {
                        components.push(server.to_string_lossy().to_string());
                        components.push(share.to_string_lossy().to_string());
                    }
                },
                std::path::Component::Normal(n) => {
                    components.push(n.to_string_lossy().to_string());
                }
                std::path::Component::RootDir => {}
                std::path::Component::CurDir => {}
                std::path::Component::ParentDir => {}
            }
        }
        components.join("/")
    } else {
        // For other operating systems, we can use the canonicalized path
        // without modifications.
        format!("{}", path.display())
    }
}

fn full_id_for_file(path: &Path) -> String {
    format!("{};sourcefile", escape_key(&normalize_path(path)))
}

fn full_id_for_folder(path: &Path) -> String {
    format!("{};folder", escape_key(&normalize_path(path)))
}

struct ChildNode {
    field_name: Option<&'static str>,
    label: Label,
    type_name: TypeName,
}

struct Visitor<'a> {
    /// The file path of the source code (as string)
    path: String,
    /// The label to use whenever we need to refer to the `@file` entity of this
    /// source file.
    file_label: Label,
    /// The source code as a UTF-8 byte array
    source: &'a [u8],
    /// A TrapWriter to accumulate trap entries
    trap_writer: &'a mut TrapWriter,
    /// A counter for top-level child nodes
    toplevel_child_counter: usize,
    /// Language prefix
    language_prefix: &'a str,
    /// A lookup table from type name to node types
    schema: &'a NodeTypeMap,
    /// A stack for gathering information from child nodes. Whenever a node is
    /// entered the parent's [Label], child counter, and an empty list is pushed.
    /// All children append their data to the the list. When the visitor leaves a
    /// node the list containing the child data is popped from the stack and
    /// matched against the dbscheme for the node. If the expectations are met
    /// the corresponding row definitions are added to the trap_output.
    stack: Vec<(Label, usize, Vec<ChildNode>)>,
}

impl Visitor<'_> {
    fn record_parse_error(
        &mut self,
        error_message: String,
        full_error_message: String,
        loc: Label,
    ) {
        error!("{}", full_error_message);
        let id = self.trap_writer.fresh_id();
        self.trap_writer.add_tuple(
            "diagnostics",
            vec![
                Arg::Label(id),
                Arg::Int(40), // severity 40 = error
                Arg::String("parse_error".to_string()),
                Arg::String(error_message),
                Arg::String(full_error_message),
                Arg::Label(loc),
            ],
        );
    }

    fn record_parse_error_for_node(
        &mut self,
        error_message: String,
        full_error_message: String,
        node: Node,
    ) {
        let (start_line, start_column, end_line, end_column) = location_for(self.source, node);
        let loc = self.trap_writer.location(
            self.file_label,
            start_line,
            start_column,
            end_line,
            end_column,
        );
        self.record_parse_error(error_message, full_error_message, loc);
    }

    fn enter_node(&mut self, node: Node) -> bool {
        if node.is_error() || node.is_missing() {
            let error_message = if node.is_missing() {
                format!("parse error: expecting '{}'", node.kind())
            } else {
                "parse error".to_string()
            };
            let full_error_message = format!(
                "{}:{}: {}",
                &self.path,
                node.start_position().row + 1,
                error_message
            );
            self.record_parse_error_for_node(error_message, full_error_message, node);
            return false;
        }

        let id = self.trap_writer.fresh_id();

        self.stack.push((id, 0, Vec::new()));
        true
    }

    fn leave_node(&mut self, field_name: Option<&'static str>, node: Node) {
        if node.is_error() || node.is_missing() {
            return;
        }
        let (id, _, child_nodes) = self.stack.pop().expect("Vistor: empty stack");
        let (start_line, start_column, end_line, end_column) = location_for(self.source, node);
        let loc = self.trap_writer.location(
            self.file_label,
            start_line,
            start_column,
            end_line,
            end_column,
        );
        let table = self
            .schema
            .get(&TypeName {
                kind: node.kind().to_owned(),
                named: node.is_named(),
            })
            .unwrap();
        let mut valid = true;
        let (parent_id, parent_index) = match self.stack.last_mut() {
            Some(p) if !node.is_extra() => {
                p.1 += 1;
                (p.0, p.1 - 1)
            }
            _ => {
                self.toplevel_child_counter += 1;
                (self.file_label, self.toplevel_child_counter - 1)
            }
        };
        match &table.kind {
            EntryKind::Token { kind_id, .. } => {
                self.trap_writer.add_tuple(
                    &format!("{}_ast_node_info", self.language_prefix),
                    vec![
                        Arg::Label(id),
                        Arg::Label(parent_id),
                        Arg::Int(parent_index),
                        Arg::Label(loc),
                    ],
                );
                self.trap_writer.add_tuple(
                    &format!("{}_tokeninfo", self.language_prefix),
                    vec![
                        Arg::Label(id),
                        Arg::Int(*kind_id),
                        sliced_source_arg(self.source, node),
                    ],
                );
            }
            EntryKind::Table {
                fields,
                name: table_name,
            } => {
                if let Some(args) = self.complex_node(&node, fields, &child_nodes, id) {
                    self.trap_writer.add_tuple(
                        &format!("{}_ast_node_info", self.language_prefix),
                        vec![
                            Arg::Label(id),
                            Arg::Label(parent_id),
                            Arg::Int(parent_index),
                            Arg::Label(loc),
                        ],
                    );
                    let mut all_args = vec![Arg::Label(id)];
                    all_args.extend(args);
                    self.trap_writer.add_tuple(table_name, all_args);
                }
            }
            _ => {
                let error_message = format!("unknown table type: '{}'", node.kind());
                let full_error_message = format!(
                    "{}:{}: {}",
                    &self.path,
                    node.start_position().row + 1,
                    error_message
                );
                self.record_parse_error(error_message, full_error_message, loc);

                valid = false;
            }
        }
        if valid && !node.is_extra() {
            // Extra nodes are independent root nodes and do not belong to the parent node
            // Therefore we should not register them in the parent vector
            if let Some(parent) = self.stack.last_mut() {
                parent.2.push(ChildNode {
                    field_name,
                    label: id,
                    type_name: TypeName {
                        kind: node.kind().to_owned(),
                        named: node.is_named(),
                    },
                });
            };
        }
    }

    fn complex_node(
        &mut self,
        node: &Node,
        fields: &[Field],
        child_nodes: &[ChildNode],
        parent_id: Label,
    ) -> Option<Vec<Arg>> {
        let mut map: Map<&Option<String>, (&Field, Vec<Arg>)> = Map::new();
        for field in fields {
            map.insert(&field.name, (field, Vec::new()));
        }
        for child_node in child_nodes {
            if let Some((field, values)) = map.get_mut(&child_node.field_name.map(|x| x.to_owned()))
            {
                //TODO: handle error and missing nodes
                if self.type_matches(&child_node.type_name, &field.type_info) {
                    if let node_types::FieldTypeInfo::ReservedWordInt(int_mapping) =
                        &field.type_info
                    {
                        // We can safely unwrap because type_matches checks the key is in the map.
                        let (int_value, _) = int_mapping.get(&child_node.type_name.kind).unwrap();
                        values.push(Arg::Int(*int_value));
                    } else {
                        values.push(Arg::Label(child_node.label));
                    }
                } else if field.name.is_some() {
                    let error_message = format!(
                        "type mismatch for field {}::{} with type {:?} != {:?}",
                        node.kind(),
                        child_node.field_name.unwrap_or("child"),
                        child_node.type_name,
                        field.type_info
                    );
                    let full_error_message = format!(
                        "{}:{}: {}",
                        &self.path,
                        node.start_position().row + 1,
                        error_message
                    );
                    self.record_parse_error_for_node(error_message, full_error_message, *node);
                }
            } else if child_node.field_name.is_some() || child_node.type_name.named {
                let error_message = format!(
                    "value for unknown field: {}::{} and type {:?}",
                    node.kind(),
                    &child_node.field_name.unwrap_or("child"),
                    &child_node.type_name
                );
                let full_error_message = format!(
                    "{}:{}: {}",
                    &self.path,
                    node.start_position().row + 1,
                    error_message
                );
                self.record_parse_error_for_node(error_message, full_error_message, *node);
            }
        }
        let mut args = Vec::new();
        let mut is_valid = true;
        for field in fields {
            let child_values = &map.get(&field.name).unwrap().1;
            match &field.storage {
                Storage::Column { name: column_name } => {
                    if child_values.len() == 1 {
                        args.push(child_values.first().unwrap().clone());
                    } else {
                        is_valid = false;
                        let error_message = format!(
                            "{} for field: {}::{}",
                            if child_values.is_empty() {
                                "missing value"
                            } else {
                                "too many values"
                            },
                            node.kind(),
                            column_name
                        );
                        let full_error_message = format!(
                            "{}:{}: {}",
                            &self.path,
                            node.start_position().row + 1,
                            error_message
                        );
                        self.record_parse_error_for_node(error_message, full_error_message, *node);
                    }
                }
                Storage::Table {
                    name: table_name,
                    has_index,
                    column_name: _,
                } => {
                    for (index, child_value) in child_values.iter().enumerate() {
                        if !*has_index && index > 0 {
                            error!(
                                "{}:{}: too many values for field: {}::{}",
                                &self.path,
                                node.start_position().row + 1,
                                node.kind(),
                                table_name,
                            );
                            break;
                        }
                        let mut args = vec![Arg::Label(parent_id)];
                        if *has_index {
                            args.push(Arg::Int(index))
                        }
                        args.push(child_value.clone());
                        self.trap_writer.add_tuple(table_name, args);
                    }
                }
            }
        }
        if is_valid {
            Some(args)
        } else {
            None
        }
    }

    fn type_matches(&self, tp: &TypeName, type_info: &node_types::FieldTypeInfo) -> bool {
        match type_info {
            node_types::FieldTypeInfo::Single(single_type) => {
                if tp == single_type {
                    return true;
                }
                if let EntryKind::Union { members } = &self.schema.get(single_type).unwrap().kind {
                    if self.type_matches_set(tp, members) {
                        return true;
                    }
                }
            }
            node_types::FieldTypeInfo::Multiple { types, .. } => {
                return self.type_matches_set(tp, types);
            }

            node_types::FieldTypeInfo::ReservedWordInt(int_mapping) => {
                return !tp.named && int_mapping.contains_key(&tp.kind)
            }
        }
        false
    }

    fn type_matches_set(&self, tp: &TypeName, types: &Set<TypeName>) -> bool {
        if types.contains(tp) {
            return true;
        }
        for other in types.iter() {
            if let EntryKind::Union { members } = &self.schema.get(other).unwrap().kind {
                if self.type_matches_set(tp, members) {
                    return true;
                }
            }
        }
        false
    }
}

// Emit a slice of a source file as an Arg.
fn sliced_source_arg(source: &[u8], n: Node) -> Arg {
    let range = n.byte_range();
    Arg::String(String::from_utf8_lossy(&source[range.start..range.end]).into_owned())
}

// Emit a pair of `TrapEntry`s for the provided node, appropriately calibrated.
// The first is the location and label definition, and the second is the
// 'Located' entry.
fn location_for(source: &[u8], n: Node) -> (usize, usize, usize, usize) {
    // Tree-sitter row, column values are 0-based while CodeQL starts
    // counting at 1. In addition Tree-sitter's row and column for the
    // end position are exclusive while CodeQL's end positions are inclusive.
    // This means that all values should be incremented by 1 and in addition the
    // end position needs to be shift 1 to the left. In most cases this means
    // simply incrementing all values except the end column except in cases where
    // the end column is 0 (start of a line). In such cases the end position must be
    // set to the end of the previous line.
    let start_line = n.start_position().row + 1;
    let start_col = n.start_position().column + 1;
    let mut end_line = n.end_position().row + 1;
    let mut end_col = n.end_position().column;
    if start_line > end_line || start_line == end_line && start_col > end_col {
        // the range is empty, clip it to sensible values
        end_line = start_line;
        end_col = start_col - 1;
    } else if end_col == 0 {
        // end_col = 0 means that we are at the start of a line
        // unfortunately 0 is invalid as column number, therefore
        // we should update the end location to be the end of the
        // previous line
        let mut index = n.end_byte();
        if index > 0 && index <= source.len() {
            index -= 1;
            if source[index] != b'\n' {
                error!("expecting a line break symbol, but none found while correcting end column value");
            }
            end_line -= 1;
            end_col = 1;
            while index > 0 && source[index - 1] != b'\n' {
                index -= 1;
                end_col += 1;
            }
        } else {
            error!(
                "cannot correct end column value: end_byte index {} is not in range [1,{}]",
                index,
                source.len()
            );
        }
    }
    (start_line, start_col, end_line, end_col)
}

fn traverse(tree: &Tree, visitor: &mut Visitor) {
    let cursor = &mut tree.walk();
    visitor.enter_node(cursor.node());
    let mut recurse = true;
    loop {
        if recurse && cursor.goto_first_child() {
            recurse = visitor.enter_node(cursor.node());
        } else {
            visitor.leave_node(cursor.field_name(), cursor.node());

            if cursor.goto_next_sibling() {
                recurse = visitor.enter_node(cursor.node());
            } else if cursor.goto_parent() {
                recurse = false;
            } else {
                break;
            }
        }
    }
}

pub struct Program(Vec<TrapEntry>);

impl fmt::Display for Program {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let mut text = String::new();
        for trap_entry in &self.0 {
            text.push_str(&format!("{}\n", trap_entry));
        }
        write!(f, "{}", text)
    }
}

enum TrapEntry {
    /// Maps the label to a fresh id, e.g. `#123=*`.
    FreshId(Label),
    /// Maps the label to a key, e.g. `#7=@"foo"`.
    MapLabelToKey(Label, String),
    /// foo_bar(arg*)
    GenericTuple(String, Vec<Arg>),
    Comment(String),
}
impl fmt::Display for TrapEntry {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            TrapEntry::FreshId(label) => write!(f, "{}=*", label),
            TrapEntry::MapLabelToKey(label, key) => {
                write!(f, "{}=@\"{}\"", label, key.replace("\"", "\"\""))
            }
            TrapEntry::GenericTuple(name, args) => {
                write!(f, "{}(", name)?;
                for (index, arg) in args.iter().enumerate() {
                    if index > 0 {
                        write!(f, ",")?;
                    }
                    write!(f, "{}", arg)?;
                }
                write!(f, ")")
            }
            TrapEntry::Comment(line) => write!(f, "// {}", line),
        }
    }
}

#[derive(Debug, Copy, Clone)]
// Identifiers of the form #0, #1...
struct Label(u32);

impl fmt::Display for Label {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

// Numeric indices.
#[derive(Debug, Copy, Clone)]
struct Index(usize);

impl fmt::Display for Index {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

// Some untyped argument to a TrapEntry.
#[derive(Debug, Clone)]
enum Arg {
    Label(Label),
    Int(usize),
    String(String),
}

const MAX_STRLEN: usize = 1048576;

impl fmt::Display for Arg {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Arg::Label(x) => write!(f, "{}", x),
            Arg::Int(x) => write!(f, "{}", x),
            Arg::String(x) => write!(
                f,
                "\"{}\"",
                limit_string(x, MAX_STRLEN).replace("\"", "\"\"")
            ),
        }
    }
}

/// Limit the length (in bytes) of a string. If the string's length in bytes is
/// less than or equal to the limit then the entire string is returned. Otherwise
/// the string is sliced at the provided limit. If there is a multi-byte character
/// at the limit then the returned slice will be slightly shorter than the limit to
/// avoid splitting that multi-byte character.
fn limit_string(string: &str, max_size: usize) -> &str {
    if string.len() <= max_size {
        return string;
    }
    let p = string.as_bytes();
    let mut index = max_size;
    // We want to clip the string at [max_size]; however, the character at that position
    // may span several bytes. We need to find the first byte of the character. In UTF-8
    // encoded data any byte that matches the bit pattern 10XXXXXX is not a start byte.
    // Therefore we decrement the index as long as there are bytes matching this pattern.
    // This ensures we cut the string at the border between one character and another.
    while index > 0 && (p[index] & 0b11000000) == 0b10000000 {
        index -= 1;
    }
    &string[0..index]
}

#[test]
fn limit_string_test() {
    assert_eq!("hello", limit_string(&"hello world".to_owned(), 5));
    assert_eq!("hi ☹", limit_string(&"hi ☹☹".to_owned(), 6));
    assert_eq!("hi ", limit_string(&"hi ☹☹".to_owned(), 5));
}

#[test]
fn escape_key_test() {
    assert_eq!("foo!", escape_key("foo!"));
    assert_eq!("foo&lbrace;&rbrace;", escape_key("foo{}"));
    assert_eq!("&lbrace;&rbrace;", escape_key("{}"));
    assert_eq!("", escape_key(""));
    assert_eq!("/path/to/foo.rb", escape_key("/path/to/foo.rb"));
    assert_eq!(
        "/path/to/foo&amp;&lbrace;&rbrace;&quot;&commat;&num;.rb",
        escape_key("/path/to/foo&{}\"@#.rb")
    );
}
