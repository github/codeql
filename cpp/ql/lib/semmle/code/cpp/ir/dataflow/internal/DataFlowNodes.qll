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
import ExprNodes

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

}

private import Public
