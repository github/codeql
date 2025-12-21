/// DBScheme Parser
///
/// This module parses CodeQL dbscheme files to extract:
/// - Relation/predicate names
/// - Column definitions
/// - Type information

use anyhow::Result;
use std::collections::HashMap;

/// A column definition within a predicate
#[derive(Debug, Clone)]
pub struct Column {
    /// Column name
    pub name: String,
    /// Column type (e.g., "int", "varchar(255)", "@file ref")
    pub column_type: String,
}

/// A predicate definition (table)
#[derive(Debug, Clone)]
pub struct Predicate {
    /// Predicate/table name
    pub name: String,
    /// List of columns in this predicate
    pub columns: Vec<Column>,
}

/// Parse a complete dbscheme file
///
/// Expected format:
/// ```
/// predicate_name(
///   column1: type1,
///   column2: type2);
/// ```
pub fn parse_dbscheme(content: &str) -> Result<HashMap<String, Predicate>> {
    let mut predicates = HashMap::new();

    for line in content.lines() {
        let line = line.trim();

        // Skip empty lines and comments
        if line.is_empty() || line.starts_with("//") {
            continue;
        }

        // Try to parse this line as a predicate definition
        if let Some(predicate) = parse_predicate_line(line) {
            predicates.insert(predicate.name.clone(), predicate);
        }
    }

    if predicates.is_empty() {
        return Err(anyhow::anyhow!(
            "No predicates found in dbscheme. File may be malformed."
        ));
    }

    Ok(predicates)
}

/// Parse a single line that might be a predicate definition
fn parse_predicate_line(line: &str) -> Option<Predicate> {
    // Look for pattern: name(columns...)
    let paren_idx = line.find('(')?;
    let name = line[..paren_idx].trim().to_string();

    // Predicate names should be valid identifiers
    if !is_valid_identifier(&name) {
        return None;
    }

    // Find the closing parenthesis
    let close_paren = line.rfind(')')?;
    let columns_str = &line[paren_idx + 1..close_paren];

    // Parse comma-separated columns
    let columns: Vec<Column> = columns_str
        .split(',')
        .filter_map(|col_def| parse_column_def(col_def.trim()))
        .collect();

    // We need at least one column for a valid predicate
    if columns.is_empty() {
        return None;
    }

    Some(Predicate { name, columns })
}

/// Parse a column definition
/// Format examples:
/// - `unique int id : @file`
/// - `varchar(900) name : string ref`
/// - `int file : @file ref`
fn parse_column_def(col_def: &str) -> Option<Column> {
    // Column definition should contain a colon
    let parts: Vec<&str> = col_def.split(':').collect();
    if parts.len() < 2 {
        return None;
    }

    // Extract the column name (the last word before the colon)
    let name_part = parts[0].trim();
    let words: Vec<&str> = name_part.split_whitespace().collect();

    // The column name is the last word in the left side
    let name = words.last()?.to_string();

    // The type is everything after the colon
    let column_type = parts[1..].join(":").trim().to_string();

    Some(Column { name, column_type })
}

/// Check if a string is a valid identifier
fn is_valid_identifier(s: &str) -> bool {
    if s.is_empty() {
        return false;
    }

    // First character must be letter or underscore
    let first_char = s.chars().next().unwrap();
    if !first_char.is_alphabetic() && first_char != '_' {
        return false;
    }

    // Remaining characters must be alphanumeric or underscore
    s.chars()
        .all(|c| c.is_alphanumeric() || c == '_')
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_simple_predicate() {
        let line = "files(unique int id : @file, varchar(900) name : string ref);";
        let pred = parse_predicate_line(line).expect("Failed to parse");

        assert_eq!(pred.name, "files");
        assert_eq!(pred.columns.len(), 2);
        assert_eq!(pred.columns[0].name, "id");
        assert_eq!(pred.columns[1].name, "name");
    }

    #[test]
    fn test_parse_column_def() {
        let col = parse_column_def("unique int id : @file").expect("Failed to parse");

        assert_eq!(col.name, "id");
        assert_eq!(col.column_type, "@file");
    }

    #[test]
    fn test_valid_identifier() {
        assert!(is_valid_identifier("files"));
        assert!(is_valid_identifier("php_ast_node"));
        assert!(is_valid_identifier("_private"));
        assert!(!is_valid_identifier("123invalid"));
        assert!(!is_valid_identifier(""));
    }

    #[test]
    fn test_parse_dbscheme() {
        let content = r#"
// Comment
files(unique int id : @file, varchar(900) name : string ref);

php_ast_node(
  unique int id : @php_ast_node,
  varchar(255) node_type : string ref);
"#;

        let predicates = parse_dbscheme(content).expect("Failed to parse");

        assert_eq!(predicates.len(), 2);
        assert!(predicates.contains_key("files"));
        assert!(predicates.contains_key("php_ast_node"));
    }
}
