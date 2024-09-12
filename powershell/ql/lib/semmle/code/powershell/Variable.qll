private import powershell
private import semmle.code.powershell.controlflow.internal.Scope
private import internal.Internal as Internal

bindingset[scope]
pragma[inline_late]
private predicate isParameterImpl(string name, Scope scope) {
  exists(Internal::Parameter p | p.getName() = name and p.getEnclosingScope() = scope)
  or
  name = "_"
}

private newtype TParameterImpl =
  TInternalParameter(Internal::Parameter p) or
  TUnderscore(Scope scope) {
    exists(VarAccess va | va.getUserPath() = "_" and scope = va.getEnclosingScope())
  }

private class ParameterImpl extends TParameterImpl {
  abstract Location getLocation();

  string toString() { result = this.getName() }

  abstract string getName();

  abstract Scope getEnclosingScope();

  predicate hasParameterBlock(ParamBlock block, int i) { none() }

  predicate isFunctionParameter(Function f, int i) { none() }

  Expr getDefaultValue() { none() }

  VarAccess getAnAccess() {
    // TODO: This won't join order nicely.
    result.getUserPath() = this.getName() and
    result.getEnclosingScope() = this.getEnclosingScope()
  }
}

private class InternalParameter extends ParameterImpl, TInternalParameter {
  Internal::Parameter p;

  InternalParameter() { this = TInternalParameter(p) }

  override Location getLocation() { result = p.getLocation() }

  override string getName() { result = p.getName() }

  final override Scope getEnclosingScope() { result = p.getEnclosingScope() }

  override predicate hasParameterBlock(ParamBlock block, int i) {
    param_block_parameter(block, i, p)
  }

  override predicate isFunctionParameter(Function f, int i) {
    function_definition_parameter(f, i, p)
    or
    function_member_parameter(f, i, p)
  }

  override Expr getDefaultValue() { result = p.getDefaultValue() }
}

private class Underscore extends ParameterImpl, TUnderscore {
  Scope scope;

  Underscore() { this = TUnderscore(scope) }

  override Location getLocation() {
    // The location is the first access (ordered by location) to the variable in the scope
    exists(VarAccess va |
      va =
        min(VarAccess cand, Location location |
          cand = this.getAnAccess() and location = cand.getLocation()
        |
          cand order by location.getStartLine(), location.getStartColumn()
        ) and
      result = va.getLocation()
    )
  }

  override string getName() { result = "_" }

  final override Scope getEnclosingScope() { result = scope }
}

private newtype TVariable =
  TLocalVariable(string name, Scope scope) {
    not isParameterImpl(name, scope) and
    exists(VarAccess va | va.getUserPath() = name and scope = va.getEnclosingScope())
  } or
  TParameter(ParameterImpl p)

private class AbstractVariable extends TVariable {
  abstract Location getLocation();

  string toString() { result = this.getName() }

  abstract string getName();

  abstract Scope getDeclaringScope();

  VarAccess getAnAccess() {
    exists(string s |
      s = concat(this.getAQlClass(), ", ") and
      // TODO: This won't join order nicely.
      result.getUserPath() = this.getName() and
      result.getEnclosingScope() = this.getDeclaringScope()
    )
  }
}

class LocalVariable extends AbstractVariable, TLocalVariable {
  string name;
  Scope scope;

  LocalVariable() { this = TLocalVariable(name, scope) }

  override Location getLocation() {
    // The location is the first access (ordered by location) to the variable in the scope
    exists(VarAccess va |
      va =
        min(VarAccess cand, Location location |
          cand = this.getAnAccess() and location = cand.getLocation()
        |
          cand order by location.getStartLine(), location.getStartColumn()
        ) and
      result = va.getLocation()
    )
  }

  override string getName() { result = name }

  final override Scope getDeclaringScope() { result = scope }
}

class Parameter extends AbstractVariable, TParameter {
  ParameterImpl p;

  Parameter() { this = TParameter(p) }

  override Location getLocation() { result = p.getLocation() }

  override string getName() { result = p.getName() }

  final override Scope getDeclaringScope() { result = p.getEnclosingScope() }

  predicate hasParameterBlock(ParamBlock block, int i) { p.hasParameterBlock(block, i) }

  predicate isFunctionParameter(Function f, int i) { p.isFunctionParameter(f, i) }

  Expr getDefaultValue() { result = p.getDefaultValue() }

  predicate hasDefaultValue() { exists(this.getDefaultValue()) }

  int getIndex() { this.isFunctionParameter(_, result) }
}

final class Variable = AbstractVariable;
