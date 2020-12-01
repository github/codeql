import codeql_ruby.AST
private import codeql_ruby.Generated
private import codeql.Locations
private import internal.Pattern
private import internal.Variable
private import Variable

/** A pattern. */
class Pattern extends AstNode {
  Pattern() { this instanceof PatternRange }
}

/** A simple variable pattern. */
class VariablePattern extends Pattern {
  final override Generated::Identifier generated;

  /** Gets the name of the variable used in this pattern. */
  final string getVariableName() { result = generated.getValue() }

  /** Gets the variable used in (or introduced by) this pattern. */
  Variable getVariable() { access(this, result) }

  override string toString() { result = this.getVariableName() }
}

/**
 * A tuple pattern.
 *
 * This includes both tuple patterns in parameters and assignments.
 */
class TuplePattern extends Pattern {
  TuplePattern() { this instanceof TuplePatternRange }

  /** Gets the `i`th pattern in this tuple pattern. */
  final Pattern getElement(int i) { result = this.(TuplePatternRange).getElement(i) }

  /** Gets a sub pattern in this tuple pattern. */
  final Pattern getAnElement() { result = this.getElement(_) }

  final override string toString() { result = "(..., ...)" }
}
