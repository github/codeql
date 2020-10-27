use crate::ql;
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
    pub ql_type: ql::Type,
    pub ql_type_is_ref: bool,
}

/// The database column type.
pub enum DbColumnType {
    Int,
    String,
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
            write!(f, "{}: {}", column.name, column.ql_type)?;
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
