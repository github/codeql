import javascript

class Assertion extends DataFlow::CallNode {
  Assertion() { this.getCalleeName() = "checkJSON" }

  string getMessage() {
    if not any(JsonParserCall call).getOutput().flowsTo(this.getArgument(0))
    then result = "Should be JSON parser"
    else result = "OK"
  }
}

from Assertion assertion
select assertion, assertion.getMessage()
