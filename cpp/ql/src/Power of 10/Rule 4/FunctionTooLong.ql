/**
 * @name Function too long
 * @description Function length should be limited to what can be printed on a single sheet of paper (60 logical lines).
 * @kind problem
 * @id cpp/power-of-10/function-too-long
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

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

from FunctionDeclarationEntry f, int n
where logicalLength(f) = n and n > 60
select f.getFunction(),
  "Function " + f.getName() + " has too many logical lines (" + n + ", while 60 are allowed)."
