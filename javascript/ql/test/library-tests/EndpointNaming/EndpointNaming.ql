import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.Lines
import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
import testUtilities.InlineExpectationsTest
import EndpointNaming::Debug

module TestConfig implements TestSig {
  string getARelevantTag() { result = ["instance", "class", "method", "alias"] }

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
      exists(DataFlow::FunctionNode function |
        not function.getFunction() = any(ConstructorDeclaration decl | decl.isSynthetic()).getBody() and
        location = function.getFunction().getLocation() and
        tag = "method" and
        EndpointNaming::functionHasPrimaryName(function, package, name)
      )
    )
    or
    element = "" and
    tag = "alias" and
    exists(
      API::Node aliasDef, string primaryPackage, string primaryName, string aliasPackage,
      string aliasName
    |
      EndpointNaming::aliasDefinition(primaryPackage, primaryName, aliasPackage, aliasName, aliasDef) and
      value =
        EndpointNaming::renderName(aliasPackage, aliasName) + "==" +
          EndpointNaming::renderName(primaryPackage, primaryName) and
      location = aliasDef.asSink().asExpr().getLocation()
    )
  }
}

import MakeTest<TestConfig>
