/** Provides classes for working with tests. */

import go

/**
 * A program element that represents a test case.
 *
 * Extend this class to refine existing models of testing frameworks. If you want to model new
 * frameworks, extend `TestCase::Range` instead.
 */
class TestCase extends AstNode {
  TestCase::Range self;

  TestCase() { this = self }
}

/** Provides classes for working with test cases. */
module TestCase {
  /**
   * A program element that represents a test case.
   *
   * Extend this class to model new testing frameworks. If you want to refine existing models,
   * extend `TestCase` instead.
   */
  abstract class Range extends AstNode { }

  /** A `go test` style test (including benchmarks and examples). */
  private class GoTestFunction extends Range, FuncDef {
    GoTestFunction() {
      getName().regexpMatch("Test[^a-z].*") and
      getNumParameter() = 1 and
      getParameter(0).getType().(PointerType).getBaseType().hasQualifiedName("testing", "T")
      or
      getName().regexpMatch("Benchmark[^a-z].*") and
      getNumParameter() = 1 and
      getParameter(0).getType().(PointerType).getBaseType().hasQualifiedName("testing", "B")
      or
      getName().regexpMatch("Example[^a-z].*") and
      getNumParameter() = 0
    }
  }
}
