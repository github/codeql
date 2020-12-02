import codeql_ruby.AST
private import codeql.Locations
private import internal.Pattern
private import internal.TreeSitter
private import internal.Variable
private import Variable

/** A pattern. */
class Pattern extends AstNode {
  PatternRange self;

  Pattern() { self = this }

  /** Gets a variable used in (or introduced by) this pattern. */
  Variable getAVariable() { result = self.getAVariable() }
}

/** A simple variable pattern. */
class VariablePattern extends Pattern {
  final override VariablePatternRange self;
  final override Generated::Identifier generated;

  /** Gets the variable used in (or introduced by) this pattern. */
  Variable getVariable() { access(this, result) }

  override string toString() { result = self.getVariableName() }
}

/**
 * A tuple pattern.
 *
 * This includes both tuple patterns in parameters and assignments.
 */
class TuplePattern extends Pattern {
  final override TuplePatternRange self;

  /** Gets the `i`th pattern in this tuple pattern. */
  final Pattern getElement(int i) { result = self.getElement(i) }

  /** Gets a sub pattern in this tuple pattern. */
  final Pattern getAnElement() { result = this.getElement(_) }

  final override string toString() { result = "(..., ...)" }
}
