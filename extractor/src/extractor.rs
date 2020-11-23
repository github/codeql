use node_types::{EntryKind, Field, NodeTypeMap, Storage, TypeName};
use std::collections::BTreeMap as Map;
use std::collections::BTreeSet as Set;
use std::fmt;
use std::path::Path;
use tracing::{error, info, span, Level};
use tree_sitter::{Language, Node, Parser, Tree};

struct TrapWriter {
    /// The accumulated trap entries
    trap_output: Vec<TrapEntry>,
    /// A counter for generating fresh labels
    counter: u32,
    /// cache of global keys
    global_keys: std::collections::HashMap<String, Label>,
}

fn new_trap_writer() -> TrapWriter {
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
                    Arg::String(match absolute_path.file_name() {
                        None => "".to_owned(),
                        Some(file_name) => format!("{}", file_name.to_string_lossy()),
                    }),
                    Arg::String(match absolute_path.extension() {
                        None => "".to_owned(),
                        Some(ext) => format!("{}", ext.to_string_lossy()),
                    }),
                    Arg::Int(1), // 1 = from source
                ],
            );
            self.populate_parent_folders(file_label, absolute_path.parent());
        }
        file_label
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
                                Arg::String(match folder.file_name() {
                                    None => "".to_owned(),
                                    Some(file_name) => format!("{}", file_name.to_string_lossy()),
                                }),
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
}

pub struct Extractor {
    pub parser: Parser,
    pub schema: NodeTypeMap,
}

pub fn create(language: Language, schema: NodeTypeMap) -> Extractor {
    let mut parser = Parser::new();
    parser.set_language(language).unwrap();

    Extractor { parser, schema }
}

impl Extractor {
    /// Extracts the source file at `path`, which is assumed to be canonicalized.
    pub fn extract<'a>(&'a mut self, path: &Path) -> std::io::Result<Program> {
        let span = span!(
            Level::TRACE,
            "extract",
            file = %path.display()
        );

        let _enter = span.enter();

        info!("extracting: {}", path.display());

        let source = std::fs::read(&path)?;
        let tree = &self
            .parser
            .parse(&source, None)
            .expect("Failed to parse file");
        let mut trap_writer = new_trap_writer();
        trap_writer.comment(format!("Auto-generated TRAP file for {}", path.display()));
        let file_label = &trap_writer.populate_file(path);
        let mut visitor = Visitor {
            source: &source,
            trap_writer: trap_writer,
            // TODO: should we handle path strings that are not valid UTF8 better?
            path: format!("{}", path.display()),
            file_label: *file_label,
            token_counter: 0,
            stack: Vec::new(),
            schema: &self.schema,
        };
        traverse(&tree, &mut visitor);

        &self.parser.reset();
        Ok(Program(visitor.trap_writer.trap_output))
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
    format!("{};sourcefile", normalize_path(path))
}

fn full_id_for_folder(path: &Path) -> String {
    format!("{};folder", normalize_path(path))
}

struct Visitor<'a> {
    /// The file path of the source code (as string)
    path: String,
    /// The label to use whenever we need to refer to the `@file` entity of this
    /// source file.
    file_label: Label,
    /// The source code as a UTF-8 byte array
    source: &'a Vec<u8>,
    /// A TrapWriter to accumulate trap entries
    trap_writer: TrapWriter,
    /// A counter for tokens
    token_counter: usize,
    /// A lookup table from type name to node types
    schema: &'a NodeTypeMap,
    /// A stack for gathering information from child nodes. Whenever a node is entered
    /// the parent's [Label] and an empty list is pushed. All children append their data
    /// (field name, label, type) to the the list. When the visitor leaves a node the list
    /// containing the child data is popped from the stack and matched against the dbscheme
    /// for the node. If the expectations are met the corresponding row definitions are
    /// added to the trap_output.
    stack: Vec<(Label, Vec<(Option<&'static str>, Label, TypeName)>)>,
}

impl Visitor<'_> {
    fn enter_node(&mut self, node: Node) -> bool {
        if node.is_error() {
            error!(
                "{}:{}: parse error",
                &self.path,
                node.start_position().row + 1
            );
            return false;
        }
        if node.is_missing() {
            error!(
                "{}:{}: parse error: expecting '{}'",
                &self.path,
                node.start_position().row + 1,
                node.kind()
            );
            return false;
        }

        let id = self.trap_writer.fresh_id();

        self.stack.push((id, Vec::new()));
        return true;
    }

    fn leave_node(&mut self, field_name: Option<&'static str>, node: Node) {
        if node.is_error() || node.is_missing() {
            return;
        }
        let (id, child_nodes) = self.stack.pop().expect("Vistor: empty stack");
        let (start_line, start_column, end_line, end_column) = location_for(&self.source, node);
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
        let parent_id = match self.stack.last_mut() {
            Some(p) if !node.is_extra() => p.0,
            _ => self.file_label,
        };
        match &table.kind {
            EntryKind::Token { kind_id, .. } => {
                self.trap_writer.add_tuple(
                    "tokeninfo",
                    vec![
                        Arg::Label(id),
                        Arg::Label(parent_id),
                        Arg::Int(*kind_id),
                        Arg::Label(self.file_label),
                        Arg::Int(self.token_counter),
                        sliced_source_arg(self.source, node),
                        Arg::Label(loc),
                    ],
                );
                self.token_counter += 1;
            }
            EntryKind::Table {
                fields,
                name: table_name,
            } => {
                if let Some(args) = self.complex_node(&node, fields, child_nodes, id) {
                    let mut all_args = Vec::new();
                    all_args.push(Arg::Label(id));
                    all_args.push(Arg::Label(parent_id));
                    all_args.extend(args);
                    all_args.push(Arg::Label(loc));
                    self.trap_writer.add_tuple(&table_name, all_args);
                }
            }
            _ => {
                error!(
                    "{}:{}: unknown table type: '{}'",
                    &self.path,
                    node.start_position().row + 1,
                    node.kind()
                );
                valid = false;
            }
        }
        if valid && !node.is_extra() {
            // Extra nodes are independent root nodes and do not belong to the parent node
            // Therefore we should not register them in the parent vector
            if let Some(parent) = self.stack.last_mut() {
                parent.1.push((
                    field_name,
                    id,
                    TypeName {
                        kind: node.kind().to_owned(),
                        named: node.is_named(),
                    },
                ))
            };
        }
    }

    fn complex_node(
        &mut self,
        node: &Node,
        fields: &Vec<Field>,
        child_nodes: Vec<(Option<&str>, Label, TypeName)>,
        parent_id: Label,
    ) -> Option<Vec<Arg>> {
        let mut map: Map<&Option<String>, (&Field, Vec<Label>)> = std::collections::BTreeMap::new();
        for field in fields {
            map.insert(&field.name, (field, Vec::new()));
        }
        for (child_field, child_id, child_type) in child_nodes {
            if let Some((field, values)) = map.get_mut(&child_field.map(|x| x.to_owned())) {
                //TODO: handle error and missing nodes
                if self.type_matches(&child_type, &field.type_info) {
                    values.push(child_id);
                } else if field.name.is_some() {
                    error!(
                        "{}:{}: type mismatch for field {}::{} with type {:?} != {:?}",
                        &self.path,
                        node.start_position().row + 1,
                        node.kind(),
                        child_field.unwrap_or("child"),
                        child_type,
                        field.type_info
                    )
                }
            } else {
                if child_field.is_some() || child_type.named {
                    error!(
                        "{}:{}: value for unknown field: {}::{} and type {:?}",
                        &self.path,
                        node.start_position().row + 1,
                        node.kind(),
                        &child_field.unwrap_or("child"),
                        &child_type
                    );
                }
            }
        }
        let mut args = Vec::new();
        let mut is_valid = true;
        for field in fields {
            let child_ids = &map.get(&field.name).unwrap().1;
            match &field.storage {
                Storage::Column { name: column_name } => {
                    if child_ids.len() == 1 {
                        args.push(Arg::Label(*child_ids.first().unwrap()));
                    } else {
                        is_valid = false;
                        error!(
                            "{}:{}: {} for field: {}::{}",
                            &self.path,
                            node.start_position().row + 1,
                            if child_ids.is_empty() {
                                "missing value"
                            } else {
                                "too many values"
                            },
                            node.kind(),
                            column_name
                        )
                    }
                }
                Storage::Table {
                    name: table_name,
                    has_index,
                } => {
                    for (index, child_id) in child_ids.iter().enumerate() {
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
                        let mut args = Vec::new();
                        args.push(Arg::Label(parent_id));
                        if *has_index {
                            args.push(Arg::Int(index))
                        }
                        args.push(Arg::Label(*child_id));
                        self.trap_writer.add_tuple(&table_name, args);
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
                match &self.schema.get(single_type).unwrap().kind {
                    EntryKind::Union { members } => {
                        if self.type_matches_set(tp, members) {
                            return true;
                        }
                    }
                    _ => {}
                }
            }
            node_types::FieldTypeInfo::Multiple { types, .. } => {
                return self.type_matches_set(tp, types);
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
fn sliced_source_arg(source: &Vec<u8>, n: Node) -> Arg {
    let range = n.byte_range();
    Arg::String(String::from_utf8_lossy(&source[range.start..range.end]).into_owned())
}

// Emit a pair of `TrapEntry`s for the provided node, appropriately calibrated.
// The first is the location and label definition, and the second is the
// 'Located' entry.
fn location_for<'a>(source: &Vec<u8>, n: Node) -> (usize, usize, usize, usize) {
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
    /// Maps the label to a fresh id, e.g. `#123 = *`.
    FreshId(Label),
    /// Maps the label to a key, e.g. `#7 = @"foo"`.
    MapLabelToKey(Label, String),
    /// foo_bar(arg*)
    GenericTuple(String, Vec<Arg>),
    Comment(String),
}
impl fmt::Display for TrapEntry {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            TrapEntry::FreshId(label) => write!(f, "{} = *", label),
            TrapEntry::MapLabelToKey(label, key) => {
                write!(f, "{} = @\"{}\"", label, key.replace("\"", "\"\""))
            }
            TrapEntry::GenericTuple(name, args) => {
                write!(f, "{}(", name)?;
                for (index, arg) in args.iter().enumerate() {
                    if index > 0 {
                        write!(f, ", ")?;
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
        write!(f, "#{}", self.0)
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
#[derive(Debug)]
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
fn limit_string(string: &String, max_size: usize) -> &str {
    if string.len() <= max_size {
        return string;
    }
    let p = string.as_ptr();
    let mut index = max_size;
    // We want to clip the string at [max_size]; however, the character at that position
    // may span several bytes. We need to find the first byte of the character. In UTF-8
    // encoded data any byte that matches the bit pattern 10XXXXXX is not a start byte.
    // Therefore we decrement the index as long as there are bytes matching this pattern.
    // This ensures we cut the string at the border between one character and another.
    while index > 0 && unsafe { (*p.offset(index as isize) & 0b11000000) == 0b10000000 } {
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
