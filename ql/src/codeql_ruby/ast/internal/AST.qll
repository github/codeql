import codeql.Locations
private import TreeSitter

module AstNode {
  abstract class Range extends @ast_node {
    Generated::AstNode generated;

    Range() { this = generated }

    cached
    string toString() { result = "AstNode" }

    Location getLocation() { result = generated.getLocation() }
  }

  // TODO: Remove, and when removed make Range::toString() above abstract
  private class RemoveWhenFullCoverage extends Range {
    RemoveWhenFullCoverage() { this instanceof Generated::AstNode }
  }
}
