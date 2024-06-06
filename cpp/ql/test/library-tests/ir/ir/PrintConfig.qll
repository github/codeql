private import cpp

/**
 * Holds if the specified location is in standard headers.
 */
predicate locationIsInStandardHeaders(Location loc) {
  loc.getFile().getAbsolutePath().regexpMatch(".*/include/[^/]+")
}

/**
 * Holds if the AST or IR for the specified declaration should be printed in the test output.
 *
 * This predicate excludes declarations defined in standard headers.
 */
predicate shouldDumpDeclaration(Declaration decl) {
  not locationIsInStandardHeaders(decl.getLocation()) and
  (
    decl instanceof Function
    or
    decl.(GlobalOrNamespaceVariable).hasInitializer()
    or
    decl.(StaticLocalVariable).hasInitializer()
  )
}
