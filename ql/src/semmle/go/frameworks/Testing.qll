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
      getName().regexpMatch("Test(?![a-z]).*") and
      getNumParameter() = 1 and
      getParameter(0).getType().(PointerType).getBaseType().hasQualifiedName("testing", "T")
      or
      getName().regexpMatch("Benchmark(?![a-z]).*") and
      getNumParameter() = 1 and
      getParameter(0).getType().(PointerType).getBaseType().hasQualifiedName("testing", "B")
      or
      getName().regexpMatch("Example(?![a-z]).*") and
      getNumParameter() = 0
    }
  }
}

/**
 * A file that contains test cases or is otherwise used for testing.
 *
 * Extend this class to refine existing models of testing frameworks. If you want to model new
 * frameworks, extend `TestFile::Range` instead.
 */
class TestFile extends File {
  TestFile::Range self;

  TestFile() { this = self }
}

/** Provides classes for working with test files. */
module TestFile {
  /**
   * A file that contains test cases or is otherwise used for testing.
   *
   * Extend this class to model new testing frameworks. If you want to refine existing models,
   * extend `TestFile` instead.
   */
  abstract class Range extends File { }

  /** A file containing at least one test case. */
  private class FileContainingTestCases extends Range {
    FileContainingTestCases() { this = any(TestCase tc).getFile() }
  }

  /** A file that imports a well-known testing framework. */
  private class FileImportingTestingFramework extends Range {
    FileImportingTestingFramework() {
      exists(string pkg, ImportSpec is |
        is.getPath() = pkg and
        is.getFile() = this
      |
        pkg = "net/http/httptest" or
        pkg = "gen/thrifttest" or
        pkg = "github.com/onsi/ginkgo" or
        pkg = "github.com/onsi/gomega"
      )
    }
  }
}

/** Provides classes modelling Ginkgo. */
module Ginkgo {
  /** The Ginkgo `Fail` function, which always panics. */
  private class FailFunction extends Function {
    FailFunction() { hasQualifiedName("github.com/onsi/ginkgo", "Fail") }

    override predicate mustPanic() { any() }
  }
}
