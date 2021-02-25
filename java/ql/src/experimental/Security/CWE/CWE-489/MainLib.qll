/** Definitions related to the main method in a test program. */

import java

/** Holds if `m` is the main method of a Java class with the signature `public static void main(String[] args)`. */
predicate isMainMethod(Method m) {
  m.hasName("main") and
  m.isStatic() and
  m.getReturnType() instanceof VoidType and
  m.isPublic() and
  m.getNumberOfParameters() = 1 and
  m.getParameter(0).getType() instanceof Array
}

/**
 * Holds if `m` is a test method indicated by:
 *    a) in a test directory such as `src/test/java`
 *    b) in a test package whose name has the word `test`
 *    c) in a test class whose name has the word `test`
 *    d) in a test class implementing a test framework such as JUnit or TestNG
 */
predicate isTestMethod(Method m) {
  m.getDeclaringType().getName().toLowerCase().matches("%test%") or // Simple check to exclude test classes to reduce FPs
  m.getDeclaringType().getPackage().getName().toLowerCase().matches("%test%") or // Simple check to exclude classes in test packages to reduce FPs
  exists(m.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java")) or //  Match test directory structure of build tools like maven
  m instanceof TestMethod // Test method of a test case implementing a test framework such as JUnit or TestNG
}
