/**
 * @kind graph
 */

private import cpp
private import semmle.code.cpp.PrintAST
private import PrintConfig

private class PrintConfig extends PrintAstConfiguration {
  override predicate shouldPrintFunction(Function func) { shouldDumpFunction(func) }
}
