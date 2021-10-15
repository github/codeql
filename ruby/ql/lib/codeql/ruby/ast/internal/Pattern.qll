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
