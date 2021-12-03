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
class AnnotatedCall extends InvokeExpr {
  string calls;

  AnnotatedCall() { calls = getAnnotation(this, "calls") }

  string getCallTargetName() { result = calls }

  AnnotatedFunction getAnExpectedCallee() { result.getCalleeName() = getCallTargetName() }

  int getBoundArgs() { result = getAnnotation(this, "boundArgs").toInt() }

  int getBoundArgsOrMinusOne() {
    result = getBoundArgs()
    or
    not exists(getBoundArgs()) and
    result = -1
  }
}

predicate callEdge(AnnotatedCall call, AnnotatedFunction target, int boundArgs) {
  FlowSteps::calls(call.flow(), target) and boundArgs = -1
  or
  FlowSteps::callsBound(call.flow(), target, boundArgs)
}

query predicate spuriousCallee(AnnotatedCall call, AnnotatedFunction target, int boundArgs) {
  callEdge(call, target, boundArgs) and
  not (
    target = call.getAnExpectedCallee() and
    boundArgs = call.getBoundArgsOrMinusOne()
  )
}

query predicate missingCallee(AnnotatedCall call, AnnotatedFunction target, int boundArgs) {
  not callEdge(call, target, boundArgs) and
  target = call.getAnExpectedCallee() and
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
