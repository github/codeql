/**
 * @name Misleading indentation
 * @description If a control structure does not use braces, misleading indentation makes it
 *              difficult to see which statements are within its scope.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/misleading-indentation
 * @tags changeability
 *       correctness
 *       logic
 */

import csharp

// Iterate the control flow until we reach a Stmt
Stmt findSuccessorStmt(ControlFlow::Node n) {
  result = n.getElement()
  or
  not n.getElement() instanceof Stmt and result = findSuccessorStmt(n.getASuccessor())
}

// Return a successor statement to s
Stmt getASuccessorStmt(Stmt s) {
  result = findSuccessorStmt(s.getAControlFlowNode().getASuccessor())
}

class IfThenStmt extends IfStmt {
  IfThenStmt() { not exists(Stmt s | getElse() = s) }
}

class IfThenElseStmt extends IfStmt {
  IfThenElseStmt() { exists(Stmt s | getElse() = s) }
}

Stmt getTrailingBody(Stmt s) {
  result = s.(ForStmt).getBody() or
  result = s.(ForeachStmt).getBody() or
  result = s.(WhileStmt).getBody() or
  result = s.(IfThenStmt).getThen() or
  result = s.(IfThenElseStmt).getElse()
}

// Any control statement which has a trailing block
// which could cause indentation confusion
abstract class UnbracedControlStmt extends Stmt {
  abstract Stmt getBody();

  abstract Stmt getSuccessorStmt();

  private Stmt getACandidate() {
    getSuccessorStmt() = result and
    getBlockStmt(this) = getBlockStmt(result)
  }

  private Location getBodyLocation() { result = getBody().getLocation() }

  pragma[noopt]
  Stmt getAConfusingTrailingStmt() {
    result = getACandidate() and
    exists(Location l1, Location l2 | l1 = getBodyLocation() and l2 = result.getLocation() |
      // This test is slightly unreliable
      // because tabs are counted as 1 column.
      // But it's accurate enough to be useful, and will
      // work for consistently formatted text.
      l1.getStartColumn() = l2.getStartColumn() or
      l1.getStartLine() = l2.getStartLine()
    )
  }
}

class UnbracedIfStmt extends UnbracedControlStmt {
  UnbracedIfStmt() {
    this instanceof IfStmt and
    not getTrailingBody(this) instanceof BlockStmt and
    not getTrailingBody(this) instanceof IfStmt
  }

  override Stmt getBody() { result = getTrailingBody(this) }

  override Stmt getSuccessorStmt() {
    result = getASuccessorStmt(getBody()) and
    result != this
  }
}

class UnbracedLoopStmt extends UnbracedControlStmt {
  UnbracedLoopStmt() {
    this instanceof LoopStmt and
    not this instanceof DoStmt and
    not getTrailingBody(this) instanceof BlockStmt
  }

  override Stmt getBody() { result = getTrailingBody(this) }

  override Stmt getSuccessorStmt() {
    result = getASuccessorStmt(this) and
    result != getBody()
  }
}

BlockStmt getBlockStmt(Element e) {
  result = e.getParent() or
  result = getBlockStmt(e.(IfStmt).getParent()) // Handle chained ifs
}

from UnbracedControlStmt s, Stmt n
where n = s.getAConfusingTrailingStmt()
select s, "Missing braces? Inspect indentation of $@.", n, "the control flow successor"
