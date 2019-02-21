import python

abstract class TestScope extends Scope {}

// don't extend Class directly to avoid ambiguous method warnings
class UnitTestClass extends TestScope {
    UnitTestClass() {
        exists(ClassObject c |
            this = c.getPyClass() |
            c.getASuperType() = theUnitTestPackage().attr(_)
            or
            c.getASuperType().getName().toLowerCase() = "testcase"
        )
    }
}

PackageObject theUnitTestPackage() {
    result.getName() = "unittest"
}

abstract class Test extends TestScope {}

class UnitTestFunction extends Test {

    UnitTestFunction() {
        this.getScope+() instanceof UnitTestClass
        and
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
