/**
 * @kind graph
 */

import swift
import codeql.swift.printast.PrintAst
import TestUtils

/**
 * Hook to customize the functions printed by this query.
 */
class PrintAstConfigurationOverride extends PrintAstConfiguration {
  override predicate shouldPrint(Locatable e) { super.shouldPrint(e) and toBeTested(e) }
}
