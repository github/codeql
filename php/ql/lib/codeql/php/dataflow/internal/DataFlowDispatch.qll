/**
 * Provides PHP-specific data flow dispatch logic.
 */

private import codeql.php.AST
private import DataFlowPrivate

newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  abstract string toString();
}

/** A normal return (via `return` statement or expression body). */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

newtype TDataFlowCallable =
  TCallable(Callable c) or
  TProgram(Program p)

/** A callable (function, method, closure, arrow function, or file-level program). */
class DataFlowCallable extends TDataFlowCallable {
  Callable asCallable() { this = TCallable(result) }

  Program asProgram() { this = TProgram(result) }

  string toString() {
    result = this.asCallable().toString()
    or
    result = this.asProgram().toString()
  }

  Location getLocation() {
    result = this.asCallable().getLocation()
    or
    result = this.asProgram().getLocation()
  }
}

newtype TDataFlowCall = TNormalCall(Call call)

/** A data flow call. */
class DataFlowCall extends TDataFlowCall {
  Call call;

  DataFlowCall() { this = TNormalCall(call) }

  Call asCall() { result = call }

  DataFlowCallable getEnclosingCallable() {
    result.asCallable() = call.getParent*().(Callable)
    or
    not call.getParent*() instanceof Callable and
    result.asProgram() = call.getParent*().(Program)
  }

  string toString() { result = call.toString() }

  Location getLocation() { result = call.getLocation() }
}

/**
 * Gets a viable callable for the call `c`.
 *
 * Resolves function calls by name, method calls by class hierarchy analysis,
 * and static calls by class scope.
 */
DataFlowCallable viableCallable(DataFlowCall c) {
  // Function call: resolve by name
  exists(FunctionCallExpr fce, FunctionDef fd |
    fce = c.asCall() and
    fd.getNameString() = fce.getFunctionName() and
    result = TCallable(fd)
  )
  or
  // Method call ($obj->method(...)): resolve by method name across all classes
  exists(MethodCallExpr mce, MethodDecl md |
    mce = c.asCall() and
    md.getNameString() = mce.getMethodNameString() and
    // If we can determine the class of the receiver, restrict to that class hierarchy
    (
      // $this->method(): resolve to methods in the enclosing class and its parents
      mce.getObject().(VariableName).getValue() = "$this" and
      exists(ClassDecl cd |
        mce.getParent*() = cd and
        md = getMethodInClassHierarchy(cd, mce.getMethodNameString())
      )
      or
      // For other receivers, conservatively resolve by method name
      not mce.getObject().(VariableName).getValue() = "$this" and
      md.getNameString() = mce.getMethodNameString()
    ) and
    result = TCallable(md)
  )
  or
  // Nullsafe method call ($obj?->method(...)): same as method call
  exists(NullsafeMethodCallExpr mce, MethodDecl md |
    mce = c.asCall() and
    md.getNameString() = mce.getMethodNameString() and
    result = TCallable(md)
  )
  or
  // Scoped (static) call (ClassName::method(...)): resolve by scope and name
  exists(ScopedCallExpr sce, MethodDecl md |
    sce = c.asCall() and
    md.getNameString() = sce.getMethodNameString() and
    (
      // Direct class name resolution
      exists(ClassDecl cd |
        resolveClassName(sce.getScope()) = cd.getNameString() and
        md = getMethodInClassHierarchy(cd, sce.getMethodNameString())
      )
      or
      // self/static/parent - resolve from enclosing class
      exists(ClassDecl enclosing, string scopeName |
        sce.getParent*() = enclosing and
        scopeName = resolveScopeName(sce.getScope()) and
        (
          scopeName = ["self", "static"] and
          md = getMethodInClassHierarchy(enclosing, sce.getMethodNameString())
          or
          scopeName = "parent" and
          exists(ClassDecl parent |
            getBaseClassName(enclosing) = parent.getNameString() and
            md = getMethodInClassHierarchy(parent, sce.getMethodNameString())
          )
        )
      )
      or
      // Fallback: just match by method name
      not exists(resolveClassName(sce.getScope())) and
      not exists(resolveScopeName(sce.getScope())) and
      md.getNameString() = sce.getMethodNameString()
    ) and
    result = TCallable(md)
  )
}

/**
 * Gets the string class name from a scope expression, if it is a simple name.
 */
private string resolveClassName(AstNode scope) {
  result = scope.(Name).getValue() and
  not result = ["self", "static", "parent"]
  or
  result = scope.(QualifiedName).getValue() and
  not result = ["self", "static", "parent"]
}

/**
 * Gets a special scope keyword (self/static/parent) from a scope expression.
 */
private string resolveScopeName(AstNode scope) {
  result = scope.(Name).getValue() and
  result = ["self", "static", "parent"]
}

/**
 * Gets the base class name for `cd` (the class it extends).
 */
private string getBaseClassName(ClassDecl cd) {
  exists(BaseClause bc |
    bc = cd.getBaseClause() and
    result = bc.getChild(0).(Name).getValue()
    or
    bc = cd.getBaseClause() and
    result = bc.getChild(0).(QualifiedName).getValue()
  )
}

/**
 * Gets a method named `methodName` that is declared in `cd` or one of its
 * ancestor classes.
 */
private MethodDecl getMethodInClassHierarchy(ClassDecl cd, string methodName) {
  // Direct declaration
  exists(DeclarationList body |
    body = cd.getBody() and
    result = body.getAMember() and
    result.getNameString() = methodName
  )
  or
  // Inherited from parent
  exists(ClassDecl parent |
    getBaseClassName(cd) = parent.getNameString() and
    result = getMethodInClassHierarchy(parent, methodName) and
    // Only inherit if not overridden in cd
    not exists(MethodDecl override |
      override = cd.getBody().getAMember() and
      override.getNameString() = methodName
    )
  )
}

predicate mayBenefitFromCallContext(DataFlowCall call) { none() }

DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

newtype TParameterPosition = TPositionalParameterPosition(int i) { i in [0 .. 20] }

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  int pos;

  ParameterPosition() { this = TPositionalParameterPosition(pos) }

  int asPositional() { result = pos }

  string toString() { result = pos.toString() }
}

newtype TArgumentPosition = TPositionalArgumentPosition(int i) { i in [0 .. 20] }

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  int pos;

  ArgumentPosition() { this = TPositionalArgumentPosition(pos) }

  int asPositional() { result = pos }

  string toString() { result = pos.toString() }
}

predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.asPositional() = apos.asPositional()
}
