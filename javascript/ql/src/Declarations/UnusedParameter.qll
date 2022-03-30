/**
 * Provides classes and predicates for the 'js/unused-parameter' query.
 *
 * In order to suppress alerts that are similar to the 'js/unused-parameter' alerts,
 * `isAnAccidentallyUnusedParameter` should be used since it holds iff that alert is active.
 */

import javascript

/**
 * Holds if `e` is an expression whose value is invoked as a function.
 */
private predicate isCallee(Expr e) {
  exists(InvokeExpr invk | e = invk.getCallee().getUnderlyingValue())
}

/**
 * Holds if `f` is never used as a higher-order function, that is, passed as an argument to
 * a function or assigned to a property.
 *
 * This predicate is deliberately conservative: it fails to hold for many functions that
 * are in fact first-order, but any function for which it does hold can safely be assumed
 * to be first-order (modulo `eval` and the usual corner cases).
 */
private predicate isFirstOrder(Function f) {
  // if `f` is itself an expression, it is invoked
  (f instanceof FunctionDeclStmt or isCallee(f)) and
  // all references to `f` are also invocations
  forall(VarAccess use | use = f.getVariable().getAnAccess() | isCallee(use))
}

/**
 * Holds if `p`, which is the `i`th parameter of `f`, is unused.
 */
predicate isUnused(Function f, Parameter p, Variable pv, int i) {
  p = f.getParameter(i) and
  pv = p.getAVariable() and
  // p is not accessed directly
  not exists(pv.getAnAccess()) and
  // nor could it be accessed through arguments
  not f.usesArgumentsObject() and
  // nor is it mentioned in a type
  not exists(LocalVarTypeAccess acc | acc.getVariable() = pv) and
  // functions without a body cannot use their parameters
  f.hasBody() and
  // field parameters are used to initialize a field
  not p instanceof FieldParameter and
  // common convention: parameters with leading underscore are intentionally unused
  pv.getName().charAt(0) != "_"
}

/**
 * Holds if it looks like parameter `p` is accidentally left unused.
 *
 * This is the full predicate used for the 'js/unused-parameter' query.
 */
predicate isAnAccidentallyUnusedParameter(Parameter p) {
  exists(Function f, Variable pv, int i |
    isUnused(f, p, pv, i) and
    (
      // either f is first-order (so its parameter list is easy to adjust), or
      isFirstOrder(f)
      or
      // p is a destructuring parameter, or
      not p instanceof SimpleParameter
      or
      // every later parameter is non-destructuring and also unused
      forall(Parameter q, int j | q = f.getParameter(j) and j > i |
        isUnused(f, q.(SimpleParameter), _, _)
      )
    ) and
    // f is not an extern
    not f.inExternsFile() and
    // and p is not documented as being unused
    not exists(JSDocParamTag parmdoc | parmdoc.getDocumentedParameter() = pv |
      parmdoc.getDescription().toLowerCase().matches("%unused%")
    ) and
    // and f is not marked as abstract
    not f.getDocumentation().getATag().getTitle() = "abstract" and
    // this case is checked by a different query
    not f.(FunctionExpr).isSetter() and
    // `p` isn't used in combination with a rest property pattern to filter out unwanted properties
    not exists(ObjectPattern op | exists(op.getRest()) |
      op.getAPropertyPattern().getValuePattern() = pv.getADeclaration()
    )
  )
}
