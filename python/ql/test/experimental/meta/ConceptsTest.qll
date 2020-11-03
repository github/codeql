import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts
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

class EncodingTest extends InlineExpectationsTest {
  EncodingTest() { this = "EncodingTest" }

  override string getARelevantTag() { result in ["encodeInput", "encodeOutput", "encodeFormat"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Encoding e |
      exists(DataFlow::Node data |
        location = data.getLocation() and
        element = data.toString() and
        value = value_from_expr(data.asExpr()) and
        (
          data = e.getAnInput() and
          tag = "encodeInput"
          or
          data = e.getOutput() and
          tag = "encodeOutput"
        )
      )
      or
      exists(string format |
        location = e.getLocation() and
        element = format and
        value = format and
        format = e.getFormat() and
        tag = "encodeFormat"
      )
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
        // Ensure that an expectation value such as "mimetype=text/html; charset=utf-8" is parsed as a
        // single expectation with tag mimetype, and not as two expecations with tags mimetype and
        // charset.
        (
          if exists(response.getMimetype().indexOf(" "))
          then value = "\"" + response.getMimetype() + "\""
          else value = response.getMimetype()
        ) and
        tag = "mimetype"
      )
    )
  }
}

class FileSystemAccessTest extends InlineExpectationsTest {
  FileSystemAccessTest() { this = "FileSystemAccessTest" }

  override string getARelevantTag() { result = "getAPathArgument" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess a, DataFlow::Node path |
      exists(location.getFile().getRelativePath()) and
      path = a.getAPathArgument() and
      location = a.getLocation() and
      element = path.toString() and
      value = value_from_expr(path.asExpr()) and
      tag = "getAPathArgument"
    )
  }
}

class PathNormalizationTest extends InlineExpectationsTest {
  PathNormalizationTest() { this = "PathNormalizationTest" }

  override string getARelevantTag() { result = "pathNormalization" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Path::PathNormalization n |
      exists(location.getFile().getRelativePath()) and
      location = n.getLocation() and
      element = n.toString() and
      value = "" and
      tag = "pathNormalization"
    )
  }
}

class SafeAccessCheckTest extends InlineExpectationsTest {
  SafeAccessCheckTest() { this = "SafeAccessCheckTest" }

  override string getARelevantTag() { result in ["checks", "branch"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Path::SafeAccessCheck c, DataFlow::Node checks, boolean branch |
      exists(location.getFile().getRelativePath()) and
      c.checks(checks.asCfgNode(), branch) and
      location = c.getLocation() and
      (
        element = checks.toString() and
        value = value_from_expr(checks.asExpr()) and
        tag = "checks"
        or
        element = branch.toString() and
        value = branch.toString() and
        tag = "branch"
      )
    )
  }
}
