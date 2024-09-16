private import powershell
private import semmle.code.powershell.controlflow.internal.Scope
private import internal.Internal as Internal

private predicate isFunctionParameterImpl(Internal::Parameter p, Function f, int i) {
  function_definition_parameter(f, i, p)
  or
  function_member_parameter(f, i, p)
}

private predicate hasParameterBlockImpl(Internal::Parameter p, ParamBlock block, int i) {
  param_block_parameter(block, i, p)
}

/**
 * Gets the enclosing scope of `p`.
 * 
 * For a function parameter, this is the function body. For a parameter from a
 * parameter block, this is the enclosing scope of the parameter block.
 * 
 * In both of the above cases, the enclosing scope is the function body.
 */
private Scope getEnclosingScopeImpl(Internal::Parameter p) {
  exists(Function f |
    isFunctionParameterImpl(p, f, _) and
    result = f.getBody()
  )
  or
  exists(ParamBlock b |
    hasParameterBlockImpl(p, b, _) and
    result = b.getEnclosingScope()
  )
}

bindingset[scope]
pragma[inline_late]
private predicate isParameterImpl(string name, Scope scope) {
  exists(Internal::Parameter p | p.getName() = name and getEnclosingScopeImpl(p) = scope)
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

  final override Scope getEnclosingScope() { result = getEnclosingScopeImpl(p) }

  override predicate hasParameterBlock(ParamBlock block, int i) {
    hasParameterBlockImpl(p, block, i)
  }

  override predicate isFunctionParameter(Function f, int i) { isFunctionParameterImpl(p, f, i) }

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

final class Variable = AbstractVariable;

abstract class AbstractLocalScopeVariable extends AbstractVariable { }

final class LocalScopeVariable = AbstractLocalScopeVariable;

class LocalVariable extends AbstractLocalScopeVariable, TLocalVariable {
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

class Parameter extends AbstractLocalScopeVariable, TParameter {
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

  Function getFunction() { result.getBody() = this.getDeclaringScope() }
}
