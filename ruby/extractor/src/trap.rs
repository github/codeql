use std::borrow::Cow;
use std::fmt;
use std::io::BufWriter;
use std::path::Path;

use flate2::write::GzEncoder;
use indexmap::IndexMap;

pub struct Writer {
    /// Labels that should be assigned fresh ids, e.g. `#123=*`.
    fresh_ids: Vec<Label>,

    /// Labels that should be assigned trap keys, e.g. `#7=@"foo"`.
    global_keys: IndexMap<String, Label>,

    /// Database rows to emit. Each key is the tuple name, each value is a list.
    /// Each member of *that* list represents an instance of that tuple,
    /// containing a list of the arguments/column values.
    tuples: IndexMap<String, Vec<Vec<Arg>>>,

    /// A counter for generating fresh labels
    counter: u32,
}

impl Writer {
    pub fn new() -> Writer {
        Writer {
            fresh_ids: Vec::new(),
            tuples: IndexMap::new(),
            global_keys: IndexMap::new(),
            counter: 0,
        }
    }

    ///  Gets a label that will hold the unique ID of the passed string at import time.
    ///  This can be used for incrementally importable TRAP files -- use globally unique
    ///  strings to compute a unique ID for table tuples.
    ///
    ///  Note: You probably want to make sure that the key strings that you use are disjoint
    ///  for disjoint column types; the standard way of doing this is to prefix (or append)
    ///  the column type name to the ID. Thus, you might identify methods in Java by the
    ///  full ID "methods_com.method.package.DeclaringClass.method(argumentList)".
    pub fn fresh_id(&mut self) -> Label {
        let label = Label(self.counter);
        self.counter += 1;
        self.fresh_ids.push(label);
        label
    }

    pub fn global_id(&mut self, key: String) -> (Label, bool) {
        if let Some(label) = self.global_keys.get(&key) {
            return (*label, false);
        }
        let label = Label(self.counter);
        self.counter += 1;
        self.global_keys.insert(key, label);
        (label, true)
    }

    pub fn add_tuple(&mut self, table_name: &str, args: Vec<Arg>) {
        self.tuples
            .entry(table_name.to_owned())
            .or_insert_with(Vec::new)
            .push(args);
    }

    fn write<T: std::io::Write>(&self, dest: &mut T) -> std::io::Result<()> {
        for label in &self.fresh_ids {
            writeln!(dest, "{}=*", label)?;
        }
        for (key, label) in &self.global_keys {
            writeln!(dest, "{}=@\"{}\"", label, key.replace("\"", "\"\""))?;
        }
        for (name, instances) in &self.tuples {
            for instance in instances {
                write!(dest, "{}(", name)?;
                for (index, arg) in instance.iter().enumerate() {
                    if index > 0 {
                        write!(dest, ",")?;
                    }
                    write!(dest, "{}", arg)?;
                }
                writeln!(dest, ")")?;
            }
        }
        Ok(())
    }

    pub fn write_to_file(&self, path: &Path, compression: &Compression) -> std::io::Result<()> {
        let trap_file = std::fs::File::create(path)?;
        let mut trap_file = BufWriter::new(trap_file);
        match compression {
            Compression::None => self.write(&mut trap_file),
            Compression::Gzip => {
                let mut compressed_writer = GzEncoder::new(trap_file, flate2::Compression::fast());
                self.write(&mut compressed_writer)
            }
        }
    }
}

#[derive(Debug, Copy, Clone)]
// Identifiers of the form #0, #1...
pub struct Label(u32);

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
                limit_string(x, MAX_STRLEN).replace("\"", "\"\"")
            ),
        }
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

pub enum Compression {
    None,
    Gzip,
}

impl Compression {
    pub fn from_env(var_name: &str) -> Compression {
        match std::env::var(var_name) {
            Ok(method) => match Compression::from_string(&method) {
                Some(c) => c,
                None => {
                    tracing::error!("Unknown compression method '{}'; using gzip.", &method);
                    Compression::Gzip
                }
            },
            // Default compression method if the env var isn't set:
            Err(_) => Compression::Gzip,
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
