import python

abstract class TestScope extends Scope { }

// don't extend Class directly to avoid ambiguous method warnings
class UnitTestClass extends TestScope {
  UnitTestClass() {
    exists(ClassValue cls | this = cls.getScope() |
      cls.getABaseType+() = Module::named("unittest").attr(_)
      or
      cls.getABaseType+().getName().toLowerCase() = "testcase"
    )
  }
}

abstract class Test extends TestScope { }

/** Class of test function that uses the `unittest` framework */
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

/** Class of functions that are clearly tests, but don't belong to a specific framework */
class UnknownTestFunction extends Test {
  UnknownTestFunction() {
    this.(Function).getName().matches("test%") and
    this.getEnclosingModule().getFile().getShortName().matches("test_%.py")
  }
}
