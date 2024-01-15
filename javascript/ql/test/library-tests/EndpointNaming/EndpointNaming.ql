import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.Lines
import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
import testUtilities.InlineExpectationsTest
import EndpointNaming::Debug

module TestConfig implements TestSig {
  string getARelevantTag() {
    result = "instance"
    or
    result = "class"
    or
    result = "method"
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(string package, string name |
      element = "" and
      value = EndpointNaming::renderName(package, name)
    |
      exists(DataFlow::ClassNode cls | location = cls.getAstNode().getLocation() |
        tag = "class" and
        EndpointNaming::classObjectHasPrimaryName(cls, package, name)
        or
        tag = "instance" and
        EndpointNaming::classInstanceHasPrimaryName(cls, package, name)
      )
      or
      element = "" and
      exists(DataFlow::FunctionNode function |
        not function.getFunction() = any(ConstructorDeclaration decl | decl.isSynthetic()).getBody() and
        location = function.getFunction().getLocation() and
        tag = "method" and
        EndpointNaming::functionHasPrimaryName(function, package, name)
      )
    )
  }
}

import MakeTest<TestConfig>
