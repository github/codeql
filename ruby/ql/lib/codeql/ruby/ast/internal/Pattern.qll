private import codeql.ruby.AST
private import AST
private import TreeSitter

abstract class TuplePatternImpl extends Ruby::AstNode {
  abstract Ruby::AstNode getChildNode(int i);

  final int getRestIndex() {
    result = unique(int i | this.getChildNode(i) instanceof Ruby::RestAssignment)
  }
}

class TuplePatternParameterImpl extends TuplePatternImpl, Ruby::DestructuredParameter {
  override Ruby::AstNode getChildNode(int i) { result = this.getChild(i) }
}

class DestructuredLeftAssignmentImpl extends TuplePatternImpl, Ruby::DestructuredLeftAssignment {
  override Ruby::AstNode getChildNode(int i) { result = this.getChild(i) }
}

class LeftAssignmentListImpl extends TuplePatternImpl, Ruby::LeftAssignmentList {
  override Ruby::AstNode getChildNode(int i) {
    this =
      any(Ruby::LeftAssignmentList lal |
        if
          strictcount(int j | exists(lal.getChild(j))) = 1 and
          lal.getChild(0) instanceof Ruby::DestructuredLeftAssignment
        then result = lal.getChild(0).(Ruby::DestructuredLeftAssignment).getChild(i)
        else result = lal.getChild(i)
      )
  }
}

/**
 * Holds if `node` is a case pattern.
 */
predicate casePattern(Ruby::AstNode node) {
  node = any(Ruby::InClause parent).getPattern()
  or
  node = any(Ruby::ArrayPattern parent).getChild(_).(Ruby::UnderscorePatternExpr)
  or
  node = any(Ruby::FindPattern parent).getChild(_).(Ruby::UnderscorePatternExpr)
  or
  node = any(Ruby::AlternativePattern parent).getAlternatives(_)
  or
  node = any(Ruby::AsPattern parent).getValue()
  or
  node = any(Ruby::KeywordPattern parent).getValue()
}

/**
 * Holds if `node` is a class reference used in an
 * array, find, or hash pattern.
 */
predicate classReferencePattern(Ruby::AstNode node) {
  node = any(Ruby::ArrayPattern p).getClass()
  or
  node = any(Ruby::FindPattern p).getClass()
  or
  node = any(Ruby::HashPattern p).getClass()
}
