import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.Lines
import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
import utils.test.InlineExpectationsTest
import EndpointNaming::Debug

private predicate isIgnored(DataFlow::FunctionNode function) {
  function.getFunction() = any(ConstructorDeclaration decl | decl.isSynthetic()).getBody()
}

module TestConfig implements TestSig {
  string getARelevantTag() { result = ["name", "alias"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    tag = "name" and
    exists(DataFlow::SourceNode function, string package, string name |
      EndpointNaming::functionHasPrimaryName(function, package, name) and
      not isIgnored(function) and
      location = function.getAstNode().getLocation() and
      value = EndpointNaming::renderName(package, name)
    )
    or
    element = "" and
    tag = "alias" and
    exists(
      API::Node aliasDef, string primaryPackage, string primaryName, string aliasPackage,
      string aliasName
    |
      EndpointNaming::aliasDefinition(aliasPackage, aliasName, primaryPackage, primaryName, aliasDef) and
      value =
        EndpointNaming::renderName(aliasPackage, aliasName) + "==" +
          EndpointNaming::renderName(primaryPackage, primaryName) and
      location = aliasDef.asSink().asExpr().getLocation()
    )
  }
}

import MakeTest<TestConfig>
