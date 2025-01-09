private import codeql.ssa.Ssa as SsaImplCommon
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.models.interfaces.Allocation as Alloc
private import semmle.code.cpp.models.interfaces.DataFlow as DataFlow
private import semmle.code.cpp.models.interfaces.Taint as Taint
private import semmle.code.cpp.models.interfaces.PartialFlow as PartialFlow
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs as FIO
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.dataflow.internal.ModelUtil
private import semmle.code.cpp.ir.implementation.raw.internal.TranslatedInitialization
private import DataFlowPrivate
import SsaInternalsCommon

private module SourceVariables {
  cached
  private newtype TSourceVariable =
    TMkSourceVariable(BaseSourceVariable base, int ind) {
      ind = [0 .. countIndirectionsForCppType(base.getLanguageType()) + 1]
    }

  class SourceVariable extends TSourceVariable {
    BaseSourceVariable base;
    int ind;

    SourceVariable() { this = TMkSourceVariable(base, ind) }

    /** Gets the IR variable associated with this `SourceVariable`, if any. */
    IRVariable getIRVariable() { result = base.(BaseIRVariable).getIRVariable() }

    /**
     * Gets the base source variable (i.e., the variable without any
     * indirections) of this source variable.
     */
    BaseSourceVariable getBaseVariable() { result = base }

    /** Gets a textual representation of this element. */
    string toString() { result = repeatStars(this.getIndirection()) + base.toString() }

    /**
     * Gets the number of loads performed on the base source variable
     * to reach the value of this source variable.
     */
    int getIndirection() { result = ind }

    /** Holds if this variable is a glvalue. */
    predicate isGLValue() { ind = 0 }

    /**
     * Gets the type of this source variable. If `isGLValue()` holds, then
     * the type of this source variable should be thought of as "pointer
     * to `getType()`".
     */
    DataFlowType getType() {
      if this.isGLValue()
      then result = base.getType()
      else result = getTypeImpl(base.getType(), ind - 1)
    }

    /** Gets the location of this variable. */
    Location getLocation() { result = this.getBaseVariable().getLocation() }
  }
}

import SourceVariables

/**
 * Holds if `indirectionIndex` is a valid non-zero indirection index for
 * operand `op`. That is, `indirectionIndex` is between 1 and the maximum
 * indirection for the operand's type.
 */
predicate hasIndirectOperand(Operand op, int indirectionIndex) {
  exists(CppType type, int m |
    not ignoreOperand(op) and
    type = getLanguageType(op) and
    m = countIndirectionsForCppType(type) and
    indirectionIndex = [1 .. m]
  )
}

/**
 * Holds if the `(operand, indirectionIndex)` columns should be
 * assigned a `RawIndirectOperand` value.
 */
predicate hasRawIndirectOperand(Operand op, int indirectionIndex) {
  hasIndirectOperand(op, indirectionIndex) and
  not hasIRRepresentationOfIndirectOperand(op, indirectionIndex, _, _)
}

/**
 * Holds if the `(instr, indirectionIndex)` columns should be
 * assigned a `RawIndirectInstruction` value.
 */
predicate hasRawIndirectInstruction(Instruction instr, int indirectionIndex) {
  exists(CppType type, int m |
    not ignoreInstruction(instr) and
    type = getResultLanguageType(instr) and
    m = countIndirectionsForCppType(type) and
    indirectionIndex = [1 .. m] and
    not hasIRRepresentationOfIndirectInstruction(instr, indirectionIndex, _, _)
  )
}

cached
private newtype TDefImpl =
  TDefAddressImpl(BaseSourceVariable v) or
  TDirectDefImpl(Operand address, int indirectionIndex) {
    isDef(_, _, address, _, _, indirectionIndex)
  } or
  TGlobalDefImpl(GlobalLikeVariable v, IRFunction f, int indirectionIndex) {
    // Represents the initial "definition" of a global variable when entering
    // a function body.
    isGlobalDefImpl(v, f, _, indirectionIndex)
  }

cached
private newtype TUseImpl =
  TDirectUseImpl(Operand operand, int indirectionIndex) {
    isUse(_, operand, _, _, indirectionIndex) and
    not isDef(true, _, operand, _, _, _)
  } or
  TGlobalUse(GlobalLikeVariable v, IRFunction f, int indirectionIndex) {
    // Represents a final "use" of a global variable to ensure that
    // the assignment to a global variable isn't ruled out as dead.
    isGlobalUse(v, f, _, indirectionIndex)
  } or
  TFinalParameterUse(Parameter p, int indirectionIndex) {
    underlyingTypeIsModifiableAt(p.getUnderlyingType(), indirectionIndex) and
    // Only create an SSA read for the final use of a parameter if there's
    // actually a body of the enclosing function. If there's no function body
    // then we'll never need to flow out of the function anyway.
    p.getFunction().hasDefinition()
  }

private predicate isGlobalUse(
  GlobalLikeVariable v, IRFunction f, int indirection, int indirectionIndex
) {
  // Generate a "global use" at the end of the function body if there's a
  // direct definition somewhere in the body of the function
  indirection =
    min(int cand, VariableAddressInstruction vai |
      vai.getEnclosingIRFunction() = f and
      vai.getAstVariable() = v and
      isDef(_, _, _, vai, cand, indirectionIndex)
    |
      cand
    )
}

private predicate isGlobalDefImpl(
  GlobalLikeVariable v, IRFunction f, int indirection, int indirectionIndex
) {
  exists(VariableAddressInstruction vai |
    vai.getEnclosingIRFunction() = f and
    vai.getAstVariable() = v and
    isUse(_, _, vai, indirection, indirectionIndex) and
    not isDef(_, _, _, vai, _, indirectionIndex)
  )
}

private predicate underlyingTypeIsModifiableAt(Type underlying, int indirectionIndex) {
  indirectionIndex =
    [1 .. getIndirectionForUnspecifiedType(underlying.getUnspecifiedType())
          .getNumberOfIndirections()] and
  exists(CppType cppType |
    cppType.hasUnderlyingType(underlying, false) and
    isModifiableAt(cppType, indirectionIndex)
  )
}

private Indirection getIndirectionForUnspecifiedType(Type t) { result.getType() = t }

abstract class DefImpl extends TDefImpl {
  int indirectionIndex;

  bindingset[indirectionIndex]
  DefImpl() { any() }

  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  final IRBlock getBlock() { this.hasIndexInBlock(result, _) }

  /** Holds if this definition or use has index `index` in block `block`. */
  abstract predicate hasIndexInBlock(IRBlock block, int index);

  /**
   * Holds if this definition (or use) has index `index` in block `block`,
   * and is a definition (or use) of the variable `sv`
   */
  final predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    this.hasIndexInBlock(block, index) and
    sv = this.getSourceVariable()
  }

  /** Gets the location of this element. */
  abstract Cpp::Location getLocation();

  /** Gets the indirection index of this definition. */
  final int getIndirectionIndex() { result = indirectionIndex }

  /**
   * Gets the index (i.e., the number of loads required) of this
   * definition or use.
   *
   * Note that this is _not_ the definition's (or use's) index in
   * the enclosing basic block. To obtain this index, use
   * `DefOrUseImpl::hasIndexInBlock/2` or `DefOrUseImpl::hasIndexInBlock/3`.
   */
  abstract int getIndirection();

  /**
   * Gets the base source variable (i.e., the variable without
   * any indirection) of this definition or use.
   */
  abstract BaseSourceVariable getBaseSourceVariable();

  /** Gets the variable that is defined or used. */
  SourceVariable getSourceVariable() {
    exists(BaseSourceVariable v, int indirection |
      sourceVariableHasBaseAndIndex(result, v, indirection) and
      defHasSourceVariable(this, v, indirection)
    )
  }

  abstract predicate isCertain();

  abstract Node0Impl getValue();

  Operand getAddressOperand() { none() }
}

abstract class UseImpl extends TUseImpl {
  int indirectionIndex;

  bindingset[indirectionIndex]
  UseImpl() { any() }

  /** Gets the node associated with this use. */
  abstract Node getNode();

  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the block of this definition or use. */
  final IRBlock getBlock() { this.hasIndexInBlock(result, _) }

  /** Holds if this definition or use has index `index` in block `block`. */
  abstract predicate hasIndexInBlock(IRBlock block, int index);

  /**
   * Holds if this definition (or use) has index `index` in block `block`,
   * and is a definition (or use) of the variable `sv`
   */
  final predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    this.hasIndexInBlock(block, index) and
    sv = this.getSourceVariable()
  }

  /** Gets the location of this element. */
  abstract Cpp::Location getLocation();

  /**
   * Gets the index (i.e., the number of loads required) of this
   * definition or use.
   *
   * Note that this is _not_ the definition's (or use's) index in
   * the enclosing basic block. To obtain this index, use
   * `DefOrUseImpl::hasIndexInBlock/2` or `DefOrUseImpl::hasIndexInBlock/3`.
   */
  abstract int getIndirection();

  /** Gets the indirection index of this use. */
  final int getIndirectionIndex() { result = indirectionIndex }

  /**
   * Gets the base source variable (i.e., the variable without
   * any indirection) of this definition or use.
   */
  abstract BaseSourceVariable getBaseSourceVariable();

  /** Gets the variable that is defined or used. */
  SourceVariable getSourceVariable() {
    exists(BaseSourceVariable v, int indirection |
      sourceVariableHasBaseAndIndex(result, v, indirection) and
      useHasSourceVariable(this, v, indirection)
    )
  }

  /**
   * Holds if this use is guaranteed to read the
   * associated variable.
   */
  abstract predicate isCertain();
}

pragma[noinline]
private predicate defHasSourceVariable(DefImpl def, BaseSourceVariable bv, int ind) {
  bv = def.getBaseSourceVariable() and
  ind = def.getIndirection()
}

pragma[noinline]
private predicate useHasSourceVariable(UseImpl use, BaseSourceVariable bv, int ind) {
  bv = use.getBaseSourceVariable() and
  ind = use.getIndirection()
}

pragma[noinline]
private predicate sourceVariableHasBaseAndIndex(SourceVariable v, BaseSourceVariable bv, int ind) {
  v.getBaseVariable() = bv and
  v.getIndirection() = ind
}

/**
 * Gets the instruction that computes the address that's used to
 * initialize `v`.
 */
private Instruction getInitializationTargetAddress(IRVariable v) {
  exists(TranslatedVariableInitialization init |
    init.getIRVariable() = v and
    result = init.getTargetAddress()
  )
}

/** An initial definition of an SSA variable address. */
abstract private class DefAddressImpl extends DefImpl, TDefAddressImpl {
  BaseSourceVariable v;

  DefAddressImpl() {
    this = TDefAddressImpl(v) and
    indirectionIndex = 0
  }

  override string toString() { result = "Def of &" + v.toString() }

  final override int getIndirection() { result = 0 }

  final override predicate isCertain() { any() }

  final override Node0Impl getValue() { none() }

  override Cpp::Location getLocation() { result = v.getLocation() }

  final override SourceVariable getSourceVariable() {
    result.getBaseVariable() = v and
    result.getIndirection() = 0
  }

  final override BaseSourceVariable getBaseSourceVariable() { result = v }
}

private class DefVariableAddressImpl extends DefAddressImpl {
  override BaseIRVariable v;

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    exists(IRVariable var | var = v.getIRVariable() |
      block.getInstruction(index) = getInitializationTargetAddress(var)
      or
      // If there is no translatated element that does initialization of the
      // variable we place the SSA definition at the entry block of the function.
      not exists(getInitializationTargetAddress(var)) and
      block = var.getEnclosingIRFunction().getEntryBlock() and
      index = 0
    )
  }
}

private class DefCallAddressImpl extends DefAddressImpl {
  override BaseCallVariable v;

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    block.getInstruction(index) = v.getCallInstruction()
  }
}

private class DirectDef extends DefImpl, TDirectDefImpl {
  Operand address;

  DirectDef() { this = TDirectDefImpl(address, indirectionIndex) }

  override Cpp::Location getLocation() { result = this.getAddressOperand().getUse().getLocation() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    this.getAddressOperand().getUse() = block.getInstruction(index)
  }

  override string toString() { result = "Def of " + this.getSourceVariable() }

  override Operand getAddressOperand() { result = address }

  private BaseSourceVariableInstruction getBase() {
    isDef(_, _, address, result, _, indirectionIndex)
  }

  override BaseSourceVariable getBaseSourceVariable() {
    result = this.getBase().getBaseSourceVariable()
  }

  override int getIndirection() { isDef(_, _, address, _, result, indirectionIndex) }

  override Node0Impl getValue() { isDef(_, result, address, _, _, _) }

  override predicate isCertain() { isDef(true, _, address, _, _, indirectionIndex) }
}

private class DirectUseImpl extends UseImpl, TDirectUseImpl {
  Operand operand;

  DirectUseImpl() { this = TDirectUseImpl(operand, indirectionIndex) }

  override string toString() { result = "Use of " + this.getSourceVariable() }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    // See the comment in `ssa0`'s `OperandBasedUse` for an explanation of this
    // predicate's implementation.
    if this.getBase().getAst() = any(Cpp::PostfixCrementOperation c).getOperand()
    then
      exists(Operand op, int indirection, Instruction base |
        indirection = this.getIndirection() and
        base = this.getBase() and
        op =
          min(Operand cand, int i |
            isUse(_, cand, base, indirection, indirectionIndex) and
            block.getInstruction(i) = cand.getUse()
          |
            cand order by i
          ) and
        block.getInstruction(index) = op.getUse()
      )
    else operand.getUse() = block.getInstruction(index)
  }

  private BaseSourceVariableInstruction getBase() { isUse(_, operand, result, _, indirectionIndex) }

  override BaseSourceVariable getBaseSourceVariable() {
    result = this.getBase().getBaseSourceVariable()
  }

  final Operand getOperand() { result = operand }

  final override Cpp::Location getLocation() { result = operand.getLocation() }

  override int getIndirection() { isUse(_, operand, _, result, indirectionIndex) }

  override predicate isCertain() { isUse(true, operand, _, _, indirectionIndex) }

  override Node getNode() { nodeHasOperand(result, operand, indirectionIndex) }
}

pragma[nomagic]
private predicate finalParameterNodeHasParameterAndIndex(
  FinalParameterNode n, Parameter p, int indirectionIndex
) {
  n.getParameter() = p and
  n.getIndirectionIndex() = indirectionIndex
}

class FinalParameterUse extends UseImpl, TFinalParameterUse {
  Parameter p;

  FinalParameterUse() { this = TFinalParameterUse(p, indirectionIndex) }

  override string toString() { result = "Use of " + p.toString() }

  Parameter getParameter() { result = p }

  int getArgumentIndex() { result = p.getIndex() }

  override Node getNode() { finalParameterNodeHasParameterAndIndex(result, p, indirectionIndex) }

  override int getIndirection() { result = indirectionIndex + 1 }

  override predicate isCertain() { any() }

  override predicate hasIndexInBlock(IRBlock block, int index) {
    // Ideally, this should always be a `ReturnInstruction`, but if
    // someone forgets to write a `return` statement in a function
    // with a non-void return type we generate an `UnreachedInstruction`.
    // In this case we still want to generate flow out of such functions
    // if they write to a parameter. So we pick the index of the
    // `UnreachedInstruction` as the index of this use.
    // Note that a function may have both a `ReturnInstruction` and an
    // `UnreachedInstruction`. If that's the case this predicate will
    // return multiple results. I don't think this is detrimental to
    // performance, however.
    exists(Instruction return |
      return instanceof ReturnInstruction or
      return instanceof UnreachedInstruction
    |
      block.getInstruction(index) = return and
      return.getEnclosingFunction() = p.getFunction()
    )
  }

  override Cpp::Location getLocation() {
    // Parameters can have multiple locations. When there's a unique location we use
    // that one, but if multiple locations exist we default to an unknown location.
    result = unique( | | p.getLocation())
    or
    not exists(unique( | | p.getLocation())) and
    result instanceof UnknownDefaultLocation
  }

  override BaseIRVariable getBaseSourceVariable() { result.getIRVariable().getAst() = p }
}

/**
 * A use that models a synthetic "last use" of a global variable just before a
 * function returns.
 *
 * We model global variable flow by:
 * - Inserting a last use of any global variable that's modified by a function
 * - Flowing from the last use to the `VariableNode` that represents the global
 *   variable.
 * - Flowing from the `VariableNode` to an "initial def" of the global variable
 * in any function that may read the global variable.
 * - Flowing from the initial definition to any subsequent uses of the global
 *   variable in the function body.
 *
 * For example, consider the following pair of functions:
 * ```cpp
 * int global;
 * int source();
 * void sink(int);
 *
 * void set_global() {
 *   global = source();
 * }
 *
 * void read_global() {
 *  sink(global);
 * }
 * ```
 * we insert global uses and defs so that (from the point-of-view of dataflow)
 * the above scenario looks like:
 * ```cpp
 * int global; // (1)
 * int source();
 * void sink(int);
 *
 * void set_global() {
 *   global = source();
 *   __global_use(global); // (2)
 * }
 *
 * void read_global() {
 *  global = __global_def; // (3)
 *  sink(global); // (4)
 * }
 * ```
 * and flow from `source()` to the argument of `sink` is then modeled as
 * follows:
 * 1. Flow from `source()` to `(2)` (via SSA).
 * 2. Flow from `(2)` to `(1)` (via a `jumpStep`).
 * 3. Flow from `(1)` to `(3)` (via a `jumpStep`).
 * 4. Flow from `(3)` to `(4)` (via SSA).
 */
class GlobalUse extends UseImpl, TGlobalUse {
  GlobalLikeVariable global;
  IRFunction f;

  GlobalUse() { this = TGlobalUse(global, f, indirectionIndex) }

  override string toString() { result = "Use of " + global }

  override FinalGlobalValue getNode() { result.getGlobalUse() = this }

  override int getIndirection() { isGlobalUse(global, f, result, indirectionIndex) }

  /** Gets the global variable associated with this use. */
  GlobalLikeVariable getVariable() { result = global }

  /** Gets the `IRFunction` whose body is exited from after this use. */
  IRFunction getIRFunction() { result = f }

  final override predicate hasIndexInBlock(IRBlock block, int index) {
    // Similar to the `FinalParameterUse` case, we want to generate flow out of
    // globals at any exit so that we can flow out of non-returning functions.
    // Obviously this isn't correct as we can't actually flow but the global flow
    // requires this if we want to flow into children.
    exists(Instruction return |
      return instanceof ReturnInstruction or
      return instanceof UnreachedInstruction
    |
      block.getInstruction(index) = return and
      return.getEnclosingIRFunction() = f
    )
  }

  override BaseSourceVariable getBaseSourceVariable() {
    baseSourceVariableIsGlobal(result, global, f)
  }

  final override Cpp::Location getLocation() { result = f.getLocation() }

  /**
   * Gets the type of this use after specifiers have been deeply stripped
   * and typedefs have been resolved.
   */
  Type getUnspecifiedType() { result = global.getUnspecifiedType() }

  /**
   * Gets the type of this use, after typedefs have been resolved.
   */
  Type getUnderlyingType() { result = global.getUnderlyingType() }

  override predicate isCertain() { any() }
}

/**
 * A definition that models a synthetic "initial definition" of a global
 * variable just after the function entry point.
 *
 * See the QLDoc for `GlobalUse` for how this is used.
 */
class GlobalDefImpl extends DefImpl, TGlobalDefImpl {
  GlobalLikeVariable global;
  IRFunction f;

  GlobalDefImpl() { this = TGlobalDefImpl(global, f, indirectionIndex) }

  /** Gets the global variable associated with this definition. */
  GlobalLikeVariable getVariable() { result = global }

  /** Gets the `IRFunction` whose body is evaluated after this definition. */
  IRFunction getIRFunction() { result = f }

  /** Holds if this definition or use has index `index` in block `block`. */
  final override predicate hasIndexInBlock(IRBlock block, int index) {
    exists(EnterFunctionInstruction enter |
      enter = f.getEnterFunctionInstruction() and
      block.getInstruction(index) = enter
    )
  }

  /** Gets the global variable associated with this definition. */
  override BaseSourceVariable getBaseSourceVariable() {
    baseSourceVariableIsGlobal(result, global, f)
  }

  override int getIndirection() { result = indirectionIndex }

  override Node0Impl getValue() { none() }

  override predicate isCertain() { any() }

  /**
   * Gets the type of this definition after specifiers have been deeply
   * stripped and typedefs have been resolved.
   */
  Type getUnspecifiedType() { result = global.getUnspecifiedType() }

  /**
   * Gets the type of this definition, after typedefs have been resolved.
   */
  Type getUnderlyingType() { result = global.getUnderlyingType() }

  override string toString() { result = "Def of " + this.getSourceVariable() }

  override Location getLocation() { result = f.getLocation() }
}

/**
 * Holds if there is a definition or access at index `i1` in basic block `bb1`
 * and the next subsequent read is at index `i2` in basic block `bb2`.
 */
predicate adjacentDefRead(IRBlock bb1, int i1, SourceVariable sv, IRBlock bb2, int i2) {
  adjacentDefReadExt(_, sv, bb1, i1, bb2, i2)
}

predicate useToNode(IRBlock bb, int i, SourceVariable sv, Node nodeTo) {
  exists(UseImpl use |
    use.hasIndexInBlock(bb, i, sv) and
    nodeTo = use.getNode()
  )
}

pragma[noinline]
predicate outNodeHasAddressAndIndex(
  IndirectArgumentOutNode out, Operand address, int indirectionIndex
) {
  out.getAddressOperand() = address and
  out.getIndirectionIndex() = indirectionIndex
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if `node` is the node that corresponds to the definition of `def`.
 */
predicate defToNode(Node node, Def def, SourceVariable sv, IRBlock bb, int i, boolean uncertain) {
  def.hasIndexInBlock(bb, i, sv) and
  (
    nodeHasOperand(node, def.getValue().asOperand(), def.getIndirectionIndex())
    or
    nodeHasInstruction(node, def.getValue().asInstruction(), def.getIndirectionIndex())
    or
    node.(InitialGlobalValue).getGlobalDef() = def
  ) and
  if def.isCertain() then uncertain = false else uncertain = true
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if `node` is the node that corresponds to the definition or use at
 * index `i` in block `bb` of `sv`.
 *
 * `uncertain` is `true` if this is an uncertain definition.
 */
predicate nodeToDefOrUse(Node node, SourceVariable sv, IRBlock bb, int i, boolean uncertain) {
  defToNode(node, _, sv, bb, i, uncertain)
  or
  // Node -> Use
  useToNode(bb, i, sv, node) and
  uncertain = false
}

/**
 * Perform a single conversion-like step from `nFrom` to `nTo`. This relation
 * only holds when there is no use-use relation out of `nTo`.
 */
private predicate indirectConversionFlowStep(Node nFrom, Node nTo) {
  not exists(SourceVariable sv, IRBlock bb2, int i2 |
    useToNode(bb2, i2, sv, nTo) and
    adjacentDefRead(bb2, i2, sv, _, _)
  ) and
  exists(Operand op1, Operand op2, int indirectionIndex, Instruction instr |
    hasOperandAndIndex(nFrom, op1, pragma[only_bind_into](indirectionIndex)) and
    hasOperandAndIndex(nTo, op2, pragma[only_bind_into](indirectionIndex)) and
    instr = op2.getDef() and
    conversionFlow(op1, instr, _, _)
  )
}

/**
 * Holds if `node` is a phi input node that should receive flow from the
 * definition to (or use of) `sv` at `(bb1, i1)`.
 */
private predicate phiToNode(SsaPhiInputNode node, SourceVariable sv, IRBlock bb1, int i1) {
  exists(PhiNode phi, IRBlock input |
    phi.hasInputFromBlock(_, sv, bb1, i1, input) and
    node.getPhiNode() = phi and
    node.getBlock() = input
  )
}

/**
 * Holds if there should be flow from `nodeFrom` to `nodeTo` because
 * `nodeFrom` is a definition or use of `sv` at index `i1` at basic
 * block `bb1`.
 *
 * `uncertain` is `true` if `(bb1, i1)` is a definition, and that definition
 * is _not_ guaranteed to overwrite the entire allocation.
 */
private predicate ssaFlowImpl(
  IRBlock bb1, int i1, SourceVariable sv, Node nodeFrom, Node nodeTo, boolean uncertain
) {
  nodeToDefOrUse(nodeFrom, sv, bb1, i1, uncertain) and
  (
    exists(IRBlock bb2, int i2 |
      adjacentDefRead(bb1, i1, sv, bb2, i2) and
      useToNode(bb2, i2, sv, nodeTo)
    )
    or
    phiToNode(nodeTo, sv, bb1, i1)
  ) and
  nodeFrom != nodeTo
}

/** Gets a node that represents the prior definition of `node`. */
private Node getAPriorDefinition(DefinitionExt next) {
  exists(IRBlock bb, int i, SourceVariable sv |
    lastRefRedefExt(_, pragma[only_bind_into](sv), pragma[only_bind_into](bb),
      pragma[only_bind_into](i), _, next) and
    nodeToDefOrUse(result, sv, bb, i, _)
  )
}

private predicate inOut(FIO::FunctionInput input, FIO::FunctionOutput output) {
  exists(int indirectionIndex |
    input.isQualifierObject(indirectionIndex) and
    output.isQualifierObject(indirectionIndex)
    or
    exists(int i |
      input.isParameterDeref(i, indirectionIndex) and
      output.isParameterDeref(i, indirectionIndex)
    )
  )
}

/**
 * Holds if there should not be use-use flow out of `n`. That is, `n` is
 * an out-barrier to use-use flow. This includes:
 *
 * - an input to a call that would be assumed to have use-use flow to the same
 *   argument as an output, but this flow should be blocked because the
 *   function is modeled with another flow to that output (for example the
 *   first argument of `strcpy`).
 * - a conversion that flows to such an input.
 */
private predicate modeledFlowBarrier(Node n) {
  exists(
    FIO::FunctionInput input, FIO::FunctionOutput output, CallInstruction call,
    PartialFlow::PartialFlowFunction partialFlowFunc
  |
    n = callInput(call, input) and
    inOut(input, output) and
    exists(callOutput(call, output)) and
    partialFlowFunc = call.getStaticCallTarget() and
    not partialFlowFunc.isPartialWrite(output)
  |
    call.getStaticCallTarget().(DataFlow::DataFlowFunction).hasDataFlow(_, output)
    or
    call.getStaticCallTarget().(Taint::TaintFunction).hasTaintFlow(_, output)
  )
  or
  exists(Operand operand, Instruction instr, Node n0, int indirectionIndex |
    modeledFlowBarrier(n0) and
    nodeHasInstruction(n0, instr, indirectionIndex) and
    conversionFlow(operand, instr, false, _) and
    nodeHasOperand(n, operand, indirectionIndex)
  )
}

/** Holds if there is def-use or use-use flow from `nodeFrom` to `nodeTo`. */
predicate ssaFlow(Node nodeFrom, Node nodeTo) {
  exists(Node nFrom, boolean uncertain, IRBlock bb, int i, SourceVariable sv |
    ssaFlowImpl(bb, i, sv, nFrom, nodeTo, uncertain) and
    not modeledFlowBarrier(nFrom) and
    nodeFrom != nodeTo
  |
    if uncertain = true
    then
      nodeFrom =
        [nFrom, getAPriorDefinition(any(DefinitionExt next | next.definesAt(sv, bb, i, _)))]
    else nodeFrom = nFrom
  )
}

private predicate isArgumentOfCallableInstruction(DataFlowCall call, Instruction instr) {
  isArgumentOfCallableOperand(call, unique( | | getAUse(instr)))
}

private predicate isArgumentOfCallableOperand(DataFlowCall call, Operand operand) {
  operand = call.getArgumentOperand(_)
  or
  exists(FieldAddressInstruction fai |
    fai.getObjectAddressOperand() = operand and
    isArgumentOfCallableInstruction(call, fai)
  )
  or
  exists(Instruction deref |
    isArgumentOfCallableInstruction(call, deref) and
    isDereference(deref, operand, _)
  )
  or
  exists(Instruction instr |
    isArgumentOfCallableInstruction(call, instr) and
    conversionFlow(operand, instr, _, _)
  )
}

private predicate isArgumentOfCallable(DataFlowCall call, Node n) {
  isArgumentOfCallableOperand(call, n.asOperand())
  or
  exists(Operand op |
    n.(IndirectOperand).hasOperandAndIndirectionIndex(op, _) and
    isArgumentOfCallableOperand(call, op)
  )
  or
  exists(Instruction instr |
    n.(IndirectInstruction).hasInstructionAndIndirectionIndex(instr, _) and
    isArgumentOfCallableInstruction(call, instr)
  )
}

/**
 * Holds if there is use-use flow from `pun`'s pre-update node to `n`.
 */
private predicate postUpdateNodeToFirstUse(PostUpdateNode pun, Node n) {
  // We cannot mark a `PointerArithmeticInstruction` that computes an offset
  // based on some SSA
  // variable `x` as a use of `x` since this creates taint-flow in the
  // following example:
  // ```c
  // int x = array[source]
  // sink(*array)
  // ```
  // This is because `source` would flow from the operand of `PointerArithmetic`
  // instruction to the result of the instruction, and into the `IndirectOperand`
  // that represents the value of `*array`. Then, via use-use flow, flow will
  // arrive at `*array` in `sink(*array)`.
  // So this predicate recurses back along conversions and `PointerArithmetic`
  // instructions to find the first use that has provides use-use flow, and
  // uses that target as the target of the `nodeFrom`.
  exists(Node adjusted, IRBlock bb1, int i1, SourceVariable sv |
    indirectConversionFlowStep*(adjusted, pun.getPreUpdateNode()) and
    useToNode(bb1, i1, sv, adjusted)
  |
    exists(IRBlock bb2, int i2 |
      adjacentDefRead(bb1, i1, sv, bb2, i2) and
      useToNode(bb2, i2, sv, n)
    )
    or
    phiToNode(n, sv, bb1, i1)
  )
}

private predicate stepUntilNotInCall(DataFlowCall call, Node n1, Node n2) {
  isArgumentOfCallable(call, n1) and
  exists(Node mid | ssaFlowImpl(_, _, _, n1, mid, _) |
    isArgumentOfCallable(call, mid) and
    stepUntilNotInCall(call, mid, n2)
    or
    not isArgumentOfCallable(call, mid) and
    mid = n2
  )
}

bindingset[n1, n2]
pragma[inline_late]
private predicate isArgumentOfSameCall(DataFlowCall call, Node n1, Node n2) {
  isArgumentOfCallable(call, n1) and isArgumentOfCallable(call, n2)
}

/**
 * Holds if there is def-use or use-use flow from `pun` to `nodeTo`.
 *
 * Note: This is more complex than it sounds. Consider a call such as:
 * ```cpp
 * write_first_argument(x, x);
 * sink(x);
 * ```
 * Assume flow comes out of the first argument to `write_first_argument`. We
 * don't want flow to go to the `x` that's also an argument to
 * `write_first_argument` (because we just flowed out of that function, and we
 * don't want to flow back into it again).
 *
 * We do, however, want flow from the output argument to `x` on the next line, and
 * similarly we want flow from the second argument of `write_first_argument` to `x`
 * on the next line.
 */
predicate postUpdateFlow(PostUpdateNode pun, Node nodeTo) {
  exists(Node preUpdate, Node mid |
    preUpdate = pun.getPreUpdateNode() and
    postUpdateNodeToFirstUse(pun, mid)
  |
    exists(DataFlowCall call |
      isArgumentOfSameCall(call, preUpdate, mid) and
      stepUntilNotInCall(call, mid, nodeTo)
    )
    or
    not isArgumentOfSameCall(_, preUpdate, mid) and
    nodeTo = mid
  )
}

/** Holds if `nodeTo` receives flow from the phi node `nodeFrom`. */
predicate fromPhiNode(SsaPhiNode nodeFrom, Node nodeTo) {
  exists(PhiNode phi, SourceVariable sv, IRBlock bb1, int i1 |
    phi = nodeFrom.getPhiNode() and
    phi.definesAt(sv, bb1, i1, _)
  |
    exists(IRBlock bb2, int i2 |
      adjacentDefRead(bb1, i1, sv, bb2, i2) and
      useToNode(bb2, i2, sv, nodeTo)
    )
    or
    phiToNode(nodeTo, sv, bb1, i1)
  )
}

private predicate baseSourceVariableIsGlobal(
  BaseIRVariable base, GlobalLikeVariable global, IRFunction func
) {
  exists(IRVariable irVar |
    irVar = base.getIRVariable() and
    irVar.getEnclosingIRFunction() = func and
    global = irVar.getAst() and
    not irVar instanceof IRDynamicInitializationFlag
  )
}

private module SsaInput implements SsaImplCommon::InputSig<Location> {
  import InputSigCommon
  import SourceVariables

  /**
   * Holds if the `i`'th write in block `bb` writes to the variable `v`.
   * `certain` is `true` if the write is guaranteed to overwrite the entire variable.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    DataFlowImplCommon::forceCachingInSameStage() and
    (
      exists(DefImpl def | def.hasIndexInBlock(bb, i, v) |
        if def.isCertain() then certain = true else certain = false
      )
      or
      exists(GlobalDefImpl global |
        global.hasIndexInBlock(bb, i, v) and
        certain = true
      )
    )
  }

  /**
   * Holds if the `i`'th read in block `bb` reads to the variable `v`.
   * `certain` is `true` if the read is guaranteed. For C++, this is always the case.
   */
  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(UseImpl use | use.hasIndexInBlock(bb, i, v) |
      if use.isCertain() then certain = true else certain = false
    )
    or
    exists(GlobalUse global |
      global.hasIndexInBlock(bb, i, v) and
      certain = true
    )
  }
}

/**
 * The final SSA predicates used for dataflow purposes.
 */
cached
module SsaCached {
  /**
   * Holds if `def` is accessed at index `i1` in basic block `bb1` (either a read
   * or a write), `def` is read at index `i2` in basic block `bb2`, and there is a
   * path between them without any read of `def`.
   */
  cached
  predicate adjacentDefReadExt(
    DefinitionExt def, SourceVariable sv, IRBlock bb1, int i1, IRBlock bb2, int i2
  ) {
    SsaImpl::adjacentDefReadExt(def, sv, bb1, i1, bb2, i2)
  }

  /**
   * Holds if the node at index `i` in `bb` is a last reference to SSA definition
   * `def`. The reference is last because it can reach another write `next`,
   * without passing through another read or write.
   *
   * The path from node `i` in `bb` to `next` goes via basic block `input`,
   * which is either a predecessor of the basic block of `next`, or `input` =
   * `bb` in case `next` occurs in basic block `bb`.
   */
  cached
  predicate lastRefRedefExt(
    DefinitionExt def, SourceVariable sv, IRBlock bb, int i, IRBlock input, DefinitionExt next
  ) {
    SsaImpl::lastRefRedefExt(def, sv, bb, i, input, next)
  }

  cached
  Definition phiHasInputFromBlockExt(PhiNode phi, IRBlock bb) {
    SsaImpl::phiHasInputFromBlockExt(phi, result, bb)
  }

  cached
  predicate ssaDefReachesReadExt(SourceVariable v, DefinitionExt def, IRBlock bb, int i) {
    SsaImpl::ssaDefReachesReadExt(v, def, bb, i)
  }

  predicate variableRead = SsaInput::variableRead/4;

  predicate variableWrite = SsaInput::variableWrite/4;
}

cached
private newtype TSsaDef =
  TDef(DefinitionExt def) or
  TPhi(PhiNode phi)

abstract private class SsaDef extends TSsaDef {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /** Gets the underlying non-phi definition or use. */
  DefinitionExt asDef() { none() }

  /** Gets the underlying phi node. */
  PhiNode asPhi() { none() }

  /** Gets the location of this element. */
  abstract Location getLocation();
}

abstract class Def extends SsaDef, TDef {
  DefinitionExt def;

  Def() { this = TDef(def) }

  final override DefinitionExt asDef() { result = def }

  /** Gets the source variable underlying this SSA definition. */
  final SourceVariable getSourceVariable() { result = def.getSourceVariable() }

  override string toString() { result = def.toString() }

  /**
   * Holds if this definition (or use) has index `index` in block `block`,
   * and is a definition (or use) of the variable `sv`.
   */
  predicate hasIndexInBlock(IRBlock block, int index, SourceVariable sv) {
    def.definesAt(sv, block, index, _)
  }

  /** Gets the value written by this definition, if any. */
  Node0Impl getValue() { none() }

  /**
   * Holds if this definition is guaranteed to overwrite the entire
   * destination's allocation.
   */
  abstract predicate isCertain();

  /** Gets the address operand written to by this definition. */
  Operand getAddressOperand() { none() }

  /** Gets the address written to by this definition. */
  final Instruction getAddress() { result = this.getAddressOperand().getDef() }

  /** Gets the indirection index of this definition. */
  abstract int getIndirectionIndex();

  /**
   * Gets the indirection level that this definition is writing to.
   * For instance, `x = y` is a definition of `x` at indirection level 1 and
   * `*x = y` is a definition of `x` at indirection level 2.
   */
  abstract int getIndirection();

  /**
   * Gets a definition that ultimately defines this SSA definition and is not
   * itself a phi node.
   */
  Def getAnUltimateDefinition() { result.asDef() = def.getAnUltimateDefinition() }
}

private predicate isGlobal(DefinitionExt def, GlobalDefImpl global) {
  exists(SourceVariable sv, IRBlock bb, int i |
    def.definesAt(sv, bb, i, _) and
    global.hasIndexInBlock(bb, i, sv)
  )
}

private class NonGlobalDef extends Def {
  NonGlobalDef() { not isGlobal(def, _) }

  final override Location getLocation() { result = this.getImpl().getLocation() }

  private DefImpl getImpl() {
    exists(SourceVariable sv, IRBlock bb, int i |
      this.hasIndexInBlock(bb, i, sv) and
      result.hasIndexInBlock(bb, i, sv)
    )
  }

  override Node0Impl getValue() { result = this.getImpl().getValue() }

  override predicate isCertain() { this.getImpl().isCertain() }

  override Operand getAddressOperand() { result = this.getImpl().getAddressOperand() }

  override int getIndirectionIndex() { result = this.getImpl().getIndirectionIndex() }

  override int getIndirection() { result = this.getImpl().getIndirection() }
}

class GlobalDef extends Def {
  GlobalDefImpl global;

  GlobalDef() { isGlobal(def, global) }

  /** Gets a textual representation of this definition. */
  override string toString() { result = global.toString() }

  final override Location getLocation() { result = global.getLocation() }

  /**
   * Gets the type of this definition after specifiers have been deeply stripped
   * and typedefs have been resolved.
   */
  DataFlowType getUnspecifiedType() { result = global.getUnspecifiedType() }

  /**
   * Gets the type of this definition, after typedefs have been resolved.
   */
  DataFlowType getUnderlyingType() { result = global.getUnderlyingType() }

  /** Gets the `IRFunction` whose body is evaluated after this definition. */
  IRFunction getIRFunction() { result = global.getIRFunction() }

  /** Gets the global variable associated with this definition. */
  GlobalLikeVariable getVariable() { result = global.getVariable() }

  override predicate isCertain() { any() }

  final override int getIndirectionIndex() { result = global.getIndirectionIndex() }

  final override int getIndirection() { result = global.getIndirection() }
}

class Phi extends TPhi, SsaDef {
  PhiNode phi;

  Phi() { this = TPhi(phi) }

  final override PhiNode asPhi() { result = phi }

  final override Location getLocation() { result = phi.getBasicBlock().getLocation() }

  override string toString() { result = phi.toString() }

  SsaPhiInputNode getNode(IRBlock block) { result.getPhiNode() = phi and result.getBlock() = block }

  predicate hasInputFromBlock(Definition inp, IRBlock bb) { inp = phiHasInputFromBlockExt(phi, bb) }

  final Definition getAnInput() { this.hasInputFromBlock(result, _) }
}

private module SsaImpl = SsaImplCommon::Make<Location, SsaInput>;

/**
 * An static single assignment (SSA) phi node.
 *
 * This is either a normal phi node or a phi-read node.
 */
class PhiNode extends SsaImpl::DefinitionExt {
  PhiNode() {
    this instanceof SsaImpl::PhiNode or
    this instanceof SsaImpl::PhiReadNode
  }

  /**
   * Holds if this phi node is a phi-read node.
   *
   * Phi-read nodes are like normal phi nodes, but they are inserted based
   * on reads instead of writes.
   */
  predicate isPhiRead() { this instanceof SsaImpl::PhiReadNode }

  /**
   * Holds if the node at index `i` in `bb` is a last reference to SSA
   * definition `def` of `sv`. The reference is last because it can reach
   * this phi node, without passing through another read or write.
   *
   * The path from node `i` in `bb` to this phi node goes via basic block
   * `input`, which is either a predecessor of the basic block of this phi
   * node, or `input` = `bb` in case this phi node occurs in basic block `bb`.
   */
  predicate hasInputFromBlock(DefinitionExt def, SourceVariable sv, IRBlock bb, int i, IRBlock input) {
    SsaCached::lastRefRedefExt(def, sv, bb, i, input, this)
  }

  /** Gets a definition that is an input to this phi node. */
  final Definition getAnInput() { this.hasInputFromBlock(result, _, _, _, _) }
}

/** An static single assignment (SSA) definition. */
class DefinitionExt extends SsaImpl::DefinitionExt {
  private Definition getAPhiInputOrPriorDefinition() { result = this.(PhiNode).getAnInput() }

  /**
   * Gets a definition that ultimately defines this SSA definition and is
   * not itself a phi node.
   */
  final DefinitionExt getAnUltimateDefinition() {
    result = this.getAPhiInputOrPriorDefinition*() and
    not result instanceof PhiNode
  }

  /** Gets a node that represents a read of this SSA definition. */
  pragma[nomagic]
  Node getARead() {
    exists(SourceVariable sv, IRBlock bb, int i | SsaCached::ssaDefReachesReadExt(sv, this, bb, i) |
      useToNode(bb, i, sv, result)
      or
      phiToNode(result, sv, bb, i)
    )
  }
}

class Definition = SsaImpl::Definition;

import SsaCached
