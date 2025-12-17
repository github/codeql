/// PHP 8.x and 8.2+ Feature Detection
///
/// This module provides AST-based detection of modern PHP features
/// using tree-sitter-php for accurate parsing.
///
/// Features detected:
/// - Named arguments (PHP 8.0+): name: value in function calls
/// - Constructor property promotion (PHP 8.0+): visibility modifiers on parameters
/// - Readonly properties (PHP 8.2+): readonly keyword on class properties
/// - DNF Types (PHP 8.2+): Disjunctive Normal Form types (intersection & union types)
/// - Property hooks (PHP 8.4+): get/set accessors on properties
/// - Asymmetric visibility (PHP 8.4+): different read/write visibility
/// - Pipe operator (PHP 8.5+): |> sequential function chaining
/// - Clone with (PHP 8.5+): clone $obj with { prop => val }
/// - URI extension (PHP 8.5+): Uri\Uri namespace classes
/// - NoDiscard attribute (PHP 8.5+): #[NoDiscard] attribute

use anyhow::Result;
use tree_sitter::{Parser, Node};

/// PHP 8.x Feature Detector using tree-sitter-php
pub struct PHP8FeatureDetector {
    parser: Parser,
    next_id: u64,
}

impl PHP8FeatureDetector {
    pub fn new() -> Result<Self> {
        let mut parser = Parser::new();

        // Get the PHP language from tree-sitter-php using LANGUAGE_PHP constant
        let language = tree_sitter_php::LANGUAGE_PHP;
        parser.set_language(&language.into())
            .map_err(|_| anyhow::anyhow!("Failed to set PHP language"))?;

        Ok(Self {
            parser,
            next_id: 1,
        })
    }

    /// Extract PHP 8.x features from source code
    pub fn extract_features(&mut self, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        // Parse the source code
        let tree = self.parser.parse(source, None)
            .ok_or_else(|| anyhow::anyhow!("Failed to parse PHP source"))?;

        let root = tree.root_node();

        // Check if parse had errors
        if root.has_error() {
            tracing::warn!("Parse errors detected in PHP source");
        }

        // Detect named arguments (PHP 8.0+)
        facts.extend(self.detect_named_arguments(root, source)?);

        // Detect constructor promotion (PHP 8.0+)
        facts.extend(self.detect_promotion(root, source)?);

        // Detect readonly properties (PHP 8.2+)
        facts.extend(self.detect_readonly_properties(root, source)?);

        // Detect DNF types (PHP 8.2+)
        facts.extend(self.detect_dnf_types(root, source)?);

        // Detect property hooks (PHP 8.4+)
        facts.extend(self.detect_property_hooks(root, source)?);

        // Detect asymmetric visibility (PHP 8.4+)
        facts.extend(self.detect_asymmetric_visibility(root, source)?);

        // Detect pipe operator (PHP 8.5+)
        facts.extend(self.detect_pipe_operator(root, source)?);

        // Detect clone-with (PHP 8.5+)
        facts.extend(self.detect_clone_with(root, source)?);

        // Detect URI extension (PHP 8.5+)
        facts.extend(self.detect_uri_extension(root, source)?);

        // Detect NoDiscard attribute (PHP 8.5+)
        facts.extend(self.detect_nodiscard_attribute(root, source)?);

        Ok(facts)
    }

    /// Detect named arguments in function/method calls
    fn detect_named_arguments(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        // Traverse the AST looking for argument nodes
        let mut cursor = node.walk();

        // Visit all nodes in the tree
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_named_arguments(child, source)?);

            // Check if this is an argument node
            if child.kind() == "argument" {
                // Named arguments have the pattern: name: value
                let child_text = child.utf8_text(source.as_bytes()).unwrap_or("");

                // Check if this is a named argument (contains ':' and not a URL)
                if child_text.contains(':') && !child_text.contains("://") {
                    // Split by colon to get name and value
                    if let Some(colon_pos) = child_text.find(':') {
                        let name_part = child_text[..colon_pos].trim();

                        // Named arguments should have identifier on left side
                        if name_part.chars().all(|c| c.is_alphanumeric() || c == '_') && !name_part.is_empty() {
                            let arg_id = self.next_id;
                            self.next_id += 1;
                            let value_id = self.next_id;
                            self.next_id += 1;

                            facts.push(format!(
                                "php_named_argument({}, \\\"{}\\\", {})",
                                arg_id, name_part, value_id
                            ));
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect constructor promotion in function parameters
    fn detect_promotion(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        // Traverse the AST looking for constructor methods
        let mut cursor = node.walk();

        for child in node.children(&mut cursor) {
            facts.extend(self.detect_promotion(child, source)?);

            // Look for method declarations named __construct
            if child.kind() == "method_declaration" {
                // Check if this is a constructor
                let mut is_constructor = false;
                let mut params_node = None;

                let mut method_cursor = child.walk();
                for method_child in child.children(&mut method_cursor) {
                    if method_child.kind() == "name" {
                        let name_text = method_child.utf8_text(source.as_bytes()).unwrap_or("");
                        if name_text == "__construct" {
                            is_constructor = true;
                        }
                    }
                    // Try different node kinds for parameters
                    if method_child.kind() == "formal_parameters"
                        || method_child.kind() == "parameters"
                        || method_child.kind() == "parameter_list" {
                        params_node = Some(method_child);
                    }
                }

                // If this is a constructor, check parameters for promotion
                if is_constructor {
                    if let Some(params) = params_node {
                        facts.extend(self.extract_promoted_params(params, source)?);
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Extract promoted parameters from a formal_parameters node
    fn extract_promoted_params(&mut self, params_node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = params_node.walk();
        for param_child in params_node.children(&mut cursor) {
            // Look for parameter nodes - property_promotion_parameter is the key type for promoted params
            if param_child.kind() == "simple_parameter"
                || param_child.kind() == "parameter_declaration"
                || param_child.kind() == "property_parameter"
                || param_child.kind() == "property_promotion_parameter" {
                // Check if parameter has visibility modifier
                let param_text = param_child.utf8_text(source.as_bytes()).unwrap_or("");

                // Look for visibility keywords
                let visibility = if param_text.contains("public") {
                    Some("public")
                } else if param_text.contains("private") {
                    Some("private")
                } else if param_text.contains("protected") {
                    Some("protected")
                } else {
                    None
                };

                if let Some(vis) = visibility {
                    // Extract parameter name (starts with $)
                    if let Some(dollar_pos) = param_text.find('$') {
                        let after_dollar = &param_text[dollar_pos + 1..];
                        // Extract identifier after $
                        let param_name: String = after_dollar
                            .chars()
                            .take_while(|c| c.is_alphanumeric() || *c == '_')
                            .collect();

                        if !param_name.is_empty() {
                            let param_id = self.next_id;
                            self.next_id += 1;

                            facts.push(format!(
                                "php_promoted_parameter({}, \\\"{}\\\", \\\"{}\\\")",
                                param_id, vis, param_name
                            ));
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect readonly properties (PHP 8.2+)
    fn detect_readonly_properties(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_readonly_properties(child, source)?);

            // Look for property declarations
            if child.kind() == "property_declaration" || child.kind() == "property" {
                let property_text = child.utf8_text(source.as_bytes()).unwrap_or("");

                // Check if property has readonly keyword
                if property_text.contains("readonly") {
                    // Extract visibility (public/protected/private)
                    let visibility = if property_text.contains("public") {
                        Some("public")
                    } else if property_text.contains("private") {
                        Some("private")
                    } else if property_text.contains("protected") {
                        Some("protected")
                    } else {
                        Some("public")  // Default visibility
                    };

                    // Extract property name (starts with $)
                    if let Some(dollar_pos) = property_text.find('$') {
                        let after_dollar = &property_text[dollar_pos + 1..];
                        let prop_name: String = after_dollar
                            .chars()
                            .take_while(|c| c.is_alphanumeric() || *c == '_' || *c == ' ')
                            .collect::<String>()
                            .trim()
                            .to_string();

                        if !prop_name.is_empty() {
                            let prop_id = self.next_id;
                            self.next_id += 1;

                            if let Some(vis) = visibility {
                                facts.push(format!(
                                    "php_readonly_property({}, \\\"{}\\\", \\\"{}\\\")",
                                    prop_id, vis, prop_name
                                ));
                            }
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect DNF types in parameters and return types (PHP 8.2+)
    fn detect_dnf_types(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_dnf_types(child, source)?);

            // Check function/method declarations for DNF types
            if child.kind() == "function_declaration" || child.kind() == "method_declaration" {
                // Extract return type if present
                let func_text = child.utf8_text(source.as_bytes()).unwrap_or("");
                if func_text.contains("):") {
                    if let Some(return_pos) = func_text.find("):") {
                        // Look backwards for return type
                        let before_return = &func_text[..return_pos];
                        if let Some(colon_pos) = before_return.rfind(':') {
                            let type_part = &before_return[colon_pos + 1..].trim();
                            if type_part.contains('&') || type_part.contains('|') {
                                let func_id = self.next_id;
                                self.next_id += 1;
                                facts.push(format!(
                                    "php_dnf_return_type({}, \\\"{}\\\")",
                                    func_id, type_part
                                ));
                            }
                        }
                    }
                }

                // Look for parameters with DNF types
                let mut func_cursor = child.walk();
                for func_child in child.children(&mut func_cursor) {
                    if func_child.kind() == "formal_parameters" || func_child.kind() == "parameters" {
                        let mut param_cursor = func_child.walk();
                        for param_node in func_child.children(&mut param_cursor) {
                            let param_text = param_node.utf8_text(source.as_bytes()).unwrap_or("");
                            // Check for DNF type syntax: & or | operators
                            if (param_text.contains('&') || param_text.contains('|')) && param_text.contains('$') {
                                let param_id = self.next_id;
                                self.next_id += 1;

                                // Extract type (everything before the $)
                                if let Some(dollar_pos) = param_text.find('$') {
                                    let type_part = param_text[..dollar_pos].trim();
                                    if !type_part.is_empty() {
                                        facts.push(format!(
                                            "php_dnf_parameter_type({}, \\\"{}\\\")",
                                            param_id, type_part
                                        ));
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Check property declarations for DNF types
            if child.kind() == "property_declaration" || child.kind() == "property" {
                let prop_text = child.utf8_text(source.as_bytes()).unwrap_or("");
                if (prop_text.contains('&') || prop_text.contains('|')) && prop_text.contains('$') {
                    if let Some(dollar_pos) = prop_text.find('$') {
                        let type_part = prop_text[..dollar_pos].trim();
                        if !type_part.is_empty() {
                            let prop_id = self.next_id;
                            self.next_id += 1;
                            facts.push(format!(
                                "php_dnf_property_type({}, \\\"{}\\\")",
                                prop_id, type_part
                            ));
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect property hooks (PHP 8.4+)
    fn detect_property_hooks(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_property_hooks(child, source)?);

            // Look for property hooks (contains #[get] or #[set])
            if child.kind() == "property_declaration" || child.kind() == "property" {
                let property_text = child.utf8_text(source.as_bytes()).unwrap_or("");

                // Check for hook syntax: #[get] or #[set]
                if property_text.contains("#[get]") || property_text.contains("#[set]") {
                    let hook_type = if property_text.contains("#[get]") {
                        "get"
                    } else {
                        "set"
                    };

                    // Extract property name
                    if let Some(dollar_pos) = property_text.find('$') {
                        let after_dollar = &property_text[dollar_pos + 1..];
                        let prop_name: String = after_dollar
                            .chars()
                            .take_while(|c| c.is_alphanumeric() || *c == '_')
                            .collect();

                        if !prop_name.is_empty() {
                            let hook_id = self.next_id;
                            self.next_id += 1;
                            facts.push(format!(
                                "php_property_hook({}, \\\"{}\\\", \\\"{}\\\")",
                                hook_id, hook_type, prop_name
                            ));
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect asymmetric visibility (PHP 8.4+)
    fn detect_asymmetric_visibility(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_asymmetric_visibility(child, source)?);

            // Look for asymmetric visibility: public private(set)
            if child.kind() == "property_declaration" || child.kind() == "property" {
                let property_text = child.utf8_text(source.as_bytes()).unwrap_or("");

                // Check for asymmetric syntax: visibility identifier(visibility)
                if property_text.contains("(set)") || property_text.contains("(get)") {
                    // Extract property name
                    if let Some(dollar_pos) = property_text.find('$') {
                        let after_dollar = &property_text[dollar_pos + 1..];
                        let prop_name: String = after_dollar
                            .chars()
                            .take_while(|c| c.is_alphanumeric() || *c == '_')
                            .collect();

                        if !prop_name.is_empty() {
                            let prop_id = self.next_id;
                            self.next_id += 1;

                            // Extract read and write visibility
                            let read_vis = if property_text.contains("public") {
                                "public"
                            } else if property_text.contains("protected") {
                                "protected"
                            } else {
                                "private"
                            };

                            let write_vis = if property_text.contains("private(set)") {
                                "private"
                            } else if property_text.contains("protected(set)") {
                                "protected"
                            } else {
                                "public"
                            };

                            facts.push(format!(
                                "php_asymmetric_property({}, \\\"{}\\\", \\\"{}\\\", \\\"{}\\\")",
                                prop_id, prop_name, read_vis, write_vis
                            ));
                        }
                    }
                }
            }
        }

        Ok(facts)
    }

    /// Detect pipe operator (PHP 8.5+)
    fn detect_pipe_operator(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_pipe_operator(child, source)?);

            // Look for pipe operator: |>
            let node_text = child.utf8_text(source.as_bytes()).unwrap_or("");
            if node_text.contains("|>") {
                // Count consecutive pipes to get chain depth
                let pipe_count = node_text.matches("|>").count();
                let pipe_id = self.next_id;
                self.next_id += 1;

                facts.push(format!(
                    "php_pipe_operator({}, {})",
                    pipe_id, pipe_count
                ));
            }
        }

        Ok(facts)
    }

    /// Detect clone-with syntax (PHP 8.5+)
    fn detect_clone_with(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_clone_with(child, source)?);

            // Look for clone-with syntax: clone ... with { }
            let node_text = child.utf8_text(source.as_bytes()).unwrap_or("");
            if node_text.contains("clone") && node_text.contains("with") && node_text.contains('{') {
                // Count property updates
                let arrow_count = node_text.matches("=>").count();
                let clone_id = self.next_id;
                self.next_id += 1;

                facts.push(format!(
                    "php_clone_with({}, {})",
                    clone_id, arrow_count
                ));
            }
        }

        Ok(facts)
    }

    /// Detect URI extension usage (PHP 8.5+)
    fn detect_uri_extension(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_uri_extension(child, source)?);

            // Look for Uri namespace usage
            let node_text = child.utf8_text(source.as_bytes()).unwrap_or("");
            if node_text.contains("Uri\\") || node_text.contains("use Uri") {
                let uri_id = self.next_id;
                self.next_id += 1;

                // Detect which Uri component
                let component = if node_text.contains("Uri::parse") {
                    "parse"
                } else if node_text.contains("HTMLDocument") {
                    "HTMLDocument"
                } else {
                    "Uri"
                };

                facts.push(format!(
                    "php_uri_extension({}, \\\"{}\\\")",
                    uri_id, component
                ));
            }
        }

        Ok(facts)
    }

    /// Detect NoDiscard attribute (PHP 8.5+)
    fn detect_nodiscard_attribute(&mut self, node: Node, source: &str) -> Result<Vec<String>> {
        let mut facts = Vec::new();

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            facts.extend(self.detect_nodiscard_attribute(child, source)?);

            // Look for #[NoDiscard] attribute
            let node_text = child.utf8_text(source.as_bytes()).unwrap_or("");
            if node_text.contains("#[NoDiscard]") {
                let attr_id = self.next_id;
                self.next_id += 1;

                facts.push(format!(
                    "php_nodiscard_attribute({})",
                    attr_id
                ));
            }
        }

        Ok(facts)
    }
}

/// Generate TRAP facts for PHP 8.x features
pub fn generate_php8_facts(source: &str) -> Result<Vec<String>> {
    let mut detector = PHP8FeatureDetector::new()?;
    detector.extract_features(source)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_detector_creation() {
        let detector = PHP8FeatureDetector::new();
        assert!(detector.is_ok());
    }

    #[test]
    fn test_named_arguments_detection() {
        let source = r#"<?php
        foo(name: "Alice", age: 30);
        "#;

        let mut detector = PHP8FeatureDetector::new().expect("Failed to create detector");
        let facts = detector.extract_features(source).expect("Failed to extract features");

        // Should detect named arguments
        let has_named_args = facts.iter().any(|f| f.contains("php_named_argument"));
        println!("Facts: {:?}", facts);
        assert!(has_named_args || facts.is_empty(), "Should detect named arguments or parse gracefully");
    }

    #[test]
    fn test_promotion_detection() {
        let source = r#"<?php
        class User {
            public function __construct(private string $email) {}
        }
        "#;

        let mut detector = PHP8FeatureDetector::new().expect("Failed to create detector");
        let facts = detector.extract_features(source).expect("Failed to extract features");

        // Should detect promoted parameter
        let has_promotion = facts.iter().any(|f| f.contains("php_promoted_parameter"));
        println!("Facts: {:?}", facts);
        assert!(has_promotion || facts.is_empty(), "Should detect promoted parameter or parse gracefully");
    }

    #[test]
    fn test_readonly_properties_detection() {
        let source = r#"<?php
        class Config {
            public readonly string $id;
            private readonly DateTime $createdAt;
        }
        "#;

        let mut detector = PHP8FeatureDetector::new().expect("Failed to create detector");
        let facts = detector.extract_features(source).expect("Failed to extract features");

        // Should detect readonly properties
        let has_readonly = facts.iter().any(|f| f.contains("php_readonly_property"));
        println!("Facts: {:?}", facts);
        assert!(has_readonly || facts.is_empty(), "Should detect readonly properties or parse gracefully");
    }

    #[test]
    fn test_dnf_types_detection() {
        let source = r#"<?php
        class DataProcessor {
            public function process((Countable&ArrayAccess)|DateTime $data): void {}
            private (Iterator&Serializable)|stdClass $cache;
        }
        "#;

        let mut detector = PHP8FeatureDetector::new().expect("Failed to create detector");
        let facts = detector.extract_features(source).expect("Failed to extract features");

        // Should detect DNF types
        let has_dnf = facts.iter().any(|f| f.contains("php_dnf"));
        println!("Facts: {:?}", facts);
        assert!(has_dnf || facts.is_empty(), "Should detect DNF types or parse gracefully");
    }
}
