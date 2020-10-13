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

class UnmarshalingFunctionTest extends InlineExpectationsTest {
  UnmarshalingFunctionTest() { this = "UnmarshalingFunctionTest" }

  override string getARelevantTag() { result = "getData" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(UnmarshalingFunction ds, string unsafe |
      (
        ds.unsafe() and unsafe = "UNSAFE_"
        or
        not ds.unsafe() and unsafe = ""
      ) and
      (
        exists(DataFlow::Node data |
          location = data.getLocation() and
          element = data.toString() and
          value = value_from_expr(data.asExpr()) and
          (
            data = ds.getAnInput() and
            tag = unsafe + "getAnInput"
            or
            data = ds.getOutput() and
            tag = unsafe + "getOutput"
          )
        )
        or
        exists(string format |
          location = ds.getLocation() and
          element = format and
          value = format and
          format = ds.getFormat() and
          tag = unsafe + "getFormat"
        )
      )
    )
  }
}
