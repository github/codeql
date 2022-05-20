import javascript
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

/**
 * Gets the value of a tag of form `tag:value` in the JSDoc comment for `doc`.
 *
 * We avoid using JSDoc tags as the call graph construction may depend on them
 * in the future.
 */
string getAnnotation(Documentable doc, string tag) {
  exists(string text |
    text = doc.getDocumentation().getComment().getText().regexpFind("[\\w]+:[\\w\\d.]+", _, _) and
    tag = text.regexpCapture("([\\w]+):.*", 1) and
    result = text.regexpCapture(".*:([\\w\\d.]+)", 1)
  )
}

/** A function annotated with `name:NAME` */
class AnnotatedFunction extends Function {
  string name;

  AnnotatedFunction() { name = getAnnotation(this, "name") }

  string getCalleeName() { result = name }
}

/** A function annotated with `calls:NAME` */
class AnnotatedCall extends DataFlow::Node {
  string calls;
  string kind;

  AnnotatedCall() {
    this instanceof DataFlow::InvokeNode and
    calls = getAnnotation(this.asExpr(), kind) and
    kind = "calls"
    or
    this instanceof DataFlow::PropRef and
    calls = getAnnotation(this.getAstNode(), kind) and
    kind = "callsAccessor"
  }

  string getCallTargetName() { result = calls }

  AnnotatedFunction getAnExpectedCallee(string kind_) {
    result.getCalleeName() = getCallTargetName() and
    kind = kind_
  }

  int getBoundArgs() { result = getAnnotation(this.getAstNode(), "boundArgs").toInt() }

  int getBoundArgsOrMinusOne() {
    result = getBoundArgs()
    or
    not exists(getBoundArgs()) and
    result = -1
  }

  string getKind() { result = kind }
}

predicate callEdge(AnnotatedCall call, AnnotatedFunction target, int boundArgs) {
  FlowSteps::calls(call, target) and boundArgs = -1
  or
  FlowSteps::callsBound(call, target, boundArgs)
}

query predicate spuriousCallee(
  AnnotatedCall call, AnnotatedFunction target, int boundArgs, string kind
) {
  callEdge(call, target, boundArgs) and
  kind = call.getKind() and
  not (
    target = call.getAnExpectedCallee(kind) and
    boundArgs = call.getBoundArgsOrMinusOne()
  )
}

query predicate missingCallee(
  AnnotatedCall call, AnnotatedFunction target, int boundArgs, string kind
) {
  not callEdge(call, target, boundArgs) and
  kind = call.getKind() and
  target = call.getAnExpectedCallee(kind) and
  boundArgs = call.getBoundArgsOrMinusOne()
}

query predicate badAnnotation(string name) {
  name = any(AnnotatedCall cl).getCallTargetName() and
  not name = any(AnnotatedFunction cl).getCalleeName() and
  name != "NONE"
  or
  not name = any(AnnotatedCall cl).getCallTargetName() and
  name = any(AnnotatedFunction cl).getCalleeName()
}

query predicate accessorCall(DataFlow::PropRef ref, Function target) {
  FlowSteps::calls(ref, target)
}
