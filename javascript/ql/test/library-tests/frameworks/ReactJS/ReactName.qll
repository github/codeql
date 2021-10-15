import semmle.javascript.frameworks.React

query predicate test_JSXname(JSXElement element, JSXName jsxname, string name, string type) {
  name = jsxname.getValue() and
  (
    jsxname instanceof Identifier and type = "Identifier"
    or
    jsxname instanceof ThisExpr and type = "thisExpr"
    or
    jsxname.(DotExpr).getBase() instanceof JSXName and type = "dot"
    or
    jsxname instanceof JSXQualifiedName and type = "qualifiedName"
  ) and
  element.getNameExpr() = jsxname
}

query ThisExpr test_JSXName_this(JSXElement element) { result.getParentExpr+() = element }
