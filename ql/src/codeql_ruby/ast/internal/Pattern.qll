private import codeql_ruby.AST
private import TreeSitter
private import codeql_ruby.ast.internal.Variable
private import codeql.Locations

/**
 * Holds if `n` is in the left-hand-side of an explicit assignment `assignment`.
 */
predicate explicitAssignmentNode(Generated::AstNode n, Generated::AstNode assignment) {
  n = assignment.(Generated::Assignment).getLeft()
  or
  n = assignment.(Generated::OperatorAssignment).getLeft()
  or
  exists(Generated::AstNode parent |
    parent = n.getParent() and
    explicitAssignmentNode(parent, assignment)
  |
    parent instanceof Generated::DestructuredLeftAssignment
    or
    parent instanceof Generated::LeftAssignmentList
  )
}

/** Holds if `n` is inside an implicit assignment. */
predicate implicitAssignmentNode(Generated::AstNode n) {
  n = any(Generated::ExceptionVariable ev).getChild()
  or
  n = any(Generated::For for).getPattern()
  or
  implicitAssignmentNode(n.getParent())
}

/** Holds if `n` is inside a parameter. */
predicate implicitParameterAssignmentNode(Generated::AstNode n, Callable c) {
  n = c.getAParameter()
  or
  implicitParameterAssignmentNode(n.getParent().(Generated::DestructuredParameter), c)
}

module Pattern {
  abstract class Range extends AstNode {
    Range() {
      explicitAssignmentNode(this, _)
      or
      implicitAssignmentNode(this)
      or
      implicitParameterAssignmentNode(this, _)
    }

    abstract Variable getAVariable();
  }
}

module VariablePattern {
  class Range extends Pattern::Range {
    override Generated::Identifier generated;

    string getVariableName() { result = generated.getValue() }

    override Variable getAVariable() { access(this, result) }
  }
}

module TuplePattern {
  abstract class Range extends Pattern::Range {
    abstract Pattern::Range getElement(int i);

    override Variable getAVariable() { result = this.getElement(_).getAVariable() }
  }

  private class ParameterTuplePatternRange extends Range {
    override Generated::DestructuredParameter generated;

    override Pattern::Range getElement(int i) { result = generated.getChild(i) }
  }

  private class AssignmentTuplePatternRange extends Range {
    override Generated::DestructuredLeftAssignment generated;

    override Pattern::Range getElement(int i) { result = generated.getChild(i) }
  }

  private class AssignmentListPatternRange extends Range {
    override Generated::LeftAssignmentList generated;

    override Pattern::Range getElement(int i) { result = generated.getChild(i) }
  }
}
