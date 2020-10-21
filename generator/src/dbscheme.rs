use std::fmt;

/// Represents a distinct entry in the database schema.
pub enum Entry {
    /// An entry defining a database table.
    Table(Table),

    /// An entry defining type that is a union of other types.
    Union(Union),
}

/// A table in the database schema.
pub struct Table {
    pub name: String,
    pub columns: Vec<Column>,
    pub keysets: Option<Vec<String>>,
}

/// A union in the database schema.
pub struct Union {
    pub name: String,
    pub members: Vec<String>,
}

/// A column in a table.
pub struct Column {
    pub db_type: DbColumnType,
    pub name: String,
    pub unique: bool,
    pub ql_type: QlColumnType,
    pub ql_type_is_ref: bool,
}

/// The database column type.
pub enum DbColumnType {
    Int,
    String,
}

// The QL type of a column.
pub enum QlColumnType {
    /// Primitive `int` type.
    Int,

    /// Primitive `string` type.
    String,

    /// A custom type, defined elsewhere by a table or union.
    Custom(String),
}

const RESERVED_KEYWORDS: [&'static str; 14] = [
    "boolean", "case", "date", "float", "int", "key", "of", "order", "ref", "string", "subtype",
    "type", "unique", "varchar",
];

/// Returns a string that's a copy of `name` but suitably escaped to be a valid
/// QL identifier.
pub fn escape_name(name: &str) -> String {
    let mut result = String::new();

    // If there's a leading underscore, replace it with 'underscore_'.
    if let Some(c) = name.chars().next() {
        if c == '_' {
            result.push_str("underscore");
        }
    }
    for c in name.chars() {
        match c {
            '{' => result.push_str("lbrace"),
            '}' => result.push_str("rbrace"),
            '<' => result.push_str("langle"),
            '>' => result.push_str("rangle"),
            '[' => result.push_str("lbracket"),
            ']' => result.push_str("rbracket"),
            '(' => result.push_str("lparen"),
            ')' => result.push_str("rparen"),
            '|' => result.push_str("pipe"),
            '=' => result.push_str("equal"),
            '~' => result.push_str("tilde"),
            '?' => result.push_str("question"),
            '`' => result.push_str("backtick"),
            '^' => result.push_str("caret"),
            '!' => result.push_str("bang"),
            '#' => result.push_str("hash"),
            '%' => result.push_str("percent"),
            '&' => result.push_str("ampersand"),
            '.' => result.push_str("dot"),
            ',' => result.push_str("comma"),
            '/' => result.push_str("slash"),
            ':' => result.push_str("colon"),
            ';' => result.push_str("semicolon"),
            '"' => result.push_str("dquote"),
            '*' => result.push_str("star"),
            '+' => result.push_str("plus"),
            '-' => result.push_str("minus"),
            '@' => result.push_str("at"),
            _ => result.push_str(&c.to_lowercase().to_string()),
        }
    }

    for &keyword in &RESERVED_KEYWORDS {
        if result == keyword {
            result.push_str("__");
            break;
        }
    }

    result
}

impl fmt::Display for Table {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if let Some(keyset) = &self.keysets {
            write!(f, "#keyset[")?;
            for (key_index, key) in keyset.iter().enumerate() {
                if key_index > 0 {
                    write!(f, ", ")?;
                }
                write!(f, "{}", key)?;
            }
            write!(f, "]\n")?;
        }

        write!(f, "{}(\n", self.name)?;
        for (column_index, column) in self.columns.iter().enumerate() {
            write!(f, "  ")?;
            if column.unique {
                write!(f, "unique ")?;
            }
            write!(
                f,
                "{} ",
                match column.db_type {
                    DbColumnType::Int => "int",
                    DbColumnType::String => "string",
                }
            )?;
            write!(f, "{}: ", column.name)?;
            match &column.ql_type {
                QlColumnType::Int => write!(f, "int")?,
                QlColumnType::String => write!(f, "string")?,
                QlColumnType::Custom(name) => write!(f, "@{}", name)?,
            }
            if column.ql_type_is_ref {
                write!(f, " ref")?;
            }
            if column_index + 1 != self.columns.len() {
                write!(f, ",")?;
            }
            write!(f, "\n")?;
        }
        write!(f, ");")?;

        Ok(())
    }
}

impl fmt::Display for Union {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "@{} = ", self.name)?;
        let mut first = true;
        for member in &self.members {
            if first {
                first = false;
            } else {
                write!(f, " | ")?;
            }
            write!(f, "@{}", member)?;
        }
        Ok(())
    }
}

/// Generates the dbscheme by writing the given dbscheme `entries` to the `file`.
pub fn write(
    language_name: &str,
    file: &mut dyn std::io::Write,
    entries: &[Entry],
) -> std::io::Result<()> {
    write!(file, "// CodeQL database schema for {}\n", language_name)?;
    write!(
        file,
        "// Automatically generated from the tree-sitter grammar; do not edit\n\n"
    )?;

    for entry in entries {
        match entry {
            Entry::Table(table) => write!(file, "{}\n\n", table)?,
            Entry::Union(union) => write!(file, "{}\n\n", union)?,
        }
    }

    Ok(())
}
