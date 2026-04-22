private import cpp
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import DataFlowPrivate
private import DataFlowUtil
private import ModelUtil
private import SsaImpl as SsaImpl
private import DataFlowImplCommon as DataFlowImplCommon
private import codeql.util.Unit
private import Node0ToString

/**
 * A canonical representation of a field.
 *
 * For performance reasons we want a unique `Content` that represents
 * a given field across any template instantiation of a class.
 *
 * This is possible in _almost_ all cases, but there are cases where it is
 * not possible to map between a field in the uninstantiated template to a
 * field in the instantiated template. This happens in the case of local class
 * definitions (because the local class is not the template that constructs
 * the instantiation - it is the enclosing function). So this abstract class
 * has two implementations: a non-local case (where we can represent a
 * canonical field as the field declaration from an uninstantiated class
 * template or a non-templated class), and a local case (where we simply use
 * the field from the instantiated class).
 */
abstract class CanonicalField extends Field {
  /** Gets a field represented by this canonical field. */
  abstract Field getAField();

  /**
   * Gets a class that declares a field represented by this canonical field.
   */
  abstract Class getADeclaringType();

  /**
   * Gets a type that this canonical field may have. Note that this may
   * not be a unique type. For example, consider this case:
   * ```
   * template<typename T>
   * struct S { T x; };
   *
   * S<int> s1;
   * S<char> s2;
   * ```
   * In this case the canonical field corresponding to `S::x` has two types:
   * `int` and `char`.
   */
  Type getAType() { result = this.getAField().getType() }

  Type getAnUnspecifiedType() { result = this.getAType().getUnspecifiedType() }
}

private class NonLocalCanonicalField extends CanonicalField {
  Class declaringType;

  NonLocalCanonicalField() {
    declaringType = this.getDeclaringType() and
    not declaringType.isFromTemplateInstantiation(_) and
    not declaringType.isLocal() // handled in LocalCanonicalField
  }

  override Field getAField() {
    exists(Class c | result.getDeclaringType() = c |
      // Either the declaring class of the field is a template instantiation
      // that has been constructed from this canonical declaration
      c.isConstructedFrom(declaringType) and
      pragma[only_bind_out](result.getName()) = pragma[only_bind_out](this.getName())
      or
      // or this canonical declaration is not a template.
      not c.isConstructedFrom(_) and
      result = this
    )
  }

  override Class getADeclaringType() {
    result = this.getDeclaringType()
    or
    result.isConstructedFrom(this.getDeclaringType())
  }
}

private class LocalCanonicalField extends CanonicalField {
  Class declaringType;

  LocalCanonicalField() {
    declaringType = this.getDeclaringType() and
    declaringType.isLocal()
  }

  override Field getAField() { result = this }

  override Class getADeclaringType() { result = declaringType }
}

/**
 * A canonical representation of a `Union`. See `CanonicalField` for the explanation for
 * why we need a canonical representation.
 */
abstract class CanonicalUnion extends Union {
  /** Gets a union represented by this canonical union. */
  abstract Union getAUnion();

  /** Gets a canonical field of this canonical union. */
  CanonicalField getACanonicalField() { result.getDeclaringType() = this }
}

private class NonLocalCanonicalUnion extends CanonicalUnion {
  NonLocalCanonicalUnion() { not this.isFromTemplateInstantiation(_) and not this.isLocal() }

  override Union getAUnion() {
    result = this
    or
    result.isConstructedFrom(this)
  }
}

private class LocalCanonicalUnion extends CanonicalUnion {
  LocalCanonicalUnion() { this.isLocal() }

  override Union getAUnion() { result = this }
}

bindingset[f]
pragma[inline_late]
int getFieldSize(CanonicalField f) { result = max(f.getAType().getSize()) }

/**
 * Gets a field in the union `u` whose size
 * is `bytes` number of bytes.
 */
private CanonicalField getAFieldWithSize(CanonicalUnion u, int bytes) {
  result = u.getACanonicalField() and
  bytes = getFieldSize(result)
}

cached
private module Cached {
  cached
  newtype TContent =
    TNonUnionContent(CanonicalField f, int indirectionIndex) {
      // the indirection index for field content starts at 1 (because `TNonUnionContent` is thought of as
      // the address of the field, `FieldAddress` in the IR).
      indirectionIndex = [1 .. max(SsaImpl::getMaxIndirectionsForType(f.getAnUnspecifiedType()))] and
      // Reads and writes of union fields are tracked using `UnionContent`.
      not f.getDeclaringType() instanceof Union
    } or
    TUnionContent(CanonicalUnion u, int bytes, int indirectionIndex) {
      exists(CanonicalField f |
        f = u.getACanonicalField() and
        bytes = getFieldSize(f) and
        // We key `UnionContent` by the union instead of its fields since a write to one
        // field can be read by any read of the union's fields. Again, the indirection index
        // is 1-based (because 0 is considered the address).
        indirectionIndex =
          [1 .. max(SsaImpl::getMaxIndirectionsForType(getAFieldWithSize(u, bytes)
                      .getAnUnspecifiedType())
            )]
      )
    } or
    TElementContent(int indirectionIndex) {
      indirectionIndex = [1 .. getMaxElementContentIndirectionIndex()]
    }

  /**
   * The IR dataflow graph consists of the following nodes:
   * - `Node0`, which injects most instructions and operands directly into the
   *    dataflow graph.
   * - `VariableNode`, which is used to model flow through global variables.
   * - `PostUpdateNodeImpl`, which is used to model the state of an object after
   *    an update after a number of loads.
   * - `SsaSynthNode`, which represents synthesized nodes as computed by the shared SSA
   *    library.
   * - `RawIndirectOperand`, which represents the value of `operand` after
   *    loading the address a number of times.
   * - `RawIndirectInstruction`, which represents the value of `instr` after
   *    loading the address a number of times.
   */
  cached
  newtype TIRDataFlowNode =
    TNode0(Node0Impl node) { DataFlowImplCommon::forceCachingInSameStage() } or
    TGlobalLikeVariableNode(GlobalLikeVariable var, int indirectionIndex) {
      indirectionIndex =
        [getMinIndirectionsForType(var.getUnspecifiedType()) .. SsaImpl::getMaxIndirectionsForType(var.getUnspecifiedType())]
    } or
    TPostUpdateNodeImpl(Operand operand, int indirectionIndex) {
      isPostUpdateNodeImpl(operand, indirectionIndex)
    } or
    TSsaSynthNode(SsaImpl::SynthNode n) or
    TSsaIteratorNode(IteratorFlow::IteratorFlowNode n) or
    TRawIndirectOperand0(Node0Impl node, int indirectionIndex) {
      SsaImpl::hasRawIndirectOperand(node.asOperand(), indirectionIndex)
    } or
    TRawIndirectInstruction0(Node0Impl node, int indirectionIndex) {
      not exists(node.asOperand()) and
      SsaImpl::hasRawIndirectInstruction(node.asInstruction(), indirectionIndex)
    } or
    TFinalParameterNode(Parameter p, int indirectionIndex) {
      exists(SsaImpl::FinalParameterUse use |
        use.getParameter() = p and
        use.getIndirectionIndex() = indirectionIndex
      )
    } or
    TFinalGlobalValue(SsaImpl::GlobalUse globalUse) or
    TInitialGlobalValue(SsaImpl::GlobalDef globalUse) or
    TBodyLessParameterNodeImpl(Parameter p, int indirectionIndex) {
      // Rule out parameters of catch blocks.
      not exists(p.getCatchBlock()) and
      // We subtract one because `getMaxIndirectionsForType` returns the maximum
      // indirection for a glvalue of a given type, and this doesn't apply to
      // parameters.
      indirectionIndex = [0 .. SsaImpl::getMaxIndirectionsForType(p.getUnspecifiedType()) - 1] and
      not any(InitializeParameterInstruction init).getParameter() = p
    } or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn)
}

import Cached

/**
 * An operand that is defined by a `FieldAddressInstruction`.
 */
class FieldAddress extends Operand {
  FieldAddressInstruction fai;

  FieldAddress() { fai = this.getDef() and not SsaImpl::ignoreOperand(this) }

  /** Gets the field associated with this instruction. */
  Field getField() { result = fai.getField() }

  /** Gets the instruction whose result provides the address of the object containing the field. */
  Instruction getObjectAddress() { result = fai.getObjectAddress() }

  /** Gets the operand that provides the address of the object containing the field. */
  Operand getObjectAddressOperand() { result = fai.getObjectAddressOperand() }
}

/**
 * Holds if `opFrom` is an operand whose value flows to the result of `instrTo`.
 *
 * `isPointerArith` is `true` if `instrTo` is a `PointerArithmeticInstruction` and `opFrom`
 * is the left operand.
 *
 * `additional` is `true` if the conversion is supplied by an implementation of the
 * `Indirection` class. It is sometimes useful to exclude such conversions.
 */
predicate conversionFlow(
  Operand opFrom, Instruction instrTo, boolean isPointerArith, boolean additional
) {
  isPointerArith = false and
  (
    additional = false and
    (
      instrTo.(CopyValueInstruction).getSourceValueOperand() = opFrom
      or
      instrTo.(ConvertInstruction).getUnaryOperand() = opFrom
      or
      instrTo.(CheckedConvertOrNullInstruction).getUnaryOperand() = opFrom
      or
      instrTo.(InheritanceConversionInstruction).getUnaryOperand() = opFrom
      or
      exists(BuiltInInstruction builtIn |
        builtIn = instrTo and
        // __builtin_bit_cast
        builtIn.getBuiltInOperation() instanceof BuiltInBitCast and
        opFrom = builtIn.getAnOperand()
      )
    )
    or
    additional = true and
    SsaImpl::isAdditionalConversionFlow(opFrom, instrTo)
  )
  or
  isPointerArith = true and
  additional = false and
  instrTo.(PointerArithmeticInstruction).getLeftOperand() = opFrom
}

module Public {
  import ExprNodes

  /**
   * A node in a data flow graph.
   *
   * A node can be either an expression, a parameter, or an uninitialized local
   * variable. Such nodes are created with `DataFlow::exprNode`,
   * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
   */
  class Node extends TIRDataFlowNode {
    /**
     * INTERNAL: Do not use.
     */
    DataFlowCallable getEnclosingCallable() { none() } // overridden in subclasses

    /** Gets the function to which this node belongs, if any. */
    Declaration getFunction() { none() } // overridden in subclasses

    /** Holds if this node represents a glvalue. */
    predicate isGLValue() { none() }

    /**
     * Gets the type of this node.
     *
     * If `isGLValue()` holds, then the type of this node
     * should be thought of as "pointer to `getType()`".
     */
    Type getType() { none() } // overridden in subclasses

    /** Gets the instruction corresponding to this node, if any. */
    Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

    /** Gets the operands corresponding to this node, if any. */
    Operand asOperand() { result = this.(OperandNode).getOperand() }

    /**
     * Gets the operand that is indirectly tracked by this node behind `index`
     * number of indirections.
     */
    Operand asIndirectOperand(int index) { hasOperandAndIndex(this, result, index) }

    /**
     * Holds if this node is at index `i` in basic block `block`.
     *
     * Note: Phi nodes are considered to be at index `-1`.
     */
    final predicate hasIndexInBlock(IRBlock block, int i) {
      this.asInstruction() = block.getInstruction(i)
      or
      this.asOperand().getUse() = block.getInstruction(i)
      or
      exists(SsaImpl::SynthNode ssaNode |
        this.(SsaSynthNode).getSynthNode() = ssaNode and
        ssaNode.getBasicBlock() = block and
        ssaNode.getIndex() = i
      )
      or
      this.(RawIndirectOperand).getOperand().getUse() = block.getInstruction(i)
      or
      this.(RawIndirectInstruction).getInstruction() = block.getInstruction(i)
      or
      this.(PostUpdateNode).getPreUpdateNode().hasIndexInBlock(block, i)
    }

    /** Gets the basic block of this node, if any. */
    final IRBlock getBasicBlock() { this.hasIndexInBlock(result, _) }

    /**
     * Gets the non-conversion expression corresponding to this node, if any.
     * This predicate only has a result on nodes that represent the value of
     * evaluating the expression. For data flowing _out of_ an expression, like
     * when an argument is passed by reference, use `asDefiningArgument` instead
     * of `asExpr`.
     *
     * If this node strictly (in the sense of `asConvertedExpr`) corresponds to
     * a `Conversion`, then the result is the underlying non-`Conversion` base
     * expression.
     */
    Expr asExpr() { result = this.asExpr(_) }

    /**
     * INTERNAL: Do not use.
     */
    Expr asExpr(int n) { result = this.(ExprNode).getExpr(n) }

    /**
     * INTERNAL: Do not use.
     */
    Expr asIndirectExpr(int n, int index) { result = this.(IndirectExprNode).getExpr(n, index) }

    /**
     * Gets the non-conversion expression that's indirectly tracked by this node
     * under `index` number of indirections.
     */
    Expr asIndirectExpr(int index) { result = this.asIndirectExpr(_, index) }

    /**
     * Gets the non-conversion expression that's indirectly tracked by this node
     * behind a number of indirections.
     */
    Expr asIndirectExpr() { result = this.asIndirectExpr(_) }

    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    Expr asConvertedExpr() { result = this.asConvertedExpr(_) }

    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    Expr asConvertedExpr(int n) { result = this.(ExprNode).getConvertedExpr(n) }

    private Expr asIndirectConvertedExpr(int n, int index) {
      result = this.(IndirectExprNode).getConvertedExpr(n, index)
    }

    /**
     * Gets the expression that's indirectly tracked by this node
     * behind `index` number of indirections.
     */
    Expr asIndirectConvertedExpr(int index) { result = this.asIndirectConvertedExpr(_, index) }

    /**
     * Gets the expression that's indirectly tracked by this node behind a
     * number of indirections.
     */
    Expr asIndirectConvertedExpr() { result = this.asIndirectConvertedExpr(_) }

    /**
     * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
     * This predicate should be used instead of `asExpr` when referring to the
     * value of a reference argument _after_ the call has returned. For example,
     * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
     * that represents the new value of `x`.
     */
    Expr asDefiningArgument() { result = this.asDefiningArgument(_) }

    /**
     * Gets the definition associated with this node, if any.
     *
     * For example, consider the following example
     * ```cpp
     * int x = 42;     // 1
     * x = 34;         // 2
     * ++x;            // 3
     * x++;            // 4
     * x += 1;         // 5
     * int y = x += 2; // 6
     * ```
     * - For (1) the result is `42`.
     * - For (2) the result is `x = 34`.
     * - For (3) the result is `++x`.
     * - For (4) the result is `x++`.
     * - For (5) the result is `x += 1`.
     * - For (6) there are two results:
     *   - For the definition generated by `x += 2` the result is `x += 2`
     *   - For the definition generated by `int y = ...` the result is
     *     also `x += 2`.
     *
     * For assignments, `node.asDefinition()` and `node.asExpr()` will both exist
     * for the same dataflow node. However, for expression such as `x++` that
     * both write to `x` and read the current value of `x`, `node.asDefinition()`
     * will give the node corresponding to the value after the increment, and
     * `node.asExpr()` will give the node corresponding to the value before the
     * increment. For an example of this, consider the following:
     *
     * ```cpp
     * sink(x++);
     * ```
     * in the above program, there will not be flow from a node `n` such that
     * `n.asDefinition() instanceof IncrementOperation` to the argument of `sink`
     * since the value passed to `sink` is the value before to the increment.
     * However, there will be dataflow from a node `n` such that
     * `n.asExpr() instanceof IncrementOperation` since the result of evaluating
     * the expression `x++` is passed to `sink`.
     */
    Expr asDefinition() { result = this.asDefinition(_) }

    private predicate isCertainStore() {
      exists(SsaImpl::Definition def |
        SsaImpl::defToNode(this, def, _) and
        def.isCertain()
      )
    }

    /**
     * Gets the definition associated with this node, if any.
     *
     * For example, consider the following example
     * ```cpp
     * int x = 42;     // 1
     * x = 34;         // 2
     * ++x;            // 3
     * x++;            // 4
     * x += 1;         // 5
     * int y = x += 2; // 6
     * ```
     * - For (1) the result is `42`.
     * - For (2) the result is `x = 34`.
     * - For (3) the result is `++x`.
     * - For (4) the result is `x++`.
     * - For (5) the result is `x += 1`.
     * - For (6) there are two results:
     *   - For the definition generated by `x += 2` the result is `x += 2`
     *   - For the definition generated by `int y = ...` the result is
     *     also `x += 2`.
     *
     * For assignments, `node.asDefinition(_)` and `node.asExpr()` will both exist
     * for the same dataflow node. However, for expression such as `x++` that
     * both write to `x` and read the current value of `x`, `node.asDefinition(_)`
     * will give the node corresponding to the value after the increment, and
     * `node.asExpr()` will give the node corresponding to the value before the
     * increment. For an example of this, consider the following:
     *
     * ```cpp
     * sink(x++);
     * ```
     * in the above program, there will not be flow from a node `n` such that
     * `n.asDefinition(_) instanceof IncrementOperation` to the argument of `sink`
     * since the value passed to `sink` is the value before to the increment.
     * However, there will be dataflow from a node `n` such that
     * `n.asExpr() instanceof IncrementOperation` since the result of evaluating
     * the expression `x++` is passed to `sink`.
     *
     * If `uncertain = false` then the definition is guaranteed to overwrite
     * the entire buffer pointed to by the destination address of the definition.
     * Otherwise, `uncertain = true`.
     *
     * For example, the write `int x; x = 42;` is guaranteed to overwrite all the
     * bytes allocated to `x`, while the assignment `int p[10]; p[3] = 42;` has
     * `uncertain = true` since the write will not overwrite the entire buffer
     * pointed to by `p`.
     */
    Expr asDefinition(boolean uncertain) {
      exists(StoreInstruction store |
        store = this.asInstruction() and
        result = asDefinitionImpl(store) and
        if this.isCertainStore() then uncertain = false else uncertain = true
      )
    }

    /**
     * Gets the definition associated with this node, if this node is a certain definition.
     *
     * See `Node.asDefinition/1` for a description of certain and uncertain definitions.
     */
    Expr asCertainDefinition() { result = this.asDefinition(false) }

    /**
     * Gets the definition associated with this node, if this node is an uncertain definition.
     *
     * See `Node.asDefinition/1` for a description of certain and uncertain definitions.
     */
    Expr asUncertainDefinition() { result = this.asDefinition(true) }

    /**
     * Gets the indirect definition at a given indirection corresponding to this
     * node, if any.
     *
     * See the comments on `Node.asDefinition` for examples.
     */
    Expr asIndirectDefinition(int indirectionIndex) {
      exists(StoreInstruction store |
        this.(IndirectInstruction).hasInstructionAndIndirectionIndex(store, indirectionIndex) and
        result = asDefinitionImpl(store)
      )
    }

    /**
     * Gets the indirect definition at some indirection corresponding to this
     * node, if any.
     */
    Expr asIndirectDefinition() { result = this.asIndirectDefinition(_) }

    /**
     * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
     *
     * Unlike `Node::asDefiningArgument/0`, this predicate gets the node representing
     * the value of the `index`'th indirection after leaving a function. For example,
     * in:
     * ```cpp
     * void f(int**);
     * ...
     * int** x = ...;
     * f(x);
     * ```
     * The node `n` such that `n.asDefiningArgument(1)` is the argument `x` will
     * contain the value of `*x` after `f` has returned, and the node `n` such that
     * `n.asDefiningArgument(2)` is the argument `x` will contain the value of `**x`
     * after the `f` has returned.
     */
    Expr asDefiningArgument(int index) {
      this.(DefinitionByReferenceNode).getIndirectionIndex() = index and
      result = this.(DefinitionByReferenceNode).getArgument()
    }

    /**
     * Gets the the argument going into a function for a node that represents
     * the indirect value of the argument after `index` loads. For example, in:
     * ```cpp
     * void f(int**);
     * ...
     * int** x = ...;
     * f(x);
     * ```
     * The node `n` such that `n.asIndirectArgument(1)` represents the value of
     * `*x` going into `f`, and the node `n` such that `n.asIndirectArgument(2)`
     * represents the value of `**x` going into `f`.
     */
    Expr asIndirectArgument(int index) {
      this.(SideEffectOperandNode).hasAddressOperandAndIndirectionIndex(_, index) and
      result = this.(SideEffectOperandNode).getArgument()
    }

    /**
     * Gets the the argument going into a function for a node that represents
     * the indirect value of the argument after any non-zero number of loads.
     */
    Expr asIndirectArgument() { result = this.asIndirectArgument(_) }

    /** Gets the positional parameter corresponding to this node, if any. */
    Parameter asParameter() {
      exists(int indirectionIndex | result = this.asParameter(indirectionIndex) |
        if result.getUnspecifiedType() instanceof ReferenceType
        then indirectionIndex = 1
        else indirectionIndex = 0
      )
    }

    /**
     * Gets the uninitialized local variable corresponding to this node, if
     * any.
     */
    LocalVariable asUninitialized() { result = this.(UninitializedNode).getLocalVariable() }

    /**
     * Gets the positional parameter corresponding to the node that represents
     * the value of the parameter after `index` number of loads, if any. For
     * example, in:
     * ```cpp
     * void f(int** x) { ... }
     * ```
     * - The node `n` such that `n.asParameter(0)` is the parameter `x` represents
     * the value of `x`.
     * - The node `n` such that `n.asParameter(1)` is the parameter `x` represents
     * the value of `*x`.
     * - The node `n` such that `n.asParameter(2)` is the parameter `x` represents
     * the value of `**x`.
     */
    Parameter asParameter(int index) {
      index = 0 and
      result = this.(ExplicitParameterNode).getParameter()
      or
      this.(IndirectParameterNode).getIndirectionIndex() = index and
      result = this.(IndirectParameterNode).getParameter()
    }

    /**
     * Holds if this node represents the `indirectionIndex`'th indirection of
     * the value of an output parameter `p` just before reaching the end of a function.
     */
    predicate isFinalValueOfParameter(Parameter p, int indirectionIndex) {
      exists(FinalParameterNode n | n = this |
        p = n.getParameter() and
        indirectionIndex = n.getIndirectionIndex()
      )
    }

    /**
     * Holds if this node represents the value of an output parameter `p`
     * just before reaching the end of a function.
     */
    predicate isFinalValueOfParameter(Parameter p) { this.isFinalValueOfParameter(p, _) }

    /**
     * Gets the variable corresponding to this node, if any. This can be used for
     * modeling flow in and out of global variables.
     */
    Variable asVariable() {
      this = TGlobalLikeVariableNode(result, getMinIndirectionsForType(result.getUnspecifiedType()))
    }

    /**
     * Gets the `indirectionIndex`'th indirection of this node's underlying variable, if any.
     *
     * This can be used for modeling flow in and out of global variables.
     */
    Variable asIndirectVariable(int indirectionIndex) {
      indirectionIndex > getMinIndirectionsForType(result.getUnspecifiedType()) and
      this = TGlobalLikeVariableNode(result, indirectionIndex)
    }

    /** Gets an indirection of this node's underlying variable, if any. */
    Variable asIndirectVariable() { result = this.asIndirectVariable(_) }

    /**
     * Gets the expression that is partially defined by this node, if any.
     *
     * Partial definitions are created for field stores (`x.y = taint();` is a partial
     * definition of `x`), and for calls that may change the value of an object (so
     * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
     * a partial definition of `&x`).
     */
    Expr asPartialDefinition() {
      exists(PartialDefinitionNode pdn | this = pdn |
        pdn.getIndirectionIndex() > 0 and
        result = pdn.getDefinedExpr()
      )
    }

    /**
     * Gets an upper bound on the type of this node.
     */
    Type getTypeBound() { result = this.getType() }

    /** Gets the location of this element. */
    final Location getLocation() { result = getLocationCached(this) }

    /** INTERNAL: Do not use. */
    Location getLocationImpl() {
      none() // overridden by subclasses
    }

    /** Gets a textual representation of this element. */
    final string toString() { result = toStringCached(this) }

    /** INTERNAL: Do not use. */
    string toStringImpl() {
      none() // overridden by subclasses
    }
  }

  /**
   * An instruction, viewed as a node in a data flow graph.
   */
  class InstructionNode extends Node0 {
    override InstructionNode0 node;
    Instruction instr;

    InstructionNode() { instr = node.getInstruction() }

    /** Gets the instruction corresponding to this node. */
    Instruction getInstruction() { result = instr }
  }

  /**
   * An operand, viewed as a node in a data flow graph.
   */
  class OperandNode extends Node, Node0 {
    override OperandNode0 node;
    Operand op;

    OperandNode() { op = node.getOperand() }

    /** Gets the operand corresponding to this node. */
    Operand getOperand() { result = op }
  }

  /**
   * A node associated with an object after an operation that might have
   * changed its state.
   *
   * This can be either the argument to a callable after the callable returns
   * (which might have mutated the argument), or the qualifier of a field after
   * an update to the field.
   *
   * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
   * to the value before the update with the exception of `ClassInstanceExpr`,
   * which represents the value after the constructor has run.
   */
  abstract class PostUpdateNode extends Node {
    /**
     * Gets the node before the state update.
     */
    abstract Node getPreUpdateNode();

    final override Type getType() { result = this.getPreUpdateNode().getType() }
  }

  /**
   * The value of an uninitialized local variable, viewed as a node in a data
   * flow graph.
   */
  class UninitializedNode extends Node {
    LocalVariable v;

    UninitializedNode() {
      exists(SsaImpl::Definition def, SsaImpl::SourceVariable sv |
        def.getIndirectionIndex() = 0 and
        def.getValue().asInstruction() instanceof UninitializedInstruction and
        SsaImpl::defToNode(this, def, sv) and
        v = sv.getBaseVariable().(SsaImpl::BaseIRVariable).getIRVariable().getAst()
      )
    }

    /** Gets the uninitialized local variable corresponding to this node. */
    LocalVariable getLocalVariable() { result = v }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph. This includes both explicit parameters such as `x` in `f(x)`
   * and implicit parameters such as `this` in `x.f()`.
   *
   * To match a specific kind of parameter, consider using one of the subclasses
   * `ExplicitParameterNode`, `ThisParameterNode`, or
   * `ParameterIndirectionNode`.
   */
  final class ParameterNode = AbstractParameterNode;

  /** An explicit positional parameter, including `this`, but not `...`. */
  final class DirectParameterNode = AbstractDirectParameterNode;

  final class ExplicitParameterNode = AbstractExplicitParameterNode;

  /** An implicit `this` parameter. */
  class ThisParameterInstructionNode extends AbstractExplicitParameterNode,
    InstructionDirectParameterNode
  {
    ThisParameterInstructionNode() { instr.getIRVariable() instanceof IRThisVariable }

    override predicate isSourceParameterOf(Function f, ParameterPosition pos) {
      pos.(DirectPosition).getArgumentIndex() = -1 and
      instr.getEnclosingFunction() = f
    }

    override string toStringImpl() { result = "this" }
  }

  /**
   * A node that represents the value of a variable after a function call that
   * may have changed the variable because it's passed by reference.
   *
   * A typical example would be a call `f(&x)`. Firstly, there will be flow into
   * `x` from previous definitions of `x`. Secondly, there will be a
   * `DefinitionByReferenceNode` to represent the value of `x` after the call has
   * returned. This node will have its `getArgument()` equal to `&x` and its
   * `getVariableAccess()` equal to `x`.
   */
  class DefinitionByReferenceNode extends IndirectArgumentOutNode {
    DefinitionByReferenceNode() { this.getIndirectionIndex() > 0 }

    /** Gets the unconverted argument corresponding to this node. */
    Expr getArgument() {
      result = this.getAddressOperand().getDef().getUnconvertedResultExpression()
    }

    /** Gets the parameter through which this value is assigned. */
    Parameter getParameter() {
      result = this.getCallInstruction().getStaticCallTarget().getParameter(this.getArgumentIndex())
    }
  }

  /**
   * A `Node` corresponding to a global (or `static` local) variable in the
   * program, as opposed to the value of that variable at some particular point.
   * This is used to model flow through global variables (and `static` local
   * variables).
   *
   * There is no `VariableNode` for non-`static` local variables.
   */
  class VariableNode extends Node, TGlobalLikeVariableNode {
    Variable v;
    int indirectionIndex;

    VariableNode() { this = TGlobalLikeVariableNode(v, indirectionIndex) }

    /** Gets the variable corresponding to this node. */
    Variable getVariable() { result = v }

    /** Gets the indirection index of this node. */
    int getIndirectionIndex() { result = indirectionIndex }

    override Declaration getFunction() { none() }

    override DataFlowCallable getEnclosingCallable() {
      // When flow crosses from one _enclosing callable_ to another, the
      // interprocedural data-flow library discards call contexts and inserts a
      // node in the big-step relation used for human-readable path explanations.
      // Therefore we want a distinct enclosing callable for each `VariableNode`,
      // and that can be the `Variable` itself.
      result.asSourceCallable() = v
    }

    override Type getType() { result = getTypeImpl(v.getUnderlyingType(), indirectionIndex - 1) }

    final override Location getLocationImpl() {
      // Certain variables (such as parameters) can have multiple locations.
      // When there's a unique location we use that one, but if multiple locations
      // exist we default to an unknown location.
      result = unique( | | v.getLocation())
      or
      not exists(unique( | | v.getLocation())) and
      result instanceof UnknownLocation
    }

    override string toStringImpl() { result = stars(this) + v.toString() }
  }

  /**
   * Gets the node corresponding to `instr`.
   */
  InstructionNode instructionNode(Instruction instr) { result.getInstruction() = instr }

  /**
   * Gets the node corresponding to `operand`.
   */
  OperandNode operandNode(Operand operand) { result.getOperand() = operand }

  /**
   * Gets the `Node` corresponding to the value of evaluating `e` or any of its
   * conversions. There is no result if `e` is a `Conversion`. For data flowing
   * _out of_ an expression, like when an argument is passed by reference, use
   * `definitionByReferenceNodeFromArgument` instead.
   */
  ExprNode exprNode(Expr e) { result.getExpr(_) = e }

  /**
   * Gets the `Node` corresponding to the value of evaluating `e`. Here, `e` may
   * be a `Conversion`. For data flowing _out of_ an expression, like when an
   * argument is passed by reference, use
   * `definitionByReferenceNodeFromArgument` instead.
   */
  ExprNode convertedExprNode(Expr e) { result.getConvertedExpr(_) = e }

  /**
   * Gets the `Node` corresponding to the value of `p` at function entry.
   */
  ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

  /**
   * Gets the `Node` corresponding to a definition by reference of the variable
   * that is passed as unconverted `argument` of a call.
   */
  DefinitionByReferenceNode definitionByReferenceNodeFromArgument(Expr argument) {
    result.getArgument() = argument
  }

  /** Gets the `VariableNode` corresponding to the variable `v`. */
  VariableNode variableNode(Variable v) {
    result.getVariable() = v and result.getIndirectionIndex() = 1
  }

  /**
   * Gets the `Node` corresponding to the value of an uninitialized local
   * variable `v`.
   */
  Node uninitializedNode(LocalVariable v) { result.asUninitialized() = v }

  /**
   * Holds if `indirectOperand` is the dataflow node that represents the
   * indirection of `operand` with indirection index `indirectionIndex`.
   */
  predicate hasOperandAndIndex(
    IndirectOperand indirectOperand, Operand operand, int indirectionIndex
  ) {
    indirectOperand.hasOperandAndIndirectionIndex(operand, indirectionIndex)
  }

  /**
   * Holds if `indirectInstr` is the dataflow node that represents the
   * indirection of `instr` with indirection index `indirectionIndex`.
   */
  predicate hasInstructionAndIndex(
    IndirectInstruction indirectInstr, Instruction instr, int indirectionIndex
  ) {
    indirectInstr.hasInstructionAndIndirectionIndex(instr, indirectionIndex)
  }
}

private import Public

/**
 * A node representing an indirection of a parameter.
 */
final class IndirectParameterNode = AbstractIndirectParameterNode;

/**
 * A class that lifts pre-SSA dataflow nodes to regular dataflow nodes.
 */
private class Node0 extends Node, TNode0 {
  Node0Impl node;

  Node0() { this = TNode0(node) }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getEnclosingCallable()
  }

  override Declaration getFunction() { result = node.getFunction() }

  override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toStringImpl() }

  override Type getType() { result = node.getType() }

  override predicate isGLValue() { node.isGLValue() }
}

class PostUpdateNodeImpl extends PartialDefinitionNode, TPostUpdateNodeImpl {
  int indirectionIndex;
  Operand operand;

  PostUpdateNodeImpl() { this = TPostUpdateNodeImpl(operand, indirectionIndex) }

  override Declaration getFunction() { result = operand.getUse().getEnclosingFunction() }

  override DataFlowCallable getEnclosingCallable() {
    result = this.getPreUpdateNode().getEnclosingCallable()
  }

  /** Gets the operand associated with this node. */
  Operand getOperand() { result = operand }

  /** Gets the indirection index associated with this node. */
  override int getIndirectionIndex() { result = indirectionIndex }

  override Location getLocationImpl() { result = operand.getLocation() }

  final override Node getPreUpdateNode() {
    indirectionIndex > 0 and
    hasOperandAndIndex(result, operand, indirectionIndex)
    or
    indirectionIndex = 0 and
    result.asOperand() = operand
  }

  final override Expr getDefinedExpr() {
    result = operand.getDef().getUnconvertedResultExpression()
  }
}

/**
 * The node representing the value of a field after it has been updated.
 */
class PostFieldUpdateNode extends PostUpdateNodeImpl {
  FieldAddress fieldAddress;

  PostFieldUpdateNode() { operand = fieldAddress.getObjectAddressOperand() }

  FieldAddress getFieldAddress() { result = fieldAddress }

  Field getUpdatedField() { result = this.getFieldAddress().getField() }

  override string toStringImpl() {
    result = this.getPreUpdateNode().toStringImpl() + " [post update]"
  }
}

/**
 * The base class for nodes that perform "partial definitions".
 *
 * In contrast to a normal "definition", which provides a new value for
 * something, a partial definition is an expression that may affect a
 * value, but does not necessarily replace it entirely. For example:
 * ```
 * x.y = 1; // a partial definition of the object `x`.
 * x.y.z = 1; // a partial definition of the object `x.y` and `x`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
abstract private class PartialDefinitionNode extends PostUpdateNode {
  /** Gets the indirection index of this node. */
  abstract int getIndirectionIndex();

  /** Gets the expression that is partially defined by this node. */
  abstract Expr getDefinedExpr();
}

/**
 * A node representing the indirection of a value after it
 * has been returned from a function.
 */
class IndirectArgumentOutNode extends PostUpdateNodeImpl {
  override ArgumentOperand operand;

  /**
   * Gets the index of the argument that is associated with this post-
   * update node.
   */
  int getArgumentIndex() {
    exists(CallInstruction call | call.getArgumentOperand(result) = operand)
  }

  /**
   * Gets the `Operand` that represents the address of the value that is being
   * updated.
   */
  Operand getAddressOperand() { result = operand }

  /**
   * Gets the `CallInstruction` that represents the call that updated the
   * argument.
   */
  CallInstruction getCallInstruction() { result.getAnArgumentOperand() = operand }

  /**
   * Gets the `Function` that the call targets, if this is statically known.
   */
  Function getStaticCallTarget() { result = this.getCallInstruction().getStaticCallTarget() }

  override string toStringImpl() {
    exists(string prefix | if indirectionIndex > 0 then prefix = "" else prefix = "pointer to " |
      // This string should be unique enough to be helpful but common enough to
      // avoid storing too many different strings.
      result = prefix + this.getStaticCallTarget().getName() + " output argument"
      or
      not exists(this.getStaticCallTarget()) and
      result = prefix + "output argument"
    )
  }
}

/**
 * Holds if `node` is an indirect operand with columns `(operand, indirectionIndex)`, and
 * `operand` represents a use of the fully converted value of `call`.
 */
private predicate hasOperand(Node node, CallInstruction call, int indirectionIndex, Operand operand) {
  operandForFullyConvertedCall(operand, call) and
  hasOperandAndIndex(node, operand, indirectionIndex)
}

/**
 * Holds if `node` is an indirect instruction with columns `(instr, indirectionIndex)`, and
 * `instr` represents a use of the fully converted value of `call`.
 *
 * Note that `hasOperand(node, _, _, _)` implies `not hasInstruction(node, _, _, _)`.
 */
private predicate hasInstruction(
  Node node, CallInstruction call, int indirectionIndex, Instruction instr
) {
  instructionForFullyConvertedCall(instr, call) and
  hasInstructionAndIndex(node, instr, indirectionIndex)
}

/**
 * A node representing the indirect value of a function call (i.e., a value hidden
 * behind a number of indirections).
 */
class IndirectReturnOutNode extends Node {
  CallInstruction call;
  int indirectionIndex;

  IndirectReturnOutNode() {
    // Annoyingly, we need to pick the fully converted value as the output of the function to
    // make flow through in the shared dataflow library work correctly.
    hasOperand(this, call, indirectionIndex, _)
    or
    hasInstruction(this, call, indirectionIndex, _)
  }

  CallInstruction getCallInstruction() { result = call }

  int getIndirectionIndex() { result = indirectionIndex }

  /** Gets the operand associated with this node, if any. */
  Operand getOperand() { hasOperand(this, call, indirectionIndex, result) }

  /** Gets the instruction associated with this node, if any. */
  Instruction getInstruction() { hasInstruction(this, call, indirectionIndex, result) }
}

/**
 * An `IndirectReturnOutNode` which is used as a destination of a store operation.
 * When it's used for a store operation it's useful to have this be a `PostUpdateNode` for
 * the shared dataflow library's flow-through mechanism to detect flow in cases such as:
 * ```cpp
 * struct MyInt {
 *   int i;
 *   int& getRef() { return i; }
 * };
 * ...
 * MyInt mi;
 * mi.getRef() = source(); // this is detected as a store to `i` via flow-through.
 * sink(mi.i);
 * ```
 */
private class PostIndirectReturnOutNode extends IndirectReturnOutNode, PostUpdateNode {
  PostIndirectReturnOutNode() {
    any(StoreInstruction store).getDestinationAddressOperand() = this.getOperand()
  }

  override Node getPreUpdateNode() { result = this }
}

/**
 * A node that represents the indirect value of an operand in the IR
 * after `index` number of loads.
 */
private class RawIndirectOperand0 extends Node, TRawIndirectOperand0 {
  Node0Impl node;
  int indirectionIndex;

  RawIndirectOperand0() { this = TRawIndirectOperand0(node, indirectionIndex) }

  /** Gets the underlying instruction. */
  Operand getOperand() { result = node.asOperand() }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  override Declaration getFunction() { result = node.getFunction() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getEnclosingCallable()
  }

  override predicate isGLValue() { this.getOperand().isGLValue() }

  override Type getType() {
    exists(int sub, Type type, boolean isGLValue |
      type = getOperandType(this.getOperand(), isGLValue) and
      if isGLValue = true then sub = 1 else sub = 0
    |
      result = getTypeImpl(type.getUnderlyingType(), indirectionIndex - sub)
    )
  }

  final override Location getLocationImpl() {
    if exists(this.getOperand().getLocation())
    then result = this.getOperand().getLocation()
    else result instanceof UnknownLocation
  }

  override string toStringImpl() { result = stars(this) + operandToString(this.getOperand()) }
}

/**
 * A node that represents the indirect value of an instruction in the IR
 * after `index` number of loads.
 */
private class RawIndirectInstruction0 extends Node, TRawIndirectInstruction0 {
  Node0Impl node;
  int indirectionIndex;

  RawIndirectInstruction0() { this = TRawIndirectInstruction0(node, indirectionIndex) }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = node.asInstruction() }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  override Declaration getFunction() { result = node.getFunction() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getEnclosingCallable()
  }

  override predicate isGLValue() { this.getInstruction().isGLValue() }

  override Type getType() {
    exists(int sub, Type type, boolean isGLValue |
      type = getInstructionType(this.getInstruction(), isGLValue) and
      if isGLValue = true then sub = 1 else sub = 0
    |
      result = getTypeImpl(type.getUnderlyingType(), indirectionIndex - sub)
    )
  }

  final override Location getLocationImpl() {
    if exists(this.getInstruction().getLocation())
    then result = this.getInstruction().getLocation()
    else result instanceof UnknownLocation
  }

  override string toStringImpl() {
    result = stars(this) + instructionToString(this.getInstruction())
  }
}

/**
 * A node that represents the indirect value of an operand in the IR
 * after a number of loads.
 */
class RawIndirectOperand extends Node {
  int indirectionIndex;
  Operand operand;

  RawIndirectOperand() {
    exists(Node0Impl node | operand = node.asOperand() |
      this = TRawIndirectOperand0(node, indirectionIndex)
      or
      this = TRawIndirectInstruction0(node, indirectionIndex)
    )
  }

  /** Gets the operand associated with this node. */
  Operand getOperand() { result = operand }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }
}

/**
 * A node that represents the indirect value of an instruction in the IR
 * after a number of loads.
 */
class RawIndirectInstruction extends Node {
  int indirectionIndex;
  Instruction instr;

  RawIndirectInstruction() {
    exists(Node0Impl node | instr = node.asInstruction() |
      this = TRawIndirectOperand0(node, indirectionIndex)
      or
      this = TRawIndirectInstruction0(node, indirectionIndex)
    )
  }

  /** Gets the instruction associated with this node. */
  Instruction getInstruction() { result = instr }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }
}

/**
 * A synthesized SSA node produced by the shared SSA library, viewed as a node
 * in a data flow graph.
 */
class SsaSynthNode extends Node, TSsaSynthNode {
  SsaImpl::SynthNode node;

  SsaSynthNode() { this = TSsaSynthNode(node) }

  /** Gets the synthesized SSA node associated with this node. */
  SsaImpl::SynthNode getSynthNode() { result = node }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = node.getBasicBlock().getEnclosingFunction() }

  override Type getType() { result = node.getSourceVariable().getType() }

  override predicate isGLValue() { node.getSourceVariable().isGLValue() }

  final override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

/**
 * Dataflow nodes necessary for iterator flow
 */
class SsaIteratorNode extends Node, TSsaIteratorNode {
  IteratorFlow::IteratorFlowNode node;

  SsaIteratorNode() { this = TSsaIteratorNode(node) }

  /** Gets the phi node associated with this node. */
  IteratorFlow::IteratorFlowNode getIteratorFlowNode() { result = node }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = node.getFunction() }

  override Type getType() { result = node.getType() }

  final override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

/**
 * A node representing a value after leaving a function.
 */
class SideEffectOperandNode extends Node instanceof IndirectOperand {
  CallInstruction call;
  int argumentIndex;
  ArgumentOperand arg;

  SideEffectOperandNode() {
    arg = call.getArgumentOperand(argumentIndex) and
    IndirectOperand.super.hasOperandAndIndirectionIndex(arg, _)
  }

  CallInstruction getCallInstruction() { result = call }

  /** Gets the underlying operand and the underlying indirection index. */
  predicate hasAddressOperandAndIndirectionIndex(Operand operand, int indirectionIndex) {
    IndirectOperand.super.hasOperandAndIndirectionIndex(operand, indirectionIndex)
  }

  int getArgumentIndex() { result = argumentIndex }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = call.getEnclosingFunction() }

  Expr getArgument() { result = call.getArgument(argumentIndex).getUnconvertedResultExpression() }
}

/**
 * A node representing the value of a global variable just before returning
 * from a function body.
 */
class FinalGlobalValue extends Node, TFinalGlobalValue {
  SsaImpl::GlobalUse globalUse;

  FinalGlobalValue() { this = TFinalGlobalValue(globalUse) }

  /** Gets the underlying SSA use. */
  SsaImpl::GlobalUse getGlobalUse() { result = globalUse }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = globalUse.getIRFunction().getFunction() }

  override Type getType() {
    exists(int indirectionIndex |
      indirectionIndex = globalUse.getIndirectionIndex() and
      result = getTypeImpl(globalUse.getUnderlyingType(), indirectionIndex)
    )
  }

  final override Location getLocationImpl() { result = globalUse.getLocation() }

  override string toStringImpl() { result = globalUse.toString() }
}

/**
 * A node representing the value of a global variable just after entering
 * a function body.
 */
class InitialGlobalValue extends Node, TInitialGlobalValue {
  SsaImpl::GlobalDef globalDef;

  InitialGlobalValue() { this = TInitialGlobalValue(globalDef) }

  /** Gets the underlying SSA definition. */
  SsaImpl::GlobalDef getGlobalDef() { result = globalDef }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = globalDef.getFunction() }

  final override predicate isGLValue() { globalDef.getIndirectionIndex() = 0 }

  override Type getType() { result = globalDef.getUnderlyingType() }

  final override Location getLocationImpl() { result = globalDef.getLocation() }

  override string toStringImpl() { result = globalDef.toString() }
}

/**
 * A node representing a parameter for a function with no body.
 */
class BodyLessParameterNodeImpl extends Node, TBodyLessParameterNodeImpl {
  Parameter p;
  int indirectionIndex;

  BodyLessParameterNodeImpl() { this = TBodyLessParameterNodeImpl(p, indirectionIndex) }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = p.getFunction() }

  /** Gets the indirection index of this node. */
  int getIndirectionIndex() { result = indirectionIndex }

  override Type getType() {
    result = getTypeImpl(p.getUnderlyingType(), this.getIndirectionIndex())
  }

  final override Location getLocationImpl() {
    result = unique( | | p.getLocation())
    or
    count(p.getLocation()) != 1 and
    result instanceof UnknownLocation
  }

  final override string toStringImpl() {
    exists(string prefix | prefix = stars(this) | result = prefix + p.toString())
  }
}

/**
 * A data-flow node used to model flow summaries. That is, a dataflow node
 * that is synthesized to represent a parameter, return value, or other part
 * of a models-as-data modeled function.
 */
class FlowSummaryNode extends Node, TFlowSummaryNode {
  /**
   * Gets the models-as-data `SummaryNode` associated with this dataflow
   * `FlowSummaryNode`.
   */
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  /**
   * Gets the summarized callable that this node belongs to.
   */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  /**
   * Gets the enclosing callable. For a `FlowSummaryNode` this is always the
   * summarized function this node is part of.
   */
  override DataFlowCallable getEnclosingCallable() {
    result.asSummarizedCallable() = this.getSummarizedCallable()
  }

  override Location getLocationImpl() { result = this.getSummarizedCallable().getLocation() }

  override string toStringImpl() { result = this.getSummaryNode().toString() }
}

/**
 * A node representing the indirection of a value that is
 * about to be returned from a function.
 */
class IndirectReturnNode extends Node {
  IndirectReturnNode() {
    this instanceof FinalParameterNode
    or
    this.(IndirectOperand)
        .hasOperandAndIndirectionIndex(any(ReturnValueInstruction ret).getReturnAddressOperand(), _)
  }

  override SourceCallable getEnclosingCallable() { result.asSourceCallable() = this.getFunction() }

  /**
   * Holds if this node represents the value that is returned to the caller
   * through a `return` statement.
   */
  predicate isNormalReturn() { this instanceof IndirectOperand }

  /**
   * Holds if this node represents the value that is returned to the caller
   * by writing to the `argumentIndex`'th argument of the call.
   */
  predicate isParameterReturn(int argumentIndex) {
    this.(FinalParameterNode).getArgumentIndex() = argumentIndex
  }

  /** Gets the indirection index of this indirect return node. */
  int getIndirectionIndex() {
    result = this.(FinalParameterNode).getIndirectionIndex()
    or
    this.(IndirectOperand).hasOperandAndIndirectionIndex(_, result)
  }
}

/**
 * A node representing the value of an output parameter
 * just before reaching the end of a function.
 */
class FinalParameterNode extends Node, TFinalParameterNode {
  Parameter p;
  int indirectionIndex;

  FinalParameterNode() { this = TFinalParameterNode(p, indirectionIndex) }

  /** Gets the parameter associated with this final use. */
  Parameter getParameter() { result = p }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  /** Gets the argument index associated with this final use. */
  final int getArgumentIndex() { result = p.getIndex() }

  override Declaration getFunction() { result = p.getFunction() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Type getType() { result = getTypeImpl(p.getUnderlyingType(), indirectionIndex) }

  final override Location getLocationImpl() {
    // Parameters can have multiple locations. When there's a unique location we use
    // that one, but if multiple locations exist we default to an unknown location.
    result = unique( | | p.getLocation())
    or
    not exists(unique( | | p.getLocation())) and
    result instanceof UnknownLocation
  }

  override string toStringImpl() { result = stars(this) + p.toString() }
}

abstract private class AbstractParameterNode extends Node {
  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isSourceParameterOf(Function f, ParameterPosition pos) { none() }

  /**
   * Holds if this node is the parameter of `sc` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isSummaryParameterOf(
    FlowSummaryImpl::Public::SummarizedCallable sc, ParameterPosition pos
  ) {
    none()
  }

  /**
   * Holds if this node is the parameter of `c` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  final predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    this.isSummaryParameterOf(c.asSummarizedCallable(), pos)
    or
    this.isSourceParameterOf(c.asSourceCallable(), pos)
  }

  /** Gets the `Parameter` associated with this node, if it exists. */
  Parameter getParameter() { none() } // overridden by subclasses
}

abstract private class AbstractIndirectParameterNode extends AbstractParameterNode {
  /** Gets the indirection index of this parameter node. */
  abstract int getIndirectionIndex();
}

pragma[noinline]
private predicate indirectParameterNodeHasArgumentIndexAndIndex(
  IndirectInstructionParameterNode node, int argumentIndex, int indirectionIndex
) {
  node.hasInstructionAndIndirectionIndex(_, indirectionIndex) and
  node.getArgumentIndex() = argumentIndex
}

pragma[noinline]
private predicate indirectPositionHasArgumentIndexAndIndex(
  IndirectionPosition pos, int argumentIndex, int indirectionIndex
) {
  pos.getArgumentIndex() = argumentIndex and
  pos.getIndirectionIndex() = indirectionIndex
}

private class IndirectInstructionParameterNode extends AbstractIndirectParameterNode instanceof IndirectInstruction
{
  InitializeParameterInstruction init;

  IndirectInstructionParameterNode() {
    IndirectInstruction.super.hasInstructionAndIndirectionIndex(init, _)
  }

  int getArgumentIndex() { init.hasIndex(result) }

  override string toStringImpl() {
    exists(string prefix | prefix = stars(this) |
      result = prefix + this.getParameter().toString()
      or
      not exists(this.getParameter()) and
      result = prefix + "this"
    )
  }

  /** Gets the parameter whose indirection is initialized. */
  override Parameter getParameter() { result = init.getParameter() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getFunction()
  }

  override Declaration getFunction() { result = init.getEnclosingFunction() }

  override predicate isSourceParameterOf(Function f, ParameterPosition pos) {
    this.getFunction() = f and
    exists(int argumentIndex, int indirectionIndex |
      indirectPositionHasArgumentIndexAndIndex(pos, argumentIndex, indirectionIndex) and
      indirectParameterNodeHasArgumentIndexAndIndex(this, argumentIndex, indirectionIndex)
    )
  }

  /** Gets the underlying operand and the underlying indirection index. */
  predicate hasInstructionAndIndirectionIndex(Instruction instr, int index) {
    IndirectInstruction.super.hasInstructionAndIndirectionIndex(instr, index)
  }

  final override int getIndirectionIndex() { this.hasInstructionAndIndirectionIndex(init, result) }
}

abstract private class AbstractDirectParameterNode extends AbstractParameterNode { }

/**
 * A non-indirect parameter node that is represented as an `Instruction`.
 */
abstract class InstructionDirectParameterNode extends InstructionNode, AbstractDirectParameterNode {
  final override InitializeParameterInstruction instr;

  /**
   * Gets the `IRVariable` that this parameter references.
   */
  final IRVariable getIRVariable() { result = instr.getIRVariable() }
}

abstract private class AbstractExplicitParameterNode extends AbstractDirectParameterNode { }

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterInstructionNode extends AbstractExplicitParameterNode,
  InstructionDirectParameterNode
{
  ExplicitParameterInstructionNode() { exists(instr.getParameter()) }

  override predicate isSourceParameterOf(Function f, ParameterPosition pos) {
    f.getParameter(pos.(DirectPosition).getArgumentIndex()) = instr.getParameter()
  }

  override string toStringImpl() { result = instr.getParameter().toString() }

  override Parameter getParameter() { result = instr.getParameter() }
}

/**
 * A parameter node that is part of a summary.
 */
class SummaryParameterNode extends AbstractParameterNode, FlowSummaryNode {
  SummaryParameterNode() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), _)
  }

  private ParameterPosition getPosition() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), result)
  }

  override predicate isSummaryParameterOf(
    FlowSummaryImpl::Public::SummarizedCallable c, ParameterPosition p
  ) {
    c = this.getSummarizedCallable() and
    p = this.getPosition()
  }
}

private class DirectBodyLessParameterNode extends AbstractExplicitParameterNode,
  BodyLessParameterNodeImpl
{
  DirectBodyLessParameterNode() { indirectionIndex = 0 }

  override predicate isSourceParameterOf(Function f, ParameterPosition pos) {
    this.getFunction() = f and
    f.getParameter(pos.(DirectPosition).getArgumentIndex()) = p
  }

  override Parameter getParameter() { result = p }
}

private class IndirectBodyLessParameterNode extends AbstractIndirectParameterNode,
  BodyLessParameterNodeImpl
{
  IndirectBodyLessParameterNode() { not this instanceof DirectBodyLessParameterNode }

  override predicate isSourceParameterOf(Function f, ParameterPosition pos) {
    exists(int argumentPosition |
      this.getFunction() = f and
      f.getParameter(argumentPosition) = p and
      indirectPositionHasArgumentIndexAndIndex(pos, argumentPosition, indirectionIndex)
    )
  }

  override int getIndirectionIndex() {
    result = BodyLessParameterNodeImpl.super.getIndirectionIndex()
  }

  override Parameter getParameter() { result = p }
}

/**
 * A `PostUpdateNode` that is part of a flow summary. These are synthesized,
 * for example, when a models-as-data summary models a write to a field since
 * the write needs to target a `PostUpdateNode`.
 */
class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNode {
  SummaryPostUpdateNode() {
    FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), _)
  }

  override Node getPreUpdateNode() {
    FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(),
      result.(FlowSummaryNode).getSummaryNode())
  }
}

/**
 * Returns `t`, but stripped of the outermost pointer, reference, etc.
 *
 * For example, `stripPointers(int*&)` is `int*` and `stripPointers(int*)` is `int`.
 */
private Type stripPointer(Type t) {
  result = any(SsaImpl::Indirection ind | ind.getType() = t).getBaseType()
  or
  result = t.(PointerToMemberType).getBaseType()
  or
  result = t.(FunctionPointerIshType).getBaseType()
}

/**
 * Returns `t`, but stripped of the outer-most `indirectionIndex` number of indirections.
 */
private Type getTypeImpl0(Type t, int indirectionIndex) {
  indirectionIndex = 0 and
  result = t
  or
  indirectionIndex > 0 and
  exists(Type stripped |
    stripped = stripPointer(t.stripTopLevelSpecifiers()) and
    stripped.getUnspecifiedType() != t.getUnspecifiedType() and
    result = getTypeImpl0(stripped, indirectionIndex - 1)
  )
}

/**
 * Returns `t`, but stripped of the outer-most `indirectionIndex` number of indirections.
 *
 * If `indirectionIndex` cannot be stripped off `t`, an `UnknownType` is returned.
 */
bindingset[t, indirectionIndex]
pragma[inline_late]
Type getTypeImpl(Type t, int indirectionIndex) {
  result = getTypeImpl0(t, indirectionIndex)
  or
  not exists(getTypeImpl0(t, indirectionIndex)) and
  result instanceof UnknownType
}
