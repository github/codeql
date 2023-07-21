use std::collections::BTreeSet as Set;
use std::fmt;

use crate::generator::ql;

/// Represents a distinct entry in the database schema.
pub enum Entry<'a> {
    /// An entry defining a database table.
    Table(Table<'a>),
    /// An entry defining a database table.
    Case(Case<'a>),
    /// An entry defining type that is a union of other types.
    Union(Union<'a>),
}

/// A table in the database schema.
pub struct Table<'a> {
    pub name: &'a str,
    pub columns: Vec<Column<'a>>,
    pub keysets: Option<Vec<&'a str>>,
}

/// A union in the database schema.
pub struct Union<'a> {
    pub name: &'a str,
    pub members: Set<&'a str>,
}

/// A table in the database schema.
pub struct Case<'a> {
    pub name: &'a str,
    pub column: &'a str,
    pub branches: Vec<(usize, &'a str)>,
}

/// A column in a table.
pub struct Column<'a> {
    pub db_type: DbColumnType,
    pub name: &'a str,
    pub unique: bool,
    pub ql_type: ql::Type<'a>,
    pub ql_type_is_ref: bool,
}

/// The database column type.
pub enum DbColumnType {
    Int,
    String,
}

impl<'a> fmt::Display for Case<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f, "case @{}.{} of", &self.name, &self.column)?;
        let mut sep = " ";
        for (c, tp) in &self.branches {
            writeln!(f, "{} {} = @{}", sep, c, tp)?;
            sep = "|";
        }
        writeln!(f, ";")
    }
}

impl<'a> fmt::Display for Table<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if let Some(keyset) = &self.keysets {
            write!(f, "#keyset[")?;
            for (key_index, key) in keyset.iter().enumerate() {
                if key_index > 0 {
                    write!(f, ", ")?;
                }
                write!(f, "{}", key)?;
            }
            writeln!(f, "]")?;
        }

        writeln!(f, "{}(", self.name)?;
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
            writeln!(f)?;
        }
        write!(f, ");")?;

        Ok(())
    }
}

impl<'a> fmt::Display for Union<'a> {
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
pub fn write(file: &mut dyn std::io::Write, entries: &[Entry]) -> std::io::Result<()> {
    for entry in entries {
        match entry {
            Entry::Case(case) => write!(file, "{}\n\n", case)?,
            Entry::Table(table) => write!(file, "{}\n\n", table)?,
            Entry::Union(union) => write!(file, "{}\n\n", union)?,
        }
    }

    Ok(())
}
