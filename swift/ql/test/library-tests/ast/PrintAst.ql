/**
 * @kind graph
 */

import swift
import codeql.swift.printast.PrintAst
import TestUtils

/**
 * The hook to customize the entities printed by this query.
 */
class PrintAstConfigurationOverride extends PrintAstConfiguration {
  override predicate shouldPrint(Locatable e) {
    super.shouldPrint(e) and toBeTested(e) and not e instanceof ModuleDecl
  }
}
