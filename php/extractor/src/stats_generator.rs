/// CodeQL PHP Stats File Generator
///
/// This module generates `.dbscheme.stats` files that provide CodeQL with
/// query optimization metadata. Supports both basic (heuristic-based) and
/// advanced (source-analysis-based) modes.

use anyhow::{Result, Context};
use std::collections::HashMap;
use std::path::Path;
use std::fs;
use walkdir::WalkDir;
use crate::dbscheme_parser::{self, Predicate, Column};

/// Statistics generation mode
#[derive(Debug, Clone, Copy)]
pub enum StatsMode {
    /// Basic: minimal XML with just cardinalities (heuristic-based)
    Basic,
    /// Advanced: includes columnsizes and selectivity estimates
    Advanced,
}

/// Generates CodeQL statistics files for PHP
pub struct StatsGenerator {
    dbscheme_path: std::path::PathBuf,
    mode: StatsMode,
    extraction_stats: HashMap<String, u64>,
    dbscheme_predicates: HashMap<String, Predicate>,
}

impl StatsGenerator {
    /// Create a new stats generator
    pub fn new(dbscheme_path: std::path::PathBuf, mode: StatsMode) -> Self {
        Self {
            dbscheme_path,
            mode,
            extraction_stats: HashMap::new(),
            dbscheme_predicates: HashMap::new(),
        }
    }

    /// Parse the dbscheme file to extract relation definitions
    pub fn parse_dbscheme(&mut self) -> Result<()> {
        tracing::info!("Parsing dbscheme: {}", self.dbscheme_path.display());

        let content = fs::read_to_string(&self.dbscheme_path)
            .context("Failed to read dbscheme file")?;

        self.dbscheme_predicates = dbscheme_parser::parse_dbscheme(&content)?;

        tracing::debug!("Found {} predicates in dbscheme", self.dbscheme_predicates.len());

        Ok(())
    }

    /// Estimate cardinalities using heuristics
    /// Works without requiring source code analysis
    pub fn estimate_cardinalities(&mut self) -> Result<()> {
        tracing::info!("Using heuristic cardinality estimates");

        // Conservative estimates based on typical PHP codebases
        self.extraction_stats.insert("files".to_string(), 100);
        self.extraction_stats.insert("php_ast_node".to_string(), 100000);
        self.extraction_stats.insert("php_parent".to_string(), 95000);
        self.extraction_stats.insert("locations".to_string(), 500000);

        // Add basic estimates for any additional predicates
        for (pred_name, _) in &self.dbscheme_predicates {
            if !self.extraction_stats.contains_key(pred_name) {
                self.extraction_stats.insert(pred_name.clone(), 1000);
            }
        }

        tracing::debug!("Estimated cardinalities: {:?}", self.extraction_stats);

        Ok(())
    }

    /// Load actual source analysis data for accurate cardinalities
    /// Analyzes the PHP source tree to compute actual counts
    pub fn load_source_analysis(&mut self, source_root: &Path) -> Result<()> {
        tracing::info!("Analyzing source code at: {}", source_root.display());

        let mut file_count = 0;
        let mut line_count = 0;

        // Walk the source directory and count PHP files and lines
        for entry in WalkDir::new(source_root)
            .into_iter()
            .filter_map(Result::ok)
            .filter(|e| {
                e.path()
                    .extension()
                    .map_or(false, |ext| ext == "php" || ext == "php5" || ext == "php7")
            })
        {
            file_count += 1;

            // Count lines in file
            if let Ok(content) = fs::read_to_string(entry.path()) {
                let lines = content.lines().count();
                line_count += lines;
                tracing::trace!("File {}: {} lines", entry.path().display(), lines);
            }
        }

        tracing::info!("Analyzed: {} files, {} total lines", file_count, line_count);

        // Update stats with actual data
        self.extraction_stats.insert("files".to_string(), file_count as u64);
        self.extraction_stats.insert("locations".to_string(), (line_count as u64) * 2);

        // AST nodes: heuristic based on complexity (~4 nodes per line on average)
        let ast_nodes = (line_count as u64) * 4;
        self.extraction_stats.insert("php_ast_node".to_string(), ast_nodes);

        // Parent relationships: ~95% of AST nodes have parents
        let parents = (ast_nodes as f64 * 0.95) as u64;
        self.extraction_stats.insert("php_parent".to_string(), parents);

        tracing::debug!("Updated cardinalities from source: {:?}", self.extraction_stats);

        Ok(())
    }

    /// Generate the stats XML file
    pub fn generate_stats_file(&self, output_path: &Path) -> Result<()> {
        tracing::info!(
            "Generating stats file in {:?} mode: {}",
            self.mode,
            output_path.display()
        );

        let mut xml = String::from("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        xml.push_str("<dbstats>\n");

        // Always generate typesizes section (minimal)
        xml.push_str("  <typesizes>\n");
        xml.push_str("    <e><k>@file</k><v>100</v></e>\n");
        xml.push_str("    <e><k>@php_ast_node</k><v>100</v></e>\n");
        xml.push_str("    <e><k>@location</k><v>100</v></e>\n");
        xml.push_str("  </typesizes>\n");

        // Generate stats for each relation
        xml.push_str("  <stats>\n");

        for (rel_name, predicate) in &self.dbscheme_predicates {
            xml.push_str(&self.generate_relation_stats_xml(rel_name, predicate));
        }

        xml.push_str("  </stats>\n");
        xml.push_str("</dbstats>\n");

        // Write the stats file
        fs::write(output_path, &xml).context("Failed to write stats file")?;

        let file_size = xml.len();
        tracing::info!(
            "Generated stats file ({} bytes) in {:?} mode",
            file_size,
            self.mode
        );

        Ok(())
    }

    /// Generate XML for a single relation
    fn generate_relation_stats_xml(&self, rel_name: &str, predicate: &Predicate) -> String {
        let cardinality = self
            .extraction_stats
            .get(rel_name)
            .cloned()
            .unwrap_or(1000);

        let mut xml = format!(
            "    <relation>\n      <name>{}</name>\n      <cardinality>{}</cardinality>\n",
            rel_name, cardinality
        );

        // In ADVANCED mode, include columnsizes and selectivity estimates
        if matches!(self.mode, StatsMode::Advanced) {
            xml.push_str("      <columnsizes>\n");

            for column in &predicate.columns {
                let selectivity = self.estimate_selectivity(rel_name, column);
                xml.push_str(&format!(
                    "        <e><k>{}</k><v>{}</v></e>\n",
                    column.name, selectivity
                ));
            }

            xml.push_str("      </columnsizes>\n");
            xml.push_str("      <dependencies/>\n");
        }

        xml.push_str("    </relation>\n");
        xml
    }

    /// Estimate column selectivity (uniqueness)
    /// Returns value 0.1 (10% unique) to 1.0 (all unique)
    fn estimate_selectivity(&self, relation: &str, column: &Column) -> f64 {
        match (relation, column.name.as_str()) {
            // ID columns are always unique
            (_, "id") | (_, "_id") => 1.0,

            // File references: moderate selectivity
            ("php_ast_node", "file") => 0.5,
            ("locations", "file") => 0.4,

            // Type/kind columns have low selectivity (many duplicates)
            (_, "type") | (_, "name") | (_, "node_type") => 0.1,
            (_, "kind") => 0.15,

            // Parent/relationship IDs: high selectivity
            ("php_parent", "parent") => 0.8,

            // Default: assume low selectivity
            _ => 0.2,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_estimate_selectivity() {
        let gen = StatsGenerator::new(std::path::PathBuf::from("test.dbscheme"), StatsMode::Basic);

        let id_col = Column {
            name: "id".to_string(),
            column_type: "int".to_string(),
        };

        let type_col = Column {
            name: "node_type".to_string(),
            column_type: "varchar".to_string(),
        };

        assert_eq!(gen.estimate_selectivity("files", &id_col), 1.0);
        assert_eq!(gen.estimate_selectivity("php_ast_node", &type_col), 0.1);
    }

    #[test]
    fn test_stats_generator_creation() {
        let gen = StatsGenerator::new(
            std::path::PathBuf::from("php.dbscheme"),
            StatsMode::Advanced,
        );

        assert_eq!(gen.extraction_stats.len(), 0);
        assert_eq!(gen.dbscheme_predicates.len(), 0);
    }
}
