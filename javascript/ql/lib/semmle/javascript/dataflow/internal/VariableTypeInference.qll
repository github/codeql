/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides classes implementing type inference for variables.
 */

private import javascript
private import AbstractValuesImpl
private import AnalyzedParameters
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.Refinements

/**
 * Flow analysis for captured variables.
 */
private class AnalyzedCapturedVariable extends @variable {
  AnalyzedCapturedVariable() { this.(LocalVariable).isCaptured() }

  /**
   * Gets an abstract value that may be assigned to this variable.
   */
  pragma[nomagic]
  AbstractValue getALocalValue() { result = this.getADef().getAnAssignedValue() }

  /**
   * Gets a definition of this variable.
   */
  AnalyzedVarDef getADef() { this = result.getAVariable() }

  /** Gets a textual representation of this element. */
  string toString() { result = this.(Variable).toString() }
}

/**
 * Flow analysis for SSA nodes.
 */
private class AnalyzedSsaDefinitionNode extends AnalyzedNode, DataFlow::SsaDefinitionNode {
  override AbstractValue getALocalValue() { result = ssa.(AnalyzedSsaDefinition).getAnRhsValue() }
}

/**
 * An SSA definition whose right-hand side is a call with non-local data flow.
 */
private class SsaDefinitionWithNonLocalFlow extends SsaExplicitDefinition {
  CallWithNonLocalAnalyzedReturnFlow source;

  SsaDefinitionWithNonLocalFlow() { source = this.getDef().getSource().flow() }

  CallWithNonLocalAnalyzedReturnFlow getSource() { result = source }
}

/**
 * Flow analysis for SSA nodes corresponding to `SsaDefinitionWithNonLocalFlow`.
 */
private class AnalyzedSsaDefinitionNodeWithNonLocalAnalysis extends AnalyzedSsaDefinitionNode {
  override SsaDefinitionWithNonLocalFlow ssa;

  override AbstractValue getAValue() { result = ssa.getSource().getAValue() }
}

/**
 * Flow analysis for uses of an SSA variable corresponding to `SsaDefinitionWithNonLocalFlow`.
 */
private class AnalyzedSsaVariableUseWithNonLocalFlow extends AnalyzedValueNode {
  SsaDefinitionWithNonLocalFlow ssaDef;

  AnalyzedSsaVariableUseWithNonLocalFlow() {
    this = DataFlow::valueNode(ssaDef.getVariable().getAUse())
  }

  override AbstractValue getAValue() {
    // Block indefinite values coming from getALocalValue()
    result = ssaDef.getSource().getAValue()
  }
}

/**
 * A vardef with helper predicates for flow analysis.
 */
class AnalyzedVarDef extends VarDef {
  /**
   * Gets an abstract value that this variable definition may assign
   * to its target, including indefinite values if this definition
   * cannot be analyzed completely.
   */
  AbstractValue getAnAssignedValue() {
    result = this.getAnRhsValue()
    or
    exists(DataFlow::Incompleteness cause |
      this.isIncomplete(cause) and result = TIndefiniteAbstractValue(cause)
    )
  }

  /**
   * Gets an abstract value that the right hand side of this `VarDef`
   * may evaluate to.
   */
  AbstractValue getAnRhsValue() {
    result = this.getRhs().getALocalValue()
    or
    this = any(ForInStmt fis).getIteratorExpr() and result = abstractValueOfType(TTString())
    or
    this = any(EnumMember member | not exists(member.getInitializer())).getIdentifier() and
    result = abstractValueOfType(TTNumber())
  }

  /**
   * Gets a node representing the value of the right hand side of
   * this `VarDef`.
   */
  DataFlow::AnalyzedNode getRhs() {
    result = this.getSource().analyze() and this.getTarget() instanceof VarRef
    or
    result.asExpr() = this.(CompoundAssignExpr)
    or
    result.asExpr() = this.(UpdateExpr)
  }

  /**
   * Holds if flow analysis results for this node may be incomplete
   * due to the given `cause`.
   */
  predicate isIncomplete(DataFlow::Incompleteness cause) {
    this instanceof Parameter and DataFlow::valueNode(this).(AnalyzedValueNode).isIncomplete(cause)
    or
    this instanceof ImportSpecifier and cause = "import"
    or
    exists(EnhancedForLoop efl | efl instanceof ForOfStmt or efl instanceof ForEachStmt |
      this = efl.getIteratorExpr()
    ) and
    cause = "heap"
    or
    exists(ComprehensionBlock cb | this = cb.getIterator()) and cause = "yield"
    or
    this.getTarget() instanceof DestructuringPattern and cause = "heap"
  }

  /**
   * Gets the toplevel syntactic unit to which this definition belongs.
   */
  TopLevel getTopLevel() { result = this.(AstNode).getTopLevel() }
}

/**
 * Flow analysis for simple parameters of selected functions.
 */
private class AnalyzedParameterAsVarDef extends AnalyzedVarDef, @var_decl instanceof Parameter {
  override AbstractValue getAnRhsValue() {
    result = DataFlow::valueNode(this).(AnalyzedValueNode).getALocalValue()
  }
}

/**
 * Flow analysis for simple rest parameters.
 */
private class AnalyzedRestParameter extends AnalyzedValueNode {
  AnalyzedRestParameter() { astNode.(Parameter).isRestParameter() }

  override AbstractValue getALocalValue() { result = TAbstractOtherObject() }
}

/**
 * Flow analysis for `module` and `exports` parameters of AMD modules.
 */
private class AnalyzedAmdParameter extends AnalyzedVarDef {
  AbstractValue implicitInitVal;

  AnalyzedAmdParameter() {
    exists(AmdModule m, AmdModuleDefinition mdef | mdef = m.getDefine() |
      this = mdef.getModuleParameter() and
      implicitInitVal = TAbstractModuleObject(m)
      or
      this = mdef.getExportsParameter() and
      implicitInitVal = TAbstractExportsObject(m)
    )
  }

  override AbstractValue getAnAssignedValue() {
    result = super.getAnAssignedValue() or
    result = implicitInitVal
  }
}

/**
 * An SSA definitions that has been analyzed.
 */
abstract class AnalyzedSsaDefinition extends SsaDefinition {
  /**
   * Gets an abstract value that the right hand side of this definition
   * may evaluate to at runtime.
   */
  abstract AbstractValue getAnRhsValue();
}

/**
 * Flow analysis for SSA definitions corresponding to `VarDef`s.
 */
private class AnalyzedExplicitDefinition extends AnalyzedSsaDefinition, SsaExplicitDefinition {
  override AbstractValue getAnRhsValue() {
    result = this.getDef().(AnalyzedVarDef).getAnAssignedValue()
    or
    result = this.getRhsNode().analyze().getALocalValue()
  }
}

/**
 * Flow analysis for SSA definitions corresponding to implicit variable initialization.
 */
private class AnalyzedImplicitInit extends AnalyzedSsaDefinition, SsaImplicitInit {
  override AbstractValue getAnRhsValue() { result = getImplicitInitValue(this.getSourceVariable()) }
}

/**
 * Flow analysis for SSA definitions corresponding to implicit variable capture.
 */
private class AnalyzedVariableCapture extends AnalyzedSsaDefinition, SsaVariableCapture {
  override AbstractValue getAnRhsValue() {
    exists(LocalVariable v | v = this.getSourceVariable() |
      result = v.(AnalyzedCapturedVariable).getALocalValue()
      or
      result = any(AnalyzedExplicitDefinition def | def.getSourceVariable() = v).getAnRhsValue()
      or
      not guaranteedToBeInitialized(v) and result = getImplicitInitValue(v)
    )
  }
}

/**
 * Flow analysis for SSA phi nodes.
 */
private class AnalyzedPhiNode extends AnalyzedSsaDefinition, SsaPhiNode {
  override AbstractValue getAnRhsValue() {
    result = this.getAnInput().(AnalyzedSsaDefinition).getAnRhsValue()
  }
}

/**
 * An analyzed refinement node.
 */
class AnalyzedRefinement extends AnalyzedSsaDefinition, SsaRefinementNode {
  override AbstractValue getAnRhsValue() {
    // default implementation: don't refine
    result = this.getAnInputRhsValue()
  }

  /**
   * Gets an abstract value that one of the inputs of this refinement may evaluate to.
   */
  AbstractValue getAnInputRhsValue() {
    result = this.getAnInput().(AnalyzedSsaDefinition).getAnRhsValue()
  }
}

/**
 * A refinement node where the guard is a condition.
 *
 * For such nodes, we want to split any indefinite abstract values flowing into the node
 * into sets of more precise abstract values to enable them to be refined.
 */
class AnalyzedConditionGuard extends AnalyzedRefinement {
  AnalyzedConditionGuard() { this.getGuard() instanceof ConditionGuardNode }

  override AbstractValue getAnInputRhsValue() {
    exists(AbstractValue input | input = super.getAnInputRhsValue() |
      result = input.(IndefiniteAbstractValue).split()
      or
      not input instanceof IndefiniteAbstractValue and result = input
    )
  }
}

/**
 * A refinement for a condition guard with an outcome of `true`.
 *
 * For example, in `if(x) s; else t;`, this will restrict the possible values of `x` at
 * the beginning of `s` to those that are truthy.
 */
class AnalyzedPositiveConditionGuard extends AnalyzedRefinement {
  AnalyzedPositiveConditionGuard() { this.getGuard().(ConditionGuardNode).getOutcome() = true }

  override AbstractValue getAnRhsValue() {
    result = this.getAnInputRhsValue() and
    exists(RefinementContext ctxt |
      ctxt = TVarRefinementContext(this, this.getSourceVariable(), result) and
      this.getRefinement().eval(ctxt).getABooleanValue() = true
    )
  }
}

/**
 * A refinement for a condition guard with an outcome of `false`.
 *
 * For example, in `if(x) s; else t;`, this will restrict the possible values of `x` at
 * the beginning of `t` to those that are falsy.
 */
class AnalyzedNegativeConditionGuard extends AnalyzedRefinement {
  AnalyzedNegativeConditionGuard() { this.getGuard().(ConditionGuardNode).getOutcome() = false }

  override AbstractValue getAnRhsValue() {
    result = this.getAnInputRhsValue() and
    exists(RefinementContext ctxt |
      ctxt = TVarRefinementContext(this, this.getSourceVariable(), result) and
      this.getRefinement().eval(ctxt).getABooleanValue() = false
    )
  }
}

/** Holds if `v` is a variable in an Angular template. */
private predicate isAngularTemplateVariable(LocalVariable v) {
  v = any(Angular2::TemplateTopLevel tl).getScope().getAVariable()
}

/**
 * Gets the abstract value representing the initial value of variable `v`.
 *
 * Most variables are implicitly initialized to `undefined`, except
 * for `arguments` (which is initialized to the arguments object),
 * and special Node.js variables such as `module` and `exports`.
 */
private AbstractValue getImplicitInitValue(LocalVariable v) {
  if v instanceof ArgumentsVariable
  then exists(Function f | v = f.getArgumentsVariable() | result = TAbstractArguments(f))
  else
    if nodeBuiltins(v, _)
    then nodeBuiltins(v, result)
    else
      if exists(getAFunDecl(v))
      then
        // model hoisting
        result = TAbstractFunction(getAFunDecl(v))
      else
        if isAngularTemplateVariable(v)
        then result = TIndefiniteAbstractValue("heap")
        else result = TAbstractUndefined()
}

/**
 * Gets a function declaration that declares `v`.
 */
private FunctionDeclStmt getAFunDecl(LocalVariable v) { v = result.getVariable() }

/**
 * Holds if `v` is a local variable that can never be observed in its uninitialized state.
 */
pragma[noinline]
private predicate guaranteedToBeInitialized(LocalVariable v) {
  // parameters can never be uninitialized
  exists(Parameter p | v = p.getAVariable())
}

/**
 * Holds if `av` represents an initial value of CommonJS variable `var`.
 */
private predicate nodeBuiltins(Variable var, AbstractValue av) {
  exists(Module m, string name | var = m.getScope().getVariable(name) |
    name = "require" and av = TIndefiniteAbstractValue("heap")
    or
    name = "module" and av = TAbstractModuleObject(m)
    or
    name = "exports" and av = TAbstractExportsObject(m)
    or
    name = "arguments" and av = TAbstractOtherObject()
    or
    (name = "__filename" or name = "__dirname") and
    (av = TAbstractNumString() or av = TAbstractOtherString())
  )
}

/**
 * Flow analysis for global variables.
 */
private class AnalyzedGlobalVarUse extends DataFlow::AnalyzedValueNode {
  GlobalVariable gv;
  AnalyzedGlobal agv;

  AnalyzedGlobalVarUse() {
    exists(TopLevel tl | useIn(gv, astNode, tl) |
      if exists(TAnalyzedGlocal(gv, tl))
      then agv = TAnalyzedGlocal(gv, tl)
      else agv = TAnalyzedGenuineGlobal(gv)
    )
  }

  /** Gets the name of this global variable. */
  string getVariableName() { result = gv.getName() }

  /**
   * Gets a property write that may assign to this global variable as a property
   * of the global object.
   */
  private DataFlow::PropWrite getAnAssigningPropWrite() {
    result.getPropertyName() = this.getVariableName() and
    result.getBase().analyze().getALocalValue() instanceof AbstractGlobalObject
  }

  override predicate hasAdditionalIncompleteness(DataFlow::Incompleteness reason) {
    clobberedProp(gv, reason)
  }

  override AbstractValue getALocalValue() {
    result = super.getALocalValue()
    or
    result = this.getAnAssigningPropWrite().getRhs().analyze().getALocalValue()
    or
    result = agv.getAnAssignedValue()
  }
}

/**
 * Holds if `gva` is a use of `gv` in `tl`.
 */
private predicate useIn(GlobalVariable gv, GlobalVarAccess gva, TopLevel tl) {
  gva = gv.getAnAccess() and
  gva instanceof RValue and
  gva.getTopLevel() = tl
}

/**
 * Holds if `def` is a definition of `gv` in `tl`.
 */
private AnalyzedVarDef defIn(GlobalVariable gv, TopLevel tl) {
  result.getAVariable() = gv and
  result.getTopLevel() = tl
}

/**
 * Holds if there is a write to a property with the same name as `gv` on an object
 * for which the analysis is incomplete due to the given `reason`.
 */
cached
private predicate clobberedProp(GlobalVariable gv, DataFlow::Incompleteness reason) {
  exists(AnalyzedNode base |
    potentialPropWriteOfGlobal(base, gv) and
    indefiniteObjectValue(base.getALocalValue(), reason)
  )
}

pragma[nomagic]
private predicate indefiniteObjectValue(AbstractValue val, DataFlow::Incompleteness reason) {
  val.isIndefinite(reason) and
  val.getType() = TTObject()
}

pragma[nomagic]
private predicate potentialPropWriteOfGlobal(AnalyzedNode base, GlobalVariable gv) {
  exists(DataFlow::PropWrite pwn |
    pwn.getPropertyName() = gv.getName() and
    base = pwn.getBase().analyze()
  )
}

/**
 * A representation of a global variable for purposes of the analysis.
 *
 * Our basic strategy is to only track global data flow within the same toplevel, wherever
 * practical: a use of a global variable is interpreted to only refer to definitions within
 * the same toplevel. Only if there aren't any definitions within the toplevel do we also
 * take definitions in other toplevels into account.
 *
 * This is not unsound, since we _always_ infer an indefinite value for global variables anyway
 * (with the exception of `undefined`, which we assume to be immutable).
 *
 * To support this scheme, we represent global variables in the analysis as either "glocals",
 * that is, global variables considered local to some toplevel, or as genuine globals. The
 * abstract values of a glocal are derived purely from definitions within the same toplevel,
 * while genuine globals may get their values from anywhere in the program.
 */
private newtype TAnalyzedGlobal =
  /**
   * A global variable in the context of a particular toplevel in which it is both used
   * and defined.
   */
  TAnalyzedGlocal(GlobalVariable gv, TopLevel tl) { useIn(gv, _, tl) and exists(defIn(gv, tl)) } or
  /**
   * A global variable that is used in at least one toplevel where it is not defined, and
   * hence has to be modeled as a truly global variable.
   */
  TAnalyzedGenuineGlobal(GlobalVariable gv) {
    exists(TopLevel tl |
      useIn(gv, _, tl) and
      not exists(defIn(gv, tl))
    )
  }

/**
 * A representation of a global variable for purposes of the analysis.
 *
 * Our basic strategy is to only track global data flow within the same toplevel, wherever
 * practical: a use of a global variable is interpreted to only refer to definitions within
 * the same toplevel. Only if there aren't any definitions within the toplevel do we also
 * take definitions in other toplevels into account.
 *
 * This is not unsound, since we _always_ infer an indefinite value for global variables anyway
 * (with the exception of `undefined`, which we assume to be immutable).
 *
 * To support this scheme, we represent global variables in the analysis as either "glocals",
 * that is, global variables considered local to some toplevel, or as genuine globals. The
 * abstract values of a glocal are derived purely from definitions within the same toplevel,
 * while genuine globals may get their values from anywhere in the program.
 */
private class AnalyzedGlobal extends TAnalyzedGlobal {
  /** Gets an abstract value derived from an assignment to this global. */
  abstract AbstractValue getAnAssignedValue();

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * A global variable in the context of a particular toplevel in which it is both used
 * and defined.
 */
private class AnalyzedGlocal extends AnalyzedGlobal, TAnalyzedGlocal {
  GlobalVariable gv;
  TopLevel tl;

  AnalyzedGlocal() { this = TAnalyzedGlocal(gv, tl) }

  override AbstractValue getAnAssignedValue() { result = defIn(gv, tl).getAnAssignedValue() }

  override string toString() { result = gv + " in " + tl }
}

/**
 * A global variable that is used in at least one toplevel where it is not defined, and
 * hence has to be modeled as a truly global variable.
 */
private class AnalyzedGenuineGlobal extends AnalyzedGlobal, TAnalyzedGenuineGlobal {
  GlobalVariable gv;

  AnalyzedGenuineGlobal() { this = TAnalyzedGenuineGlobal(gv) }

  override AbstractValue getAnAssignedValue() { result = defIn(gv, _).getAnAssignedValue() }

  override string toString() { result = gv.toString() }
}

/**
 * Flow analysis for `undefined`.
 */
private class AnalyzedUndefinedUse extends AnalyzedGlobalVarUse {
  AnalyzedUndefinedUse() { gv.getName() = "undefined" }

  override AbstractValue getALocalValue() { result = TAbstractUndefined() }
}

/**
 * Holds if there might be indirect assignments to `v` through an `arguments` object.
 *
 * This predicate is conservative (that is, it may hold even for variables that cannot,
 * in fact, be assigned in this way): it checks if `v` is a parameter of a function
 * with a mapped `arguments` variable, and either there is a property write on `arguments`,
 * or we lose track of `arguments` (for example, because it is passed to another function).
 *
 * Here is an example with a property write on `arguments`:
 *
 * ```
 * function f1(x) {
 *   for (var i=0; i<arguments.length; ++i)
 *     arguments[i]++;
 * }
 * ```
 *
 * And here is an example where `arguments` escapes:
 *
 * ```
 * function f2(x) {
 *   [].forEach.call(arguments, function(_, i, args) {
 *     args[i]++;
 *   });
 * }
 * ```
 *
 * In both cases `x` is assigned through the `arguments` object.
 */
private predicate maybeModifiedThroughArguments(LocalVariable v) {
  exists(Function f, ArgumentsVariable args |
    v = f.getAParameter().(SimpleParameter).getVariable() and
    f.hasMappedArgumentsVariable() and
    args = f.getArgumentsVariable()
  |
    exists(VarAccess acc | acc = args.getAnAccess() |
      // `acc` is a use of `arguments` that isn't a property access
      // (like `arguments[0]` or `arguments.length`), so we conservatively
      // consider `arguments` to have escaped
      not exists(PropAccess pacc | acc = pacc.getBase())
      or
      // acc is a write to a property of `arguments` other than `length`,
      // so we conservatively consider it a possible write to `v`
      exists(PropAccess pacc | acc = pacc.getBase() |
        not pacc.getPropertyName() = "length" and
        pacc instanceof LValue
      )
    )
  )
}

/**
 * Flow analysis for variables that may be mutated reflectively through `eval`
 * or via the `arguments` array, and for variables that may refer to properties
 * of a `with` scope object.
 *
 * Note that this class overlaps with the other classes for handling variable
 * accesses, notably `VarAccessAnalysis`: its implementation of `getALocalValue`
 * does not replace the implementations in other classes, but complements
 * them by injecting additional values into the analysis.
 */
private class ReflectiveVarFlow extends DataFlow::AnalyzedValueNode {
  ReflectiveVarFlow() {
    exists(Variable v | v = astNode.(VarAccess).getVariable() |
      any(DirectEval de).mayAffect(v)
      or
      maybeModifiedThroughArguments(v)
      or
      any(WithStmt with).mayAffect(astNode)
    )
  }

  override AbstractValue getALocalValue() {
    result = TIndefiniteAbstractValue("eval")
    or
    result = AnalyzedValueNode.super.getALocalValue()
  }
}

/**
 * Flow analysis for variables exported from a TypeScript namespace.
 *
 * These are translated to property accesses by the TypeScript compiler and
 * can thus be mutated indirectly through the heap.
 */
private class NamespaceExportVarFlow extends DataFlow::AnalyzedValueNode {
  NamespaceExportVarFlow() { astNode.(VarAccess).getVariable().isNamespaceExport() }

  override AbstractValue getALocalValue() {
    result = TIndefiniteAbstractValue("namespace")
    or
    result = AnalyzedValueNode.super.getALocalValue()
  }
}

/**
 * A function with inter-procedural type inference for its parameters.
 */
abstract class FunctionWithAnalyzedParameters extends Function {
  /**
   * Holds if `p` is a parameter of this function and `arg` is
   * the corresponding argument.
   */
  abstract predicate argumentPassing(Parameter p, Expr arg);

  /**
   * Holds if `p` is a parameter of this function that may receive a value from an argument.
   */
  abstract predicate mayReceiveArgument(Parameter p);

  /**
   * Holds if flow analysis results for the parameters may be incomplete
   * due to the given `cause`.
   */
  abstract predicate isIncomplete(DataFlow::Incompleteness cause);
}

abstract private class CallWithAnalyzedParameters extends FunctionWithAnalyzedParameters {
  /**
   * Gets an invocation of this function.
   */
  abstract DataFlow::InvokeNode getAnInvocation();

  override predicate argumentPassing(Parameter p, Expr arg) {
    exists(DataFlow::InvokeNode invk, int argIdx | invk = this.getAnInvocation() |
      p = this.getParameter(argIdx) and
      not p.isRestParameter() and
      arg = invk.getArgument(argIdx).asExpr()
    )
  }

  override predicate mayReceiveArgument(Parameter p) {
    exists(int argIdx |
      p = this.getParameter(argIdx) and
      this.getAnInvocation().getNumArgument() > argIdx
    )
    or
    // All parameters may receive an argument if invoked with a spread argument
    p = this.getAParameter() and
    this.getAnInvocation().asExpr().(InvokeExpr).isSpreadArgument(_)
  }
}

/**
 * Flow analysis for simple parameters of IIFEs.
 */
private class IifeWithAnalyzedParameters extends CallWithAnalyzedParameters instanceof ImmediatelyInvokedFunctionExpr
{
  IifeWithAnalyzedParameters() { super.getInvocationKind() = "direct" }

  override DataFlow::InvokeNode getAnInvocation() { result = super.getInvocation().flow() }

  override predicate isIncomplete(DataFlow::Incompleteness cause) {
    // if the IIFE has a name and that name is referenced, we conservatively
    // assume that there may be other calls than the direct one
    exists(ImmediatelyInvokedFunctionExpr.super.getVariable().getAnAccess()) and cause = "call"
    or
    // if the IIFE is non-strict and its `arguments` object is accessed, we
    // also assume that there may be other calls (through `arguments.callee`)
    not ImmediatelyInvokedFunctionExpr.super.isStrict() and
    exists(ImmediatelyInvokedFunctionExpr.super.getArgumentsVariable().getAnAccess()) and
    cause = "call"
  }
}

/**
 * Enables inter-procedural type inference for `LocalFunction`.
 */
private class LocalFunctionWithAnalyzedParameters extends CallWithAnalyzedParameters instanceof LocalFunction
{
  override DataFlow::InvokeNode getAnInvocation() { result = LocalFunction.super.getAnInvocation() }

  override predicate isIncomplete(DataFlow::Incompleteness cause) { none() }
}
