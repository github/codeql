/**
 * @kind graph
 */

private import cpp
private import semmle.code.cpp.PrintAST

private class PrintConfig extends PrintAstConfiguration {
  override predicate shouldPrintDeclaration(Declaration decl) { any() }
}
