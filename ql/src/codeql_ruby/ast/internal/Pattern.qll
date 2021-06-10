private import codeql_ruby.AST
private import AST
private import TreeSitter

abstract class TuplePatternImpl extends Generated::AstNode {
  abstract Generated::AstNode getChildNode(int i);

  final int getRestIndex() {
    result = unique(int i | this.getChildNode(i) instanceof Generated::RestAssignment)
  }
}

class TuplePatternParameterImpl extends TuplePatternImpl, Generated::DestructuredParameter {
  override Generated::AstNode getChildNode(int i) { result = this.getChild(i) }
}

class DestructuredLeftAssignmentImpl extends TuplePatternImpl, Generated::DestructuredLeftAssignment {
  override Generated::AstNode getChildNode(int i) { result = this.getChild(i) }
}

class LeftAssignmentListImpl extends TuplePatternImpl, Generated::LeftAssignmentList {
  override Generated::AstNode getChildNode(int i) {
    this =
      any(Generated::LeftAssignmentList lal |
        if
          strictcount(int j | exists(lal.getChild(j))) = 1 and
          lal.getChild(0) instanceof Generated::DestructuredLeftAssignment
        then result = lal.getChild(0).(Generated::DestructuredLeftAssignment).getChild(i)
        else result = lal.getChild(i)
      )
  }
}
