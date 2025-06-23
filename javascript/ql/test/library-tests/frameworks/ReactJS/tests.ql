import javascript
import semmle.javascript.frameworks.React

query predicate getADirectStateAccess(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectStateAccess()
}

query predicate getInstanceMethod(ReactComponent c, string n, Function res) {
  res = c.getInstanceMethod(n)
}

query predicate getAPreviousStateSource(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getAPreviousStateSource()
}

query predicate reactComponentRef(ReactComponent c, DataFlow::Node res) { res = c.ref() }

query predicate getACandidateStateSource(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getACandidateStateSource()
}

query predicate getADirectPropsSource(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectPropsAccess()
}

query predicate getACandidatePropsValue(DataFlow::Node res) {
  exists(ReactComponent c | res = c.getACandidatePropsValue(_))
}

query predicate reactComponent(ReactComponent c) { any() }

query predicate getAPropRead(ReactComponent c, string n, DataFlow::PropRead res) {
  res = c.getAPropRead(n)
}

query predicate jsxName(JsxElement element, JsxName jsxname, string name, string type) {
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

query ThisExpr jsxNameThis(JsxElement element) { result.getParentExpr+() = element }

query DataFlow::SourceNode locationSource() { result = DOM::locationSource() }

query predicate threatModelSource(ThreatModelSource source, string kind) {
  kind = source.getThreatModel()
}
