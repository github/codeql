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
    exists(SystemCommandExecution sce, DataFlow::Node command |
      exists(location.getFile().getRelativePath()) and
      command = sce.getCommand() and
      location = command.getLocation() and
      element = command.toString() and
      value = value_from_expr(command.asExpr()) and
      tag = "getCommand"
    )
  }
}

class DeserializationSinkTest extends InlineExpectationsTest {
  DeserializationSinkTest() { this = "DeserializationSinkTest" }

  override string getARelevantTag() { result = "getData" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DeserializationSink ds, DataFlow::Node data |
      exists(location.getFile().getRelativePath()) and
      data = ds.getData() and
      location = data.getLocation() and
      element = data.toString() and
      value = value_from_expr(data.asExpr()) and
      tag = "getData"
    )
  }
}
