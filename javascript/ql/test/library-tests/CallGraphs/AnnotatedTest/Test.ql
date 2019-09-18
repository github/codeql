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
}

query predicate spuriousCallee(AnnotatedCall call, AnnotatedFunction target) {
  FlowSteps::calls(call.flow(), target) and
  not target = call.getAnExpectedCallee()
}

query predicate missingCallee(AnnotatedCall call, AnnotatedFunction target) {
  not FlowSteps::calls(call.flow(), target) and
  target = call.getAnExpectedCallee()
}

query predicate badAnnotation(string name) {
  name = any(AnnotatedCall cl).getCallTargetName() and
  not name = any(AnnotatedFunction cl).getCalleeName()
  or
  not name = any(AnnotatedCall cl).getCallTargetName() and
  name = any(AnnotatedFunction cl).getCalleeName()
}
