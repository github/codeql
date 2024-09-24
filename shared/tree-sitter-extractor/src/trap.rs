use std::borrow::Cow;
use std::fmt;
use std::io::{BufWriter, Write};
use std::path::Path;

use flate2::write::GzEncoder;

#[derive(Clone, Copy, Eq, PartialEq, PartialOrd, Ord, Hash)]
pub struct Location {
    pub file_label: Label,
    pub start_line: usize,
    pub start_column: usize,
    pub end_line: usize,
    pub end_column: usize,
}

pub struct Writer {
    /// The accumulated trap entries
    trap_output: Vec<Entry>,
    /// A counter for generating fresh labels
    counter: u32,
    /// cache of global keys
    global_keys: std::collections::HashMap<String, Label>,
    /// Labels for locations, which don't use global keys
    location_labels: std::collections::HashMap<Location, Label>,
}

impl Writer {
    pub fn new() -> Writer {
        Writer {
            counter: 0,
            trap_output: Vec::new(),
            global_keys: std::collections::HashMap::new(),
            location_labels: std::collections::HashMap::new(),
        }
    }

    pub fn fresh_id(&mut self) -> Label {
        let label = Label(self.counter);
        self.counter += 1;
        self.trap_output.push(Entry::FreshId(label));
        label
    }

    ///  Gets a label that will hold the unique ID of the passed string at import time.
    ///  This can be used for incrementally importable TRAP files -- use globally unique
    ///  strings to compute a unique ID for table tuples.
    ///
    ///  Note: You probably want to make sure that the key strings that you use are disjoint
    ///  for disjoint column types; the standard way of doing this is to prefix (or append)
    ///  the column type name to the ID. Thus, you might identify methods in Java by the
    ///  full ID "methods_com.method.package.DeclaringClass.method(argumentList)".
    pub fn global_id(&mut self, key: &str) -> (Label, bool) {
        if let Some(label) = self.global_keys.get(key) {
            return (*label, false);
        }
        let label = Label(self.counter);
        self.counter += 1;
        self.global_keys.insert(key.to_owned(), label);
        self.trap_output
            .push(Entry::MapLabelToKey(label, key.to_owned()));
        (label, true)
    }

    /// Gets the label for the given location. The first call for a given location will define it as
    /// a fresh (star) ID.
    pub fn location_label(&mut self, loc: Location) -> (Label, bool) {
        if let Some(label) = self.location_labels.get(&loc) {
            return (*label, false);
        }
        let label = self.fresh_id();
        self.location_labels.insert(loc, label);
        (label, true)
    }

    pub fn add_tuple(&mut self, table_name: &str, args: Vec<Arg>) {
        self.trap_output
            .push(Entry::GenericTuple(table_name.to_owned(), args))
    }

    pub fn comment(&mut self, text: String) {
        self.trap_output.push(Entry::Comment(text));
    }

    pub fn write_to_file(&self, path: &Path, compression: Compression) -> std::io::Result<()> {
        let trap_file = std::fs::File::create(path)?;
        match compression {
            Compression::None => {
                let mut trap_file = BufWriter::new(trap_file);
                self.write_trap_entries(&mut trap_file)
            }
            Compression::Gzip => {
                let trap_file = GzEncoder::new(trap_file, flate2::Compression::fast());
                let mut trap_file = BufWriter::new(trap_file);
                self.write_trap_entries(&mut trap_file)
            }
        }
    }

    fn write_trap_entries<W: Write>(&self, file: &mut W) -> std::io::Result<()> {
        for trap_entry in &self.trap_output {
            writeln!(file, "{}", trap_entry)?;
        }
        std::io::Result::Ok(())
    }
}

pub enum Entry {
    /// Maps the label to a fresh id, e.g. `#123=*`.
    FreshId(Label),
    /// Maps the label to a key, e.g. `#7=@"foo"`.
    MapLabelToKey(Label, String),
    /// foo_bar(arg*)
    GenericTuple(String, Vec<Arg>),
    Comment(String),
}

impl fmt::Display for Entry {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Entry::FreshId(label) => write!(f, "{}=*", label),
            Entry::MapLabelToKey(label, key) => {
                write!(f, "{}=@\"{}\"", label, key.replace('"', "\"\""))
            }
            Entry::GenericTuple(name, args) => {
                write!(f, "{}(", name)?;
                for (index, arg) in args.iter().enumerate() {
                    if index > 0 {
                        write!(f, ",")?;
                    }
                    write!(f, "{}", arg)?;
                }
                write!(f, ")")
            }
            Entry::Comment(line) => write!(f, "// {}", line),
        }
    }
}

#[derive(Copy, Clone, Hash, Eq, PartialEq, Ord, PartialOrd)]
// Identifiers of the form #0, #1...
pub struct Label(u32);

impl fmt::Debug for Label {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Label({:#x})", self.0)
    }
}

impl fmt::Display for Label {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

// Some untyped argument to a TrapEntry.
#[derive(Debug, Clone)]
pub enum Arg {
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
                limit_string(x, MAX_STRLEN).replace('"', "\"\"")
            ),
        }
    }
}

impl From<String> for Arg {
    fn from(value: String) -> Self {
        Arg::String(value)
    }
}

impl From<&str> for Arg {
    fn from(value: &str) -> Self {
        Arg::String(value.into())
    }
}

impl From<Label> for Arg {
    fn from(value: Label) -> Self {
        Arg::Label(value)
    }
}

impl From<usize> for Arg {
    fn from(value: usize) -> Self {
        Arg::Int(value)
    }
}

pub struct Program(Vec<Entry>);

impl fmt::Display for Program {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let mut text = String::new();
        for trap_entry in &self.0 {
            text.push_str(&format!("{}\n", trap_entry));
        }
        write!(f, "{}", text)
    }
}

pub fn full_id_for_file(normalized_path: &str) -> String {
    format!("{};sourcefile", escape_key(normalized_path))
}

pub fn full_id_for_folder(normalized_path: &str) -> String {
    format!("{};folder", escape_key(normalized_path))
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

#[derive(Clone, Copy)]
pub enum Compression {
    None,
    Gzip,
}

impl Compression {
    pub fn from_env(var_name: &str) -> Result<Compression, String> {
        match std::env::var(var_name) {
            Ok(method) => match Compression::from_string(&method) {
                Some(c) => Ok(c),
                None => Err(format!("Unknown compression method '{}'", &method)),
            },
            // Default compression method if the env var isn't set:
            Err(_) => Ok(Compression::Gzip),
        }
    }

    pub fn from_string(s: &str) -> Option<Compression> {
        match s.to_lowercase().as_ref() {
            "none" => Some(Compression::None),
            "gzip" => Some(Compression::Gzip),
            _ => None,
        }
    }

    pub fn extension(&self) -> &str {
        match self {
            Compression::None => "trap",
            Compression::Gzip => "trap.gz",
        }
    }
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
