import semmle.javascript.frameworks.React

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
