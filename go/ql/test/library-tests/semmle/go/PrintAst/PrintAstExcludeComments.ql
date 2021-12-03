/**
 * @kind graph
 */

import go
import semmle.go.PrintAst

class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintFunction(FuncDecl func) { any() }

  override predicate shouldPrintFile(File file) { any() }

  override predicate shouldPrintComments(File file) { none() }
}
