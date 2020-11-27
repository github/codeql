private import codeql_ruby.AST
private import TreeSitter
private import codeql_ruby.ast.internal.Variable
private import codeql.Locations

private predicate tuplePatternNode(Generated::AstNode n, boolean parameter) {
  n instanceof Generated::DestructuredParameter and
  parameter = true
  or
  n instanceof Generated::DestructuredLeftAssignment and
  parameter = false
  or
  n instanceof Generated::LeftAssignmentList and
  parameter = false
  or
  tuplePatternNode(n.getParent(), parameter)
}

private predicate patternNode(Generated::AstNode n, boolean parameter) {
  tuplePatternNode(n, parameter)
  or
  parameter = true and
  n = any(Callable c).getAParameter()
  or
  parameter = false and
  n in [
      any(Generated::Assignment assign).getLeft(),
      any(Generated::OperatorAssignment assign).getLeft(),
      any(Generated::ExceptionVariable a).getChild(), any(Generated::For f).getPattern(_)
    ]
}

/**
 * Holds if a variable is assigned at `i`. `parameter` indicates whether it is
 * an implicit parameter assignment.
 */
predicate assignment(Generated::Identifier i, boolean parameter) { patternNode(i, parameter) }

module Pattern {
  abstract class Range extends AstNode {
    Range() { patternNode(this, _) }

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
