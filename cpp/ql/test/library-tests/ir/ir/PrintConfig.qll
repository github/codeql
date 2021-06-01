private import cpp

/**
 * Holds if the AST or IR for the specified function should be printed in the test output.
 *
 * This predicate excludes functions defined in standard headers.
 */
predicate shouldDumpFunction(Function func) {
  not func.getLocation().getFile().getAbsolutePath().regexpMatch(".*/include/[^/]+")
}
