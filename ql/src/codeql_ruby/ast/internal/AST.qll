import codeql.Locations
private import TreeSitter

module AstNode {
  abstract class Range extends @ast_node {
    Generated::AstNode generated;

    Range() { this = generated }

    cached
    abstract string toString();

    Location getLocation() { result = generated.getLocation() }
  }

  // TODO: Remove
  private class RemoveWhenFullCoverage extends Range {
    // Lists the entities that are currently used in tests but do not yet
    // have an external ASTNode. Perhaps not all entities below need to be
    // an AST node, for example we include the `in` keyword in `for` loops
    // in the CFG, but not the AST
    RemoveWhenFullCoverage() {
      this = any(Generated::Method m).getName()
      or
      this = any(Generated::SingletonMethod m).getName()
      or
      this = any(Generated::Call c).getMethod() and
      not this instanceof Generated::ScopeResolution
      or
      this instanceof Generated::RestAssignment
      or
      this instanceof Generated::SymbolArray
      or
      this instanceof Generated::Interpolation
      or
      this instanceof Generated::StringArray
      or
      this instanceof Generated::BareString
      or
      this instanceof Generated::Float
      or
      this instanceof Generated::Superclass
      or
      this instanceof Generated::Hash
      or
      this instanceof Generated::Array
      or
      this instanceof Generated::Complex
      or
      this instanceof Generated::Character
      or
      this instanceof Generated::HeredocBody
      or
      this instanceof Generated::HeredocBeginning
      or
      this instanceof Generated::HeredocEnd
      or
      this instanceof Generated::Range
      or
      this instanceof Generated::Rational
      or
      this instanceof Generated::Subshell
    }

    override string toString() { result = "AstNode" }
  }
}
