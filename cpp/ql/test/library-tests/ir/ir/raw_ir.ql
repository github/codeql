/**
 * @kind graph
 */

private import cpp
private import semmle.code.cpp.ir.implementation.raw.PrintIR
private import PrintConfig

private class PrintConfig extends PrintIRConfiguration {
  override predicate shouldPrintFunction(Function func) { shouldDumpFunction(func) }
}
