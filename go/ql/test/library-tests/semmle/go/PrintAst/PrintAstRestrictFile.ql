/**
 * @kind graph
 */

import go
import semmle.go.PrintAst

class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintFunction(FuncDecl func) { any() }

  override predicate shouldPrintFile(File file) { file.getBaseName() = "other.go" }
}
