/**
 * @name Misleading indentation
 * @description If a control structure does not use braces, misleading indentation makes it
 *              difficult to see which statements are within its scope.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/misleading-indentation
 * @tags maintainability
 *       correctness
 *       logic
 */

import java

/**
 * A control structure for which the trailing body (the syntactically last part)
 * is not a `BlockStmt`. This is either an `IfStmt` or a `LoopStmt`, but not a
 * `DoStmt`, since do-while statements don't have a trailing body.
 */
predicate unbracedTrailingBody(Stmt ctrlStructure, Stmt trailingBody) {
  not trailingBody instanceof BlockStmt and
  (
    exists(IfStmt c | c = ctrlStructure |
      trailingBody = c.getElse() and not trailingBody instanceof IfStmt
      or
      trailingBody = c.getThen() and not exists(c.getElse())
    )
    or
    exists(LoopStmt c | c = ctrlStructure | not c instanceof DoStmt and trailingBody = c.getBody())
  )
}

/*
 * The body of a `SwitchStmt` is a block, but it isn't represented explicitly
 * in the AST as a `BlockStmt`, so we have to take it into account directly in the
 * following two predicates.
 */

/**
 * Two consecutive statements in a `BlockStmt` statement or `SwitchStmt`.
 */
Stmt nextInBlock(Stmt s) {
  exists(BlockStmt b, int i |
    b.getStmt(i) = s and
    b.getStmt(i + 1) = result
  )
  or
  exists(SwitchStmt b, int i |
    b.getStmt(i) = s and
    b.getStmt(i + 1) = result
  )
}

/** The `Stmt.getParent()` relation restricted to not pass through `BlockStmt`s or `SwitchStmt`s. */
Stmt nonBlockParent(Stmt s) {
  result = s.getParent() and
  not result instanceof BlockStmt and
  not result instanceof SwitchStmt
}

/** An else-if construction. */
predicate ifElseIf(IfStmt s, IfStmt elseif) { s.getElse() = elseif }

/**
 * The statement `body` is an unbraced trailing body of a control structure and
 * `succ` is the next statement in the surrounding `BlockStmt` (or `SwitchStmt`).
 */
predicate shouldOutdent(
  Stmt ctrl, Stmt body, Stmt succ, int bodycol, int succcol, int bodyline, int succline
) {
  unbracedTrailingBody(ctrl, body) and
  succ = nextInBlock(nonBlockParent*(body)) and
  bodycol = body.getLocation().getStartColumn() and
  succcol = succ.getLocation().getStartColumn() and
  bodyline = body.getLocation().getStartLine() and
  succline = succ.getLocation().getStartLine()
}

/**
 * The statement `body` is an unbraced trailing body of a control structure and
 * `succ` is the next statement in the surrounding `BlockStmt` (or `SwitchStmt`).
 * The indentation of statement `succ` is suspect because it is indented
 * the same way as `body` and thus visually suggests to be part of the same
 * syntactic scope as `body`.
 *
 * Example situations:
 *
 * ```
 * if (cond) body; succ;
 *
 * if (cond)
 *   body;
 *   succ;
 * ```
 */
predicate suspectIndentation(Stmt ctrl, Stmt body, Stmt succ) {
  exists(int bodycol, int succcol, int ctrlcol, int bodyline, int succline |
    shouldOutdent(ctrl, body, succ, bodycol, succcol, bodyline, succline) and
    (bodycol = succcol or bodyline = succline) and
    // Disregard cases when `ctrl`, `body`, and `succ` are all equally indented.
    (ctrlcol < bodycol or bodycol < succcol) and
    (
      ctrlcol = ctrl.getLocation().getStartColumn()
      or
      exists(IfStmt s | ifElseIf+(s, ctrl) and ctrlcol = s.getLocation().getStartColumn())
    )
  )
}

/** A statement that aborts the regular control-flow. */
predicate abortsControlFlow(Stmt s) {
  s instanceof JumpStmt or
  s instanceof ReturnStmt or
  s instanceof ThrowStmt
}

from Stmt c, Stmt s, Stmt t
where
  suspectIndentation(c, s, t) and
  // Exclude control-flow-aborting statements as these cases are less likely to be logic errors.
  not abortsControlFlow(s) and
  // Exclude the double semicolon case `if (cond) s;;`.
  not t instanceof EmptyStmt and
  // `LocalClassDeclStmt`s yield false positives since their `Location` doesn't include the `class` keyword.
  not t instanceof LocalClassDeclStmt
select s,
  "Indentation suggests that $@ belongs to $@, but this is not the case; consider adding braces or adjusting indentation.",
  t, "the next statement", c, "the control structure"
