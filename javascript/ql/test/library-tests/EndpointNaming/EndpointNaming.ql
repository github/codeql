import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.Lines
import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
import testUtilities.InlineExpectationsTest
import EndpointNaming::Debug

private predicate isIgnored(DataFlow::FunctionNode function) {
  function.getFunction() = any(ConstructorDeclaration decl | decl.isSynthetic()).getBody()
}

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
      exists(DataFlow::SourceNode function |
        not isIgnored(function) and
        location = function.getAstNode().getLocation() and
        tag = "method" and
        EndpointNaming::functionHasPrimaryName(function, package, name) and
        not function instanceof DataFlow::ClassNode // reported with class tag
      )
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
