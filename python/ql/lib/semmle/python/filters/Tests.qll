import python
private import semmle.python.ApiGraphs

abstract class TestScope extends Scope { }

class UnitTestClass extends TestScope, Class {
  UnitTestClass() {
    exists(API::Node testCaseClass, string testCaseString |
      testCaseString.matches("%TestCase") and
      testCaseClass = any(API::Node mod).getMember(testCaseString)
    |
      this.getParent() = testCaseClass.getASubclass*().asSource().asExpr()
    )
  }
}

abstract class Test extends TestScope { }

/** A test function that uses the `unittest` framework */
class UnitTestFunction extends Test {
  UnitTestFunction() {
    this.getScope+() instanceof UnitTestClass and
    this.(Function).getName().matches("test%")
  }
}

class PyTestFunction extends Test {
  PyTestFunction() {
    exists(Module pytest | pytest.getName() = "pytest") and
    this.(Function).getName().matches("test%")
  }
}

class NoseTestFunction extends Test {
  NoseTestFunction() {
    exists(Module nose | nose.getName() = "nose") and
    this.(Function).getName().matches("test%")
  }
}

/** A function that is clearly a test, but doesn't belong to a specific framework */
class UnknownTestFunction extends Test {
  UnknownTestFunction() {
    this.(Function).getName().matches("test%") and
    this.getEnclosingModule().getFile().getShortName().matches("test_%.py")
  }
}
