import codeql.Locations
private import TreeSitter

module AstNode {
  abstract class Range extends @ast_node {
    Generated::AstNode generated;

    Range() { this = generated }

    cached
    abstract string toString();

    Location getLocation() { result = generated.getLocation() }

    predicate child(string label, AstNode::Range child) { none() }
  }
}
