/**
 * Provides classes and predicates for identifying functions that initialize their arguments.
 */

import cpp
import external.ExternalArtifact
private import semmle.code.cpp.dispatch.VirtualDispatchPrototype
import semmle.code.cpp.NestedFields
import Microsoft.SAL
import semmle.code.cpp.controlflow.Guards

/** A context under which a function may be called. */
private newtype TContext =
  /** No specific call context. */
  NoContext() or
  /**
   * The call context is that the given other parameter is null.
   *
   * This context is created for all parameters that are null checked in the body of the function.
   */
  ParamNull(Parameter p) { p = any(ParameterNullCheck pnc).getParameter() } or
  /**
   * The call context is that the given other parameter is not null.
   *
   * This context is created for all parameters that are null checked in the body of the function.
   */
  ParamNotNull(Parameter p) { p = any(ParameterNullCheck pnc).getParameter() }

/**
 * A context under which a function may be called.
 *
 * Some functions may conditionally initialize a parameter depending on the value of another
 * parameter. Consider:
 * ```
 * int MyInitFunction(int* paramToBeInitialized, int* paramToCheck) {
 *   if (!paramToCheck) {
 *     // fail!
 *     return -1;
 *   }
 *   paramToBeInitialized = 0;
 * }
 * ```
 * In this case, whether `paramToBeInitialized` is initialized when this function call completes
 * depends on whether `paramToCheck` is or is not null. A call-context insensitive analysis will
 * determine that any call to this function may leave the parameter uninitialized, even if the
 * argument to paramToCheck is guaranteed to be non-null (`&foo`, for example).
 *
 * This class models call contexts that can be considered when calculating whether a given parameter
 * initializes or not. The supported contexts are:
 *  - `ParamNull(otherParam)` - the given `otherParam` is considered to be null. Applies when
 *                            exactly one parameter other than this one is null checked.
 *  - `ParamNotNull(otherParam)` - the given `otherParam` is considered to be not null. Applies when
 *                               exactly one parameter other than this one is null checked.
 *  - `NoContext()` - applies in all other circumstances.
 */
class Context extends TContext {
  string toString() {
    this = NoContext() and result = "NoContext"
    or
    this = ParamNull(any(Parameter p | result = "ParamNull(" + p.getName() + ")"))
    or
    this = ParamNotNull(any(Parameter p | result = "ParamNotNull(" + p.getName() + ")"))
  }
}

/**
 * A check against a parameter.
 */
abstract class ParameterCheck extends Expr {
  /**
   * Gets a successor of this check that should be ignored for the given context.
   */
  abstract ControlFlowNode getIgnoredSuccessorForContext(Context c);
}

/** A null-check expression on a parameter. */
class ParameterNullCheck extends ParameterCheck {
  Parameter p;
  ControlFlowNode nullSuccessor;
  ControlFlowNode notNullSuccessor;

  ParameterNullCheck() {
    this.isCondition() and
    p.getFunction() instanceof InitializationFunction and
    p.getType().getUnspecifiedType() instanceof PointerType and
    exists(VariableAccess va | va = p.getAnAccess() |
      nullSuccessor = getATrueSuccessor() and
      notNullSuccessor = getAFalseSuccessor() and
      (
        va = this.(NotExpr).getOperand() or
        va = any(EQExpr eq | eq = this and eq.getAnOperand().getValue() = "0").getAnOperand() or
        va = getCheckedFalseCondition(this) or
        va =
          any(NEExpr eq | eq = getCheckedFalseCondition(this) and eq.getAnOperand().getValue() = "0")
              .getAnOperand()
      )
      or
      nullSuccessor = getAFalseSuccessor() and
      notNullSuccessor = getATrueSuccessor() and
      (
        va = this or
        va = any(NEExpr eq | eq = this and eq.getAnOperand().getValue() = "0").getAnOperand() or
        va =
          any(EQExpr eq | eq = getCheckedFalseCondition(this) and eq.getAnOperand().getValue() = "0")
              .getAnOperand()
      )
    )
  }

  /** The parameter being null-checked. */
  Parameter getParameter() { result = p }

  override ControlFlowNode getIgnoredSuccessorForContext(Context c) {
    c = ParamNull(p) and result = notNullSuccessor
    or
    c = ParamNotNull(p) and result = nullSuccessor
  }

  /** The successor at which the parameter is confirmed to be null. */
  ControlFlowNode getNullSuccessor() { result = nullSuccessor }

  /** The successor at which the parameter is confirmed to be not-null. */
  ControlFlowNode getNotNullSuccessor() { result = notNullSuccessor }
}

/**
 * An entry in a CSV file in cond-init that contains externally defined functions that are
 * conditional initializers. These files are typically produced by running the
 * ConditionallyInitializedFunction companion query.
 */
class ValidatedExternalCondInitFunction extends ExternalData {
  ValidatedExternalCondInitFunction() { this.getDataPath().matches("%cond-init%.csv") }

  predicate isExternallyVerified(Function f, int param) {
    functionSignature(f, getField(1), getField(2)) and param = getFieldAsInt(3)
  }
}

/**
 * The type of evidence used to determine whether a function initializes a parameter.
 */
newtype Evidence =
  /**
   * The function is defined in the snapshot, and the CFG has been analyzed to determine that the
   * parameter is not initialized on at least one path to the exit.
   */
  DefinitionInSnapshot() or
  /**
   * The function is externally defined, but the parameter has an `_out` SAL annotation which
   * suggests that it is initialized in the function.
   */
  SuggestiveSALAnnotation() or
  /**
   * We have been given a CSV file which indicates this parameter is conditionally initialized.
   */
  ExternalEvidence()

/**
 * A call to an function which initializes one or more of its parameters.
 */
class InitializationFunctionCall extends FunctionCall {
  Expr initializedArgument;

  InitializationFunctionCall() { initializedArgument = getAnInitializedArgument(this) }

  /** Gets a parameter that is initialized by this call. */
  Parameter getAnInitParameter() { result.getAnAccess() = initializedArgument }
}

/**
 * A variable access which is dereferenced then assigned to.
 */
private predicate isPointerDereferenceAssignmentTarget(VariableAccess target) {
  target.getParent().(PointerDereferenceExpr) = any(Assignment e).getLValue()
}

/**
 * A function which initializes one or more of its parameters.
 */
class InitializationFunction extends Function {
  int i;
  Evidence evidence;

  InitializationFunction() {
    evidence = DefinitionInSnapshot() and
    (
      // Assignment by pointer dereferencing the parameter
      isPointerDereferenceAssignmentTarget(this.getParameter(i).getAnAccess()) or
      // Field wise assignment to the parameter
      any(Assignment e).getLValue() = getAFieldAccess(this.getParameter(i)) or
      i =
        this
            .(MemberFunction)
            .getAnOverridingFunction+()
            .(InitializationFunction)
            .initializedParameter() or
      getParameter(i) = any(InitializationFunctionCall c).getAnInitParameter()
    )
    or
    // If we have no definition, we look at SAL annotations
    not this.hasDefinition() and
    this.getParameter(i).(SALParameter).isOut() and
    evidence = SuggestiveSALAnnotation()
    or
    // We have some external information that this function conditionally initializes
    not this.hasDefinition() and
    any(ValidatedExternalCondInitFunction vc).isExternallyVerified(this, i) and
    evidence = ExternalEvidence()
  }

  /** Gets a parameter index which is initialized by this function. */
  int initializedParameter() { result = i }

  /** Gets a `ControlFlowNode` which assigns a new value to the parameter with the given index. */
  ControlFlowNode paramReassignment(int index) {
    index = i and
    (
      result = this.getParameter(i).getAnAccess() and
      (
        result = any(Assignment a).getLValue().(PointerDereferenceExpr).getOperand()
        or
        // Field wise assignment to the parameter
        result = any(Assignment a).getLValue().(FieldAccess).getQualifier()
        or
        // Assignment to a nested field of the parameter
        result = any(Assignment a).getLValue().(NestedFieldAccess).getUltimateQualifier()
        or
        result = getAnInitializedArgument(any(Call c))
        or
        exists(IfStmt check | result = check.getCondition().getAChild*() |
          paramReassignmentCondition(check)
        )
      )
      or
      result =
        any(AssumeExpr e |
          e.getEnclosingFunction() = this and e.getAChild().(Literal).getValue() = "0"
        )
    )
  }

  /**
   * Helper predicate: holds if the `if` statement `check` contains a
   * reassignment to the `i`th parameter within its `then` statement.
   */
  pragma[noinline]
  private predicate paramReassignmentCondition(IfStmt check) {
    this.paramReassignment(i).getEnclosingStmt().getParentStmt*() = check.getThen()
  }

  /** Holds if `n` can be reached without the parameter at `index` being reassigned. */
  predicate paramNotReassignedAt(ControlFlowNode n, int index, Context c) {
    c = getAContext(index) and
    (
      not exists(this.getEntryPoint()) and index = i and n = this
      or
      n = this.getEntryPoint() and index = i
      or
      exists(ControlFlowNode mid | paramNotReassignedAt(mid, index, c) |
        n = mid.getASuccessor() and
        not n = paramReassignment(index) and
        /*
         * Ignore successor edges where the parameter is null, because it is then confirmed to be
         * initialized.
         */

        not exists(ParameterNullCheck nullCheck |
          nullCheck = mid and
          nullCheck = getANullCheck(index) and
          n = nullCheck.getNullSuccessor()
        ) and
        /*
         * Ignore successor edges which are excluded by the given context
         */

        not exists(ParameterCheck paramCheck | paramCheck = mid |
          n = paramCheck.getIgnoredSuccessorForContext(c)
        )
      )
    )
  }

  /** Gets a null-check on the parameter at `index`. */
  private ParameterNullCheck getANullCheck(int index) {
    getParameter(index) = result.getParameter()
  }

  /** Gets a parameter which is not at the given index. */
  private Parameter getOtherParameter(int index) {
    index = i and
    result = getAParameter() and
    not result.getIndex() = index
  }

  /**
   * Gets a call `Context` that is applicable when considering whether parameter at the `index` can
   * be conditionally initialized.
   */
  Context getAContext(int index) {
    index = i and
    /*
     * If there is one and only one other parameter which is null checked in the body of the method,
     * then we have two contexts to consider - that the other param is null, or that the other param
     * is not null.
     */

    if
      strictcount(Parameter p |
        exists(Context c | c = ParamNull(p) or c = ParamNotNull(p)) and
        p = getOtherParameter(index)
      ) = 1
    then
      exists(Parameter p | p = getOtherParameter(index) |
        result = ParamNull(p) or result = ParamNotNull(p)
      )
    else
      // Otherwise, only consider NoContext.
      result = NoContext()
  }

  /**
   * Holds if this function should be whitelisted - that is, not considered as conditionally
   * initializing its parameters.
   */
  predicate whitelisted() {
    exists(string name | this.hasName(name) |
      // Return value is not a success code but the output functions never fail.
      name.matches("_Interlocked%")
      or
      // Functions that never fail, according to MSDN.
      name = "QueryPerformanceCounter"
      or
      name = "QueryPerformanceFrequency"
      or
      // Functions that never fail post-Vista, according to MSDN.
      name = "InitializeCriticalSectionAndSpinCount"
      or
      // `rand_s` writes 0 to a non-null argument if it fails, according to MSDN.
      name = "rand_s"
      or
      // IntersectRect initializes the argument regardless of whether the input intersects
      name = "IntersectRect"
      or
      name = "SetRect"
      or
      name = "UnionRect"
      or
      // These functions appears to have an incorrect CFG, which leads to false positives
      name = "PhysicalToLogicalDPIPoint"
      or
      name = "LogicalToPhysicalDPIPoint"
      or
      // Sets NtProductType to default on error
      name = "RtlGetNtProductType"
      or
      // Our CFG is not sophisticated enough to detect that the argument is always initialized
      name = "StringCchLengthA"
      or
      // All paths init the argument, and always returns SUCCESS.
      name = "RtlUnicodeToMultiByteSize"
      or
      // All paths init the argument, and always returns SUCCESS.
      name = "RtlMultiByteToUnicodeSize"
      or
      // All paths init the argument, and always returns SUCCESS.
      name = "RtlUnicodeToMultiByteN"
      or
      // Always initializes argument
      name = "RtlGetFirstRange"
      or
      // Destination range is zeroed out on failure, assuming first two parameters are valid
      name = "memcpy_s"
      or
      // This zeroes the memory unconditionally
      name = "SeCreateAccessState"
    )
  }
}

/**
 * A function which initializes one or more of its parameters, but not on all paths.
 */
class ConditionalInitializationFunction extends InitializationFunction {
  Context c;

  ConditionalInitializationFunction() {
    c = this.getAContext(i) and
    not this.whitelisted() and
    exists(Type status | status = this.getType().getUnspecifiedType() |
      status instanceof IntegralType or
      status instanceof Enum
    ) and
    not this.getType().getName().toLowerCase() = "size_t" and
    (
      /*
       * If there is no definition, consider this to be conditionally initializing (based on either
       * SAL or external data).
       */

      not evidence = DefinitionInSnapshot()
      or
      /*
       * If this function is defined in this snapshot, then it conditionally initializes if there
       * is at least one path through the function which doesn't initialize the parameter.
       *
       * Explicitly ignore pure virtual functions.
       */

      this.hasDefinition() and
      this.paramNotReassignedAt(this, i, c) and
      not this instanceof PureVirtualFunction
    )
  }

  /** Gets the evidence associated with the given parameter. */
  Evidence getEvidence(int param) {
    /*
     * Note: due to the way the predicate dispatch interacts with fields, this needs to be
     * implemented on this class, not `InitializationFunction`. If implemented on the latter it
     * can return evidence that does not result in conditional initialization.
     */

    param = i and evidence = result
  }

  /** Gets the index of a parameter which is conditionally initialized. */
  int conditionallyInitializedParameter(Context context) { result = i and context = c }
}

/**
 * More elaborate tracking, flagging cases where the status is checked after
 * the potentially uninitialized variable has been used, and ignoring cases
 * where the status is not checked but there is no use of the potentially
 * uninitialized variable, may be obtained via `getARiskyAccess`.
 */
class ConditionalInitializationCall extends FunctionCall {
  ConditionalInitializationFunction target;

  ConditionalInitializationCall() { target = getTarget(this) }

  /** Gets the argument passed for the given parameter to this call. */
  Expr getArgumentForParameter(Parameter p) {
    p = getTarget().getAParameter() and
    result = getArgument(p.getIndex())
  }

  /**
   * Gets an argument conditionally initialized by this call.
   */
  Expr getAConditionallyInitializedArgument(ConditionalInitializationFunction condTarget, Evidence e) {
    condTarget = target and
    exists(Context context |
      result = getAConditionallyInitializedArgument(this, condTarget, context, e)
    |
      context = NoContext()
      or
      exists(Parameter otherP, Expr otherArg |
        context = ParamNotNull(otherP) or
        context = ParamNull(otherP)
      |
        otherArg = getArgumentForParameter(otherP) and
        (otherArg instanceof AddressOfExpr implies context = ParamNotNull(otherP)) and
        (otherArg.getType() instanceof ArrayType implies context = ParamNotNull(otherP)) and
        (otherArg.getValue() = "0" implies context = ParamNull(otherP))
      )
    )
  }

  VariableAccess getAConditionallyInitializedVariable() {
    not result.getTarget().getAnAssignedValue().getASuccessor+() = result and
    // Should not be assigned field-wise prior to the call.
    not exists(Assignment a, FieldAccess fa |
      fa.getQualifier() = result.getTarget().getAnAccess() and
      a.getLValue() = fa and
      fa.getASuccessor+() = result
    ) and
    result =
      this
          .getArgument(getTarget(this)
                .(ConditionalInitializationFunction)
                .conditionallyInitializedParameter(_))
          .(AddressOfExpr)
          .getOperand()
  }

  Variable getStatusVariable() {
    exists(AssignExpr a | a.getLValue() = result.getAnAccess() | a.getRValue() = this)
    or
    result.getInitializer().getExpr() = this
  }

  Expr getSuccessCheck() {
    exists(this.getAFalseSuccessor()) and result = this
    or
    result = this.getParent() and
    (
      result instanceof NotExpr or
      result.(EQExpr).getAnOperand().getValue() = "0" or
      result.(GEExpr).getLesserOperand().getValue() = "0"
    )
  }

  Expr getFailureCheck() {
    result = this.getParent() and
    (
      result instanceof NotExpr or
      result.(NEExpr).getAnOperand().getValue() = "0" or
      result.(LTExpr).getLesserOperand().getValue() = "0"
    )
  }

  private predicate inCheckedContext() {
    exists(Call parent | this = parent.getAnArgument() |
      parent.getTarget() instanceof Operator or
      parent.getTarget().hasName("VerifyOkCatastrophic")
    )
  }

  ControlFlowNode uncheckedReaches(LocalVariable var) {
    (
      not exists(var.getInitializer()) and
      var = this.getAConditionallyInitializedVariable().getTarget() and
      if exists(this.getFailureCheck())
      then result = this.getFailureCheck().getATrueSuccessor()
      else
        if exists(this.getSuccessCheck())
        then result = this.getSuccessCheck().getAFalseSuccessor()
        else (
          result = this.getASuccessor() and not this.inCheckedContext()
        )
    )
    or
    exists(ControlFlowNode mid | mid = uncheckedReaches(var) |
      not mid = getStatusVariable().getAnAccess() and
      not mid = var.getAnAccess() and
      not exists(VariableAccess write | result = write and write = var.getAnAccess() |
        write = any(AssignExpr a).getLValue() or
        write = any(AddressOfExpr a).getOperand()
      ) and
      result = mid.getASuccessor()
    )
  }

  VariableAccess getARiskyRead(Function f) {
    f = this.getTarget() and
    exists(this.getFile().getRelativePath()) and
    result = this.uncheckedReaches(result.getTarget()) and
    not this.(GuardCondition).controls(result.getBasicBlock(), _)
  }
}

/**
 * Gets the position of an argument to the call which is initialized by the call.
 */
pragma[nomagic]
int initializedArgument(Call call) {
  exists(InitializationFunction target |
    target = getTarget(call) and
    result = target.initializedParameter()
  )
}

/**
 * Gets an argument which is initialized by the call.
 */
Expr getAnInitializedArgument(Call call) { result = call.getArgument(initializedArgument(call)) }

/**
 * Gets the position of an argument to the call to the target which is conditionally initialized by
 * the call, under the given context and evidence.
 */
pragma[nomagic]
private int conditionallyInitializedArgument(
  Call call, ConditionalInitializationFunction target, Context c, Evidence e
) {
  target = getTarget(call) and
  c = target.getAContext(result) and
  e = target.getEvidence(result) and
  result = target.conditionallyInitializedParameter(c)
}

/**
 * Gets an argument which is conditionally initialized by the call to the given target under the given context and evidence.
 */
Expr getAConditionallyInitializedArgument(
  Call call, ConditionalInitializationFunction target, Context c, Evidence e
) {
  result = call.getArgument(conditionallyInitializedArgument(call, target, c, e))
}

/**
 * Gets the type signature for the functions parameters.
 */
private string typeSig(Function f) {
  result =
    concat(int i, Type pt |
      pt = f.getParameter(i).getType()
    |
      pt.getUnspecifiedType().toString(), "," order by i
    )
}

/**
 * Holds where qualifiedName and typeSig make up the signature for the function.
 */
private predicate functionSignature(Function f, string qualifiedName, string typeSig) {
  qualifiedName = f.getQualifiedName() and
  typeSig = typeSig(f)
}

/**
 * Gets a possible definition for the undefined function by matching the undefined function name
 * and parameter arity with a defined function.
 *
 * This is useful for identifying call to target dependencies across libraries, where the libraries
 * are never statically linked together.
 */
private Function getAPossibleDefinition(Function undefinedFunction) {
  not undefinedFunction.hasDefinition() and
  exists(string qn, string typeSig |
    functionSignature(undefinedFunction, qn, typeSig) and functionSignature(result, qn, typeSig)
  ) and
  result.hasDefinition()
}

/**
 * Helper predicate for `getTarget`, that computes possible targets of a `Call`.
 *
 * If there is at least one defined target after performing some simple virtual dispatch
 * resolution, then the result is all the defined targets.
 */
private Function getTarget1(Call c) {
  result = VirtualDispatch::getAViableTarget(c) and
  result.hasDefinition()
}

/**
 * Helper predicate for `getTarget`, that computes possible targets of a `Call`.
 *
 * If we can use the heuristic matching of functions to find definitions for some of the viable
 * targets, return those.
 */
private Function getTarget2(Call c) {
  not exists(getTarget1(c)) and
  result = getAPossibleDefinition(VirtualDispatch::getAViableTarget(c))
}

/**
 * Helper predicate for `getTarget`, that computes possible targets of a `Call`.
 *
 * Otherwise, the result is the undefined `Function` instances.
 */
private Function getTarget3(Call c) {
  not exists(getTarget1(c)) and
  not exists(getTarget2(c)) and
  result = VirtualDispatch::getAViableTarget(c)
}

/**
 * Gets a possible target for the `Call`, using the name and parameter matching if we did not associate
 * this call with a specific definition at link or compile time, and performing simple virtual
 * dispatch resolution.
 */
Function getTarget(Call c) {
  result = getTarget1(c) or
  result = getTarget2(c) or
  result = getTarget3(c)
}

/**
 * Get an access of a field on `Variable` v.
 */
FieldAccess getAFieldAccess(Variable v) {
  exists(VariableAccess va, Expr qualifierExpr |
    // Find an access of the variable, or an AddressOfExpr that has the access
    va = v.getAnAccess() and
    (
      qualifierExpr = va or
      qualifierExpr.(AddressOfExpr).getOperand() = va
    )
  |
    // Direct field access
    qualifierExpr = result.getQualifier()
    or
    // Nested field access
    qualifierExpr = result.(NestedFieldAccess).getUltimateQualifier()
  )
}

/**
 * Gets a condition which is checked to be false by the given `ne` expression, according to this pattern:
 * ```
 * int a = !!result;
 * if (!a) {  // <- ne
 *   ....
 * }
 * ```
 */
private Expr getCheckedFalseCondition(NotExpr ne) {
  exists(LocalVariable v |
    result = v.getInitializer().getExpr().(NotExpr).getOperand().(NotExpr).getOperand() and
    ne.getOperand() = v.getAnAccess() and
    nonAssignedVariable(v)
    // and not passed by val?
  )
}

pragma[noinline]
private predicate nonAssignedVariable(Variable v) { not exists(v.getAnAssignment()) }
