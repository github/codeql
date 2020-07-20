/**
 * @kind graph
 */

import go
import semmle.go.PrintAst

class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintFunction(FuncDef func) { func.getName() = "g" }

  override predicate shouldPrintFile(File file) { any() }
}
