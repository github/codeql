private import codeql_ruby.AST
private import TreeSitter
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.ast.internal.Method
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
    or
    parent instanceof Generated::RestAssignment
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
predicate implicitParameterAssignmentNode(Generated::AstNode n, Callable::Range c) {
  n = c.getParameter(_)
  or
  implicitParameterAssignmentNode(n.getParent().(Generated::DestructuredParameter), c)
}

module Pattern {
  class Range extends AstNode::Range {
    cached
    Range() {
      explicitAssignmentNode(this, _)
      or
      implicitAssignmentNode(this)
      or
      implicitParameterAssignmentNode(this, _)
    }

    Variable getAVariable() { none() }

    override string toString() { none() }
  }
}

module VariablePattern {
  class Range extends Pattern::Range, @token_identifier {
    override Generated::Identifier generated;

    string getVariableName() { result = generated.getValue() }

    override Variable getAVariable() { access(this, result) }

    override string toString() { result = this.getVariableName() }
  }
}

module TuplePattern {
  private class Range_ =
    @destructured_parameter or @destructured_left_assignment or @left_assignment_list;

  class Range extends Pattern::Range, Range_ {
    Pattern::Range getElement(int i) {
      exists(Generated::AstNode c | c = getChild(i) |
        result = c.(Generated::RestAssignment).getChild()
        or
        not c instanceof Generated::RestAssignment and result = c
      )
    }

    private Generated::AstNode getChild(int i) {
      result = this.(Generated::DestructuredParameter).getChild(i)
      or
      result = this.(Generated::DestructuredLeftAssignment).getChild(i)
      or
      result = this.(Generated::LeftAssignmentList).getChild(i)
    }

    int getRestIndex() { result = unique(int i | getChild(i) instanceof Generated::RestAssignment) }

    override Variable getAVariable() { result = this.getElement(_).getAVariable() }

    override string toString() { result = "(..., ...)" }
  }
}
