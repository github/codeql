private import cpp

/**
 * Holds if an AST or IR with the specified location should be printed in the test output.
 *
 * This predicate excludes locations in standard headers.
 */
predicate shouldDumpLocation(Location loc) {
  not loc.getFile().getAbsolutePath().regexpMatch(".*/include/[^/]+")
}

/**
 * Holds if the AST or IR for the specified function should be printed in the test output.
 *
 * This predicate excludes functions defined in standard headers.
 */
predicate shouldDumpFunction(Function func) { shouldDumpLocation(func.getLocation()) }
