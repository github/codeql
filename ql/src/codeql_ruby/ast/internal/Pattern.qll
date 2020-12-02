import codeql_ruby.AST
private import TreeSitter
private import Variable
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
      any(Generated::OperatorAssignment assign).getLeft()
    ]
}

/**
 * Holds if a variable is assigned at `i`. `parameter` indicates whether it is
 * an implicit parameter assignment.
 */
predicate assignment(Generated::Identifier i, boolean parameter) { patternNode(i, parameter) }

abstract class PatternRange extends AstNode {
  PatternRange() { patternNode(this, _) }

  abstract Variable getAVariable();
}

class VariablePatternRange extends PatternRange {
  override Generated::Identifier generated;

  string getVariableName() { result = generated.getValue() }

  override Variable getAVariable() { access(this, result) }
}

abstract class TuplePatternRange extends PatternRange {
  abstract PatternRange getElement(int i);

  override Variable getAVariable() { result = this.getElement(_).getAVariable() }
}

private class ParameterTuplePatternRange extends TuplePatternRange {
  override Generated::DestructuredParameter generated;

  override PatternRange getElement(int i) { result = generated.getChild(i) }
}

private class AssignmentTuplePatternRange extends TuplePatternRange {
  override Generated::DestructuredLeftAssignment generated;

  override PatternRange getElement(int i) { result = generated.getChild(i) }
}

private class AssignmentListPatternRange extends TuplePatternRange {
  override Generated::LeftAssignmentList generated;

  override PatternRange getElement(int i) { result = generated.getChild(i) }
}
