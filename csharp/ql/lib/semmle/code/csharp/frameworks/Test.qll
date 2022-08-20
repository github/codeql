/** Provides common abstractions for different (unit) test frameworks. */

import csharp
import test.NUnit
import test.VisualStudio
import test.XUnit

/** A file containing test cases. */
abstract class TestFile extends File {
  /** A line in the current file that is covered by a test method. */
  int lineInTestMethod() {
    exists(TestMethod m | m.getFile() = this |
      result in [m.getLocation().getStartLine() .. m.getBody().getLocation().getEndLine()]
    )
  }
}

/** A class containing test cases. */
abstract class TestClass extends Class { }

/** A method defining a test case. */
abstract class TestMethod extends Method {
  /** Holds if this test case is expected to throw an exception. */
  abstract predicate expectsException();
}
