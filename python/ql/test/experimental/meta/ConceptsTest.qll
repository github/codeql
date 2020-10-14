import python
import experimental.dataflow.DataFlow
import experimental.semmle.python.Concepts
import TestUtilities.InlineExpectationsTest

string value_from_expr(Expr e) {
  // TODO: This one is starting to look like `repr` predicate from TestTaintLib
  result =
    e.(StrConst).getPrefix() + e.(StrConst).getText() +
      e.(StrConst).getPrefix().regexpReplaceAll("[a-zA-Z]+", "")
  or
  result = e.(Name).getId()
  or
  not e instanceof StrConst and
  not e instanceof Name and
  result = e.toString()
}

class SystemCommandExecutionTest extends InlineExpectationsTest {
  SystemCommandExecutionTest() { this = "SystemCommandExecutionTest" }

  override string getARelevantTag() { result = "getCommand" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SystemCommandExecution sce, DataFlow::Node command |
      command = sce.getCommand() and
      location = command.getLocation() and
      element = command.toString() and
      value = value_from_expr(command.asExpr()) and
      tag = "getCommand"
    )
  }
}

class HttpServerRouteSetupTest extends InlineExpectationsTest {
  HttpServerRouteSetupTest() { this = "HttpServerRouteSetupTest" }

  override string getARelevantTag() { result in ["routeSetup", "routeHandler", "routedParameter"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(HTTP::Server::RouteSetup setup |
      location = setup.getLocation() and
      element = setup.toString() and
      (
        value = "\"" + setup.getUrlPattern() + "\""
        or
        not exists(setup.getUrlPattern()) and
        value = ""
      ) and
      tag = "routeSetup"
    )
    or
    exists(HTTP::Server::RouteSetup setup, Function func |
      func = setup.getARouteHandler() and
      location = func.getLocation() and
      element = func.toString() and
      value = "" and
      tag = "routeHandler"
    )
    or
    exists(HTTP::Server::RouteSetup setup, Parameter param |
      param = setup.getARoutedParameter() and
      location = param.getLocation() and
      element = param.toString() and
      value = param.asName().getId() and
      tag = "routedParameter"
    )
  }
}
