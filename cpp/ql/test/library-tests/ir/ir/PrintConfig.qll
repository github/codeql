private import cpp

/**
 * Holds if the specified location is in standard headers.
 */
predicate locationIsInStandardHeaders(Location loc) {
  loc.getFile().getAbsolutePath().regexpMatch(".*/include/[^/]+")
}

/**
 * Holds if the AST or IR for the specified function should be printed in the test output.
 *
 * This predicate excludes functions defined in standard headers.
 */
predicate shouldDumpFunction(Function func) { not locationIsInStandardHeaders(func.getLocation()) }
