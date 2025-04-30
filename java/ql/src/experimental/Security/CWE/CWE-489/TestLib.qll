/** Definitions related to test methods. */
deprecated module;

import java

/**
 * Holds if `m` is a test method indicated by:
 *    a) in a test directory such as `src/test/java`
 *    b) in a test package whose name has the word `test`
 *    c) in a test class whose name has the word `test`
 *    d) in a test class implementing a test framework such as JUnit or TestNG
 */
predicate isTestMethod(LikelyTestMethod m) { any() }
