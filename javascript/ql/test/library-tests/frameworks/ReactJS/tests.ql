import javascript
import semmle.javascript.frameworks.React

query predicate test_getADirectStateAccess(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectStateAccess()
}

query predicate test_ReactComponent_getInstanceMethod(ReactComponent c, string n, Function res) {
  res = c.getInstanceMethod(n)
}

query predicate test_react(DataFlow::ValueNode nd) { react().flowsTo(nd) }

query predicate test_ReactComponent_getAPreviousStateSource(
  ReactComponent c, DataFlow::SourceNode res
) {
  res = c.getAPreviousStateSource()
}

query predicate test_ReactComponent_ref(ReactComponent c, DataFlow::Node res) { res = c.ref() }

query predicate test_ReactComponent_getACandidateStateSource(
  ReactComponent c, DataFlow::SourceNode res
) {
  res = c.getACandidateStateSource()
}

query predicate test_ReactComponent_getADirectPropsSource(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectPropsAccess()
}

query predicate test_ReactComponent_getACandidatePropsValue(DataFlow::Node res) {
  exists(ReactComponent c | res = c.getACandidatePropsValue(_))
}

query predicate test_ReactComponent(ReactComponent c) { any() }

query predicate test_ReactComponent_getAPropRead(ReactComponent c, string n, DataFlow::PropRead res) {
  res = c.getAPropRead(n)
}

query predicate test_JSXname(JsxElement element, JsxName jsxname, string name, string type) {
  name = jsxname.getValue() and
  (
    jsxname instanceof Identifier and type = "Identifier"
    or
    jsxname instanceof ThisExpr and type = "thisExpr"
    or
    jsxname.(DotExpr).getBase() instanceof JsxName and type = "dot"
    or
    jsxname instanceof JsxQualifiedName and type = "qualifiedName"
  ) and
  element.getNameExpr() = jsxname
}

query ThisExpr test_JsxName_this(JsxElement element) { result.getParentExpr+() = element }

query DataFlow::SourceNode locationSource() { result = DOM::locationSource() }

query predicate threatModelSource(ThreatModelSource source, string kind) {
  kind = source.getThreatModel()
}
