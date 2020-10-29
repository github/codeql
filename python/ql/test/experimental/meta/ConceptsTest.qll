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

class DecodingTest extends InlineExpectationsTest {
  DecodingTest() { this = "DecodingTest" }

  override string getARelevantTag() {
    result in ["decodeInput", "decodeOutput", "decodeFormat", "decodeMayExecuteInput"]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Decoding d |
      exists(DataFlow::Node data |
        location = data.getLocation() and
        element = data.toString() and
        value = value_from_expr(data.asExpr()) and
        (
          data = d.getAnInput() and
          tag = "decodeInput"
          or
          data = d.getOutput() and
          tag = "decodeOutput"
        )
      )
      or
      exists(string format |
        location = d.getLocation() and
        element = format and
        value = format and
        format = d.getFormat() and
        tag = "decodeFormat"
      )
      or
      d.mayExecuteInput() and
      location = d.getLocation() and
      element = d.toString() and
      value = "" and
      tag = "decodeMayExecuteInput"
    )
  }
}

class CodeExecutionTest extends InlineExpectationsTest {
  CodeExecutionTest() { this = "CodeExecutionTest" }

  override string getARelevantTag() { result = "getCode" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(CodeExecution ce, DataFlow::Node code |
      exists(location.getFile().getRelativePath()) and
      code = ce.getCode() and
      location = code.getLocation() and
      element = code.toString() and
      value = value_from_expr(code.asExpr()) and
      tag = "getCode"
    )
  }
}

class SqlExecutionTest extends InlineExpectationsTest {
  SqlExecutionTest() { this = "SqlExecutionTest" }

  override string getARelevantTag() { result = "getSql" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SqlExecution e, DataFlow::Node sql |
      exists(location.getFile().getRelativePath()) and
      sql = e.getSql() and
      location = e.getLocation() and
      element = sql.toString() and
      value = value_from_expr(sql.asExpr()) and
      tag = "getSql"
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

class HttpServerHttpResponseTest extends InlineExpectationsTest {
  File file;

  HttpServerHttpResponseTest() {
    file.getExtension() = "py" and
    this = "HttpServerHttpResponseTest: " + file
  }

  override string getARelevantTag() { result in ["HttpResponse", "responseBody", "mimetype"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    // By adding `file` as a class field, and these two restrictions, it's possible to
    // say that we only want to check _some_ tags for certain files. This helped make
    // flask tests more readable since adding full annotations for HttpResponses in the
    // the tests for routing setup is both annoying and not very useful.
    location.getFile() = file and
    tag = getARelevantTag() and
    (
      exists(HTTP::Server::HttpResponse response |
        location = response.getLocation() and
        element = response.toString() and
        value = "" and
        tag = "HttpResponse"
      )
      or
      exists(HTTP::Server::HttpResponse response |
        location = response.getLocation() and
        element = response.toString() and
        value = value_from_expr(response.getBody().asExpr()) and
        tag = "responseBody"
      )
      or
      exists(HTTP::Server::HttpResponse response |
        location = response.getLocation() and
        element = response.toString() and
        value = response.getMimetype() and
        tag = "mimetype"
      )
    )
  }
}
