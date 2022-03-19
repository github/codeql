/**
 * @name Too few assertions
 * @description Each function over 20 logical lines should have at least two assertions.
 * @kind problem
 * @id cpp/power-of-10/assertion-density
 * @problem.severity recommendation
 * @tags maintainability
 *       reliability
 *       external/powerof10
 */

import semmle.code.cpp.commons.Assertions

class MacroFunctionCall extends MacroInvocation {
  MacroFunctionCall() {
    not exists(this.getParentInvocation()) and
    this.getMacro().getHead().matches("%(%")
  }

  FunctionDeclarationEntry getFunction() {
    result.getFunction() = this.getAGeneratedElement().(Stmt).getEnclosingFunction()
  }
}

int logicalLength(FunctionDeclarationEntry f) {
  result =
    count(Stmt s |
        s.getEnclosingFunction() = f.getFunction() and
        s.getFile() = f.getFile() and
        not s instanceof BlockStmt and
        not s instanceof EmptyStmt and
        not exists(ForStmt for | s = for.getInitialization()) and
        not s.isAffectedByMacro()
      ) + count(MacroFunctionCall mf | mf.getFunction() = f)
}

int assertionCount(FunctionDeclarationEntry f) {
  result =
    count(Assertion a |
      a.getAsserted().getEnclosingFunction() = f.getFunction() and a.getFile() = f.getFile()
    )
}

from FunctionDeclarationEntry f, int numAsserts, int size, int minSize
where
  minSize = 20 and
  numAsserts = assertionCount(f) and
  numAsserts < 2 and
  size = logicalLength(f) and
  size > minSize
select f.getFunction(),
  "Function " + f.getName() + " has " + size + " logical lines, but only " + numAsserts +
    " assertion(s) -- minimum is 2 (for functions over " + minSize + " logical lines)."
