/**
 * @kind graph
 */

private import cpp
private import semmle.code.cpp.ir.implementation.aliased_ssa.PrintIR
private import PrintConfig

private class PrintConfig extends PrintIRConfiguration {
  override predicate shouldPrintDeclaration(Declaration decl) { shouldDumpDeclaration(decl) }
}
