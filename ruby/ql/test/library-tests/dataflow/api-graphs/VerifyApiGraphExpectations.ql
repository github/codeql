import ruby
import codeql.dataflow.internal.AccessPathSyntax
import codeql.ruby.ast.internal.TreeSitter
import codeql.ruby.frameworks.data.internal.ApiGraphModels as ApiGraphModels
import codeql.ruby.ApiGraphs
import utils.test.InlineExpectationsTest

private predicate accessPathRange(string s) { hasExpectationWithValue(_, s) }

import AccessPath<accessPathRange/1>

API::Node evaluatePath(AccessPath path, int n) {
  n = 1 and
  exists(AccessPathToken token | token = path.getToken(0) |
    token.getName() = "Member" and
    result = API::getTopLevelMember(token.getAnArgument())
    or
    token.getName() = "Method" and
    result = API::getTopLevelCall(token.getAnArgument())
    or
    token.getName() = "EntryPoint" and
    result = token.getAnArgument().(API::EntryPoint).getANode()
  )
  or
  result = ApiGraphModels::getSuccessorFromNode(evaluatePath(path, n - 1), path.getToken(n - 1))
  or
  result = ApiGraphModels::getSuccessorFromInvoke(evaluatePath(path, n - 1), path.getToken(n - 1))
  or
  // TODO this is a workaround, support parsing of Method['[]'] instead
  path.getToken(n - 1).getName() = "MethodBracket" and
  result = evaluatePath(path, n - 1).getMethod("[]")
}

API::Node evaluatePath(AccessPath path) { result = evaluatePath(path, path.getNumToken()) }

module ApiUseTest implements TestSig {
  string getARelevantTag() { result = ["source", "sink", "call", "reachableFromSource"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    // All results are considered optional
    none()
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(API::Node apiNode, DataFlow::Node dataflowNode |
      apiNode = evaluatePath(value) and
      (
        tag = "source" and dataflowNode = apiNode.asSource()
        or
        tag = "reachableFromSource" and dataflowNode = apiNode.getAValueReachableFromSource()
        or
        tag = "sink" and dataflowNode = apiNode.asSink()
        or
        tag = "call" and dataflowNode = apiNode.asCall()
      ) and
      location = dataflowNode.getLocation() and
      element = dataflowNode.toString()
    )
  }
}

import MakeTest<ApiUseTest>

class CustomEntryPointCall extends API::EntryPoint {
  CustomEntryPointCall() { this = "CustomEntryPointCall" }

  override DataFlow::CallNode getACall() { result.getMethodName() = "customEntryPointCall" }
}

class CustomEntryPointUse extends API::EntryPoint {
  CustomEntryPointUse() { this = "CustomEntryPointUse" }

  override DataFlow::LocalSourceNode getASource() {
    result.(DataFlow::CallNode).getMethodName() = "customEntryPointUse"
  }
}
