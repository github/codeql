/**
 * Provides implementation classes  modeling various methods of deallocation
 * (`free`, `delete` etc). See `semmle.code.cpp.models.interfaces.Deallocation`
 * for usage information.
 */

import semmle.code.cpp.models.interfaces.Deallocation

/**
 * Holds if `f` is an deallocation function according to the
 * extensible `deallocationFunctionModel` predicate.
 */
private predicate isDeallocationFunctionFromModel(
  Function f, string namespace, string type, string name
) {
  exists(boolean subtypes | deallocationFunctionModel(namespace, type, subtypes, name, _) |
    if type = ""
    then f.hasQualifiedName(namespace, "", name)
    else
      exists(Class c |
        c.hasQualifiedName(namespace, type) and f.hasQualifiedName(namespace, _, name)
      |
        if subtypes = true
        then f = c.getADerivedClass*().getAMemberFunction()
        else f = c.getAMemberFunction()
      )
  )
}

/**
 * A deallocation function modeled via the extensible `deallocationFunctionModel` predicate.
 */
private class DeallocationFunctionFromModel extends DeallocationFunction {
  string namespace;
  string type;
  string name;

  DeallocationFunctionFromModel() { isDeallocationFunctionFromModel(this, namespace, type, name) }

  final override int getFreedArg() {
    exists(string freedArg |
      deallocationFunctionModel(namespace, type, _, name, freedArg) and
      result = freedArg.toInt()
    )
  }
}

/**
 * An deallocation expression that is a function call, such as call to `free`.
 */
private class CallDeallocationExpr extends DeallocationExpr, FunctionCall {
  DeallocationFunction target;

  CallDeallocationExpr() { target = this.getTarget() }

  override Expr getFreedExpr() { result = this.getArgument(target.getFreedArg()) }
}

/**
 * An deallocation expression that is a `delete` expression.
 */
private class DeleteDeallocationExpr extends DeallocationExpr, DeleteExpr {
  DeleteDeallocationExpr() { this instanceof DeleteExpr }

  override Expr getFreedExpr() { result = this.getExpr() }
}

/**
 * An deallocation expression that is a `delete []` expression.
 */
private class DeleteArrayDeallocationExpr extends DeallocationExpr, DeleteArrayExpr {
  DeleteArrayDeallocationExpr() { this instanceof DeleteArrayExpr }

  override Expr getFreedExpr() { result = this.getExpr() }
}
