private import powershell
private import semmle.code.powershell.controlflow.internal.Scope
private import internal.Parameter::Private as Internal

private predicate isFunctionParameterImpl(Internal::Parameter p, Function f, int i) {
  function_definition_parameter(f, i, p)
}

private predicate hasParameterBlockImpl(Internal::Parameter p, ParamBlock block, int i) {
  param_block_parameter(block, i, p)
}

private predicate hasParameterBlockExcludingPipelinesImpl(
  Internal::Parameter p, ParamBlock block, int i
) {
  p =
    rank[i + 1](Internal::Parameter cand, int j |
      hasParameterBlockImpl(cand, block, j) and
      not cand.getAnAttribute().(Attribute).getANamedArgument() instanceof
        ValueFromPipelineAttribute and
      not cand.getAnAttribute().(Attribute).getANamedArgument() instanceof
        ValueFromPipelineByPropertyName
    |
      cand order by j
    )
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

private predicate isThisParameter(Scope scope, Type t) {
  t = scope.getEnclosingFunction().getDeclaringType()
}

private newtype TParameterImpl =
  TInternalParameter(Internal::Parameter p) or
  TUnderscore(Scope scope) {
    exists(VarAccess va | va.getUserPath() = ["_", "PSItem"] and scope = va.getEnclosingScope())
  } or
  TThisParameter(Scope scope) { isThisParameter(scope, _) }

private class ParameterImpl extends TParameterImpl {
  abstract Location getLocation();

  string toString() { result = this.getName() }

  abstract string getName();

  abstract Scope getEnclosingScope();

  predicate hasParameterBlock(ParamBlock block, int i) { none() }

  predicate hasParameterBlockExcludingPipelines(ParamBlock block, int i) { none() }

  predicate isFunctionParameter(Function f, int i) { none() }

  Expr getDefaultValue() { none() }

  abstract Attribute getAnAttribute();

  VarAccess getAnAccess() {
    // TODO: This won't join order nicely.
    result.getUserPath() = this.getName() and
    result.getEnclosingScope() = this.getEnclosingScope()
  }

  abstract predicate isPipeline();

  abstract predicate isPipelineByPropertyName();

  /**
   * Gets the static type of this parameter.
   * The type of this parameter at runtime may be a subtype of this static
   * type.
   */
  abstract string getStaticType();
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

  override predicate hasParameterBlockExcludingPipelines(ParamBlock block, int i) {
    hasParameterBlockExcludingPipelinesImpl(p, block, i)
  }

  override predicate isFunctionParameter(Function f, int i) { isFunctionParameterImpl(p, f, i) }

  override Expr getDefaultValue() { result = p.getDefaultValue() }

  override Attribute getAnAttribute() { result = p.getAnAttribute() }

  override predicate isPipeline() {
    this.getAnAttribute().getANamedArgument() instanceof ValueFromPipelineAttribute
  }

  override predicate isPipelineByPropertyName() {
    this.getAnAttribute().getANamedArgument() instanceof ValueFromPipelineByPropertyName
  }

  final override string getStaticType() { result = p.getStaticType() }
}

/**
 * The variable that represents an element in the pipeline.
 *
 * This is either the variable `$_` or the variable `$PSItem`.
 */
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

  final override Attribute getAnAttribute() { none() }

  final override predicate isPipeline() { any() }

  final override predicate isPipelineByPropertyName() { none() }

  final override predicate isFunctionParameter(Function f, int i) { f.getBody() = scope and i = -1 }

  final override string getStaticType() { none() }
}

private class ThisParameter extends ParameterImpl, TThisParameter {
  Scope scope;

  ThisParameter() { this = TThisParameter(scope) }

  override Location getLocation() { result = scope.getLocation() }

  override string getName() { result = "this" }

  final override Scope getEnclosingScope() { result = scope }

  final override Attribute getAnAttribute() { none() }

  final override predicate isPipeline() { none() }

  final override predicate isPipelineByPropertyName() { none() }

  final override string getStaticType() {
    exists(Type t |
      isThisParameter(scope, t) and
      result = t.getName()
    )
  }
}

private predicate isPipelineIteratorVariable(ParameterImpl p, ProcessBlock pb) {
  p.isPipeline() and
  pb.getEnclosingScope() = p.getEnclosingScope()
}

private predicate isPipelineByPropertyNameIteratorVariable(ParameterImpl p, ProcessBlock pb) {
  p.isPipelineByPropertyName() and
  pb.getEnclosingScope() = p.getEnclosingScope()
}

private newtype TVariable =
  TLocalVariable(string name, Scope scope) {
    not isParameterImpl(name, scope) and
    not name = "this" and // This is modeled as a parameter
    exists(VarAccess va | va.getUserPath() = name and scope = va.getEnclosingScope())
  } or
  TParameter(ParameterImpl p) or
  TPipelineIteratorVariable(ProcessBlock pb) { isPipelineIteratorVariable(_, pb) } or
  TPipelineByPropertyNameIteratorVariable(ParameterImpl p) {
    isPipelineByPropertyNameIteratorVariable(p, _)
  }

private class AbstractVariable extends TVariable {
  abstract Location getLocation();

  string toString() { result = this.getName() }

  abstract string getName();

  final predicate hasName(string s) { this.getName() = s }

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

  final predicate hasName(string name) { name = p.getName() }

  final override Scope getDeclaringScope() { result = p.getEnclosingScope() }

  predicate hasParameterBlock(ParamBlock block, int i) { p.hasParameterBlock(block, i) }

  predicate hasParameterBlockExcludingPipelines(ParamBlock block, int i) {
    p.hasParameterBlockExcludingPipelines(block, i)
  }

  predicate isFunctionParameter(Function f, int i) { p.isFunctionParameter(f, i) }

  Expr getDefaultValue() { result = p.getDefaultValue() }

  predicate hasDefaultValue() { exists(this.getDefaultValue()) }

  /** Holds if this is the `this` parameter. */
  predicate isThis() { p instanceof ThisParameter }

  /**
   * Gets the index of this parameter, if any.
   *
   * The parameter may be in a parameter block or a function parameter.
   */
  int getIndex() { result = this.getFunctionIndex() or result = this.getBlockIndex() }

  int getIndexExcludingPipelines() {
    result = this.getFunctionIndex() or result = this.getBlockIndexExcludingPipelines()
  }

  /** Gets the index of this parameter in the parameter block, if any. */
  int getBlockIndex() { this.hasParameterBlock(_, result) }

  int getBlockIndexExcludingPipelines() { this.hasParameterBlockExcludingPipelines(_, result) }

  /** Gets the index of this parameter in the function, if any. */
  int getFunctionIndex() { this.isFunctionParameter(_, result) }

  Function getFunction() { result.getBody() = this.getDeclaringScope() }

  Attribute getAnAttribute() { result = p.getAnAttribute() }

  predicate isPipeline() { p.isPipeline() }

  predicate isPipelineByPropertyName() { p.isPipelineByPropertyName() }

  string getStaticType() { result = p.getStaticType() }
}

class PipelineParameter extends Parameter {
  PipelineParameter() { this.isPipeline() }

  PipelineIteratorVariable getIteratorVariable() {
    result.getProcessBlock().getEnclosingScope() = p.getEnclosingScope()
  }
}

class PipelineByPropertyNameParameter extends Parameter {
  PipelineByPropertyNameParameter() { this.isPipelineByPropertyName() }

  PipelineByPropertyNameIteratorVariable getIteratorVariable() { result.getParameter() = this }
}

/**
 * The variable that represents the value of a pipeline during a process block.
 *
 * That is, it is _not_ the `ValueFromPipeline` variable, but the value that is obtained by reading
 * from the pipeline.
 */
class PipelineIteratorVariable extends AbstractLocalScopeVariable, TPipelineIteratorVariable {
  private ProcessBlock pb;

  PipelineIteratorVariable() { this = TPipelineIteratorVariable(pb) }

  override Location getLocation() { result = pb.getLocation() }

  override string getName() { result = "pipeline iterator for " + pb.toString() }

  final override Scope getDeclaringScope() { result = pb.getEnclosingScope() }

  ProcessBlock getProcessBlock() { result = pb }
}

/**
 * The variable that represents the value of a pipeline that picks out a
 * property specific property during a process block.
 *
 * That is, it is _not_ the `PipelineByPropertyName` variable, but the value that is obtained by reading
 * from the pipeline.
 */
class PipelineByPropertyNameIteratorVariable extends AbstractLocalScopeVariable,
  TPipelineByPropertyNameIteratorVariable
{
  private ParameterImpl p;

  PipelineByPropertyNameIteratorVariable() { this = TPipelineByPropertyNameIteratorVariable(p) }

  override Location getLocation() { result = p.getLocation() }

  override string getName() { result = "pipeline iterator for " + p.toString() }

  final override Scope getDeclaringScope() { result = p.getEnclosingScope() }

  Parameter getParameter() { result = TParameter(p) }

  ProcessBlock getProcessBlock() { isPipelineByPropertyNameIteratorVariable(p, result) }
}
