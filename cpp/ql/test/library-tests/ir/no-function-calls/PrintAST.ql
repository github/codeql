/**
 * @kind graph
 */

private import cpp
private import semmle.code.cpp.PrintAST
private import PrintConfig

private class PrintConfig extends PrintAstConfiguration {
  override predicate shouldPrintDeclaration(Declaration decl) { shouldDumpDeclaration(decl) }
}
