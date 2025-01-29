/**
 * @name Type confusion
 * @description Casting a value to an incompatible type can lead to undefined behavior.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id cpp/type-confusion
 * @tags security
 *       external/cwe/cwe-843
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import Flow::PathGraph

/** Holds if `f` is the last field of its declaring class. */
predicate lastField(Field f) {
  exists(Class c | c = f.getDeclaringType() |
    f =
      max(Field cand, int byteOffset |
        cand.getDeclaringType() = c and byteOffset = f.getByteOffset()
      |
        cand order by byteOffset
      )
  )
}

/**
 * Holds if there exists a field in `c2` at offset `offset` that's compatible
 * with `f1`.
 */
bindingset[f1, offset, c2]
pragma[inline_late]
predicate hasCompatibleFieldAtOffset(Field f1, int offset, Class c2) {
  exists(Field f2 | offset = f2.getOffsetInClass(c2) |
    // Let's not deal with bit-fields for now.
    f2 instanceof BitField
    or
    f1.getUnspecifiedType().getSize() = f2.getUnspecifiedType().getSize()
    or
    lastField(f1) and
    f1.getUnspecifiedType().getSize() <= f2.getUnspecifiedType().getSize()
  )
}

/**
 * Holds if `c1` is a prefix of `c2`.
 */
bindingset[c1, c2]
pragma[inline_late]
predicate prefix(Class c1, Class c2) {
  not c1.isPolymorphic() and
  not c2.isPolymorphic() and
  if c1 instanceof Union
  then
    // If it's a union we just verify that one of it's variants is compatible with the other class
    exists(Field f1, int offset |
      // Let's not deal with bit-fields for now.
      not f1 instanceof BitField and
      offset = f1.getOffsetInClass(c1)
    |
      hasCompatibleFieldAtOffset(f1, offset, c2)
    )
  else
    forall(Field f1, int offset |
      // Let's not deal with bit-fields for now.
      not f1 instanceof BitField and
      offset = f1.getOffsetInClass(c1)
    |
      hasCompatibleFieldAtOffset(f1, offset, c2)
    )
}

/**
 * An unsafe cast is any explicit cast that is not
 * a `dynamic_cast`.
 */
class UnsafeCast extends Cast {
  private Class toType;

  UnsafeCast() {
    (
      this instanceof CStyleCast
      or
      this instanceof StaticCast
      or
      this instanceof ReinterpretCast
    ) and
    toType = this.getExplicitlyConverted().getUnspecifiedType().stripType() and
    not this.isImplicit() and
    exists(TypeDeclarationEntry tde |
      tde = toType.getDefinition() and
      not tde.isFromUninstantiatedTemplate(_)
    )
  }

  Class getConvertedType() { result = toType }

  /**
   * Holds if the result of this cast can safely be interpreted as a value of
   * type `t`.
   *
   * The compatibility rules are as follows:
   *
   * 1. the result of `(T)x` is compatible with the type `T` for any `T`
   * 2. the result of `(T)x` is compatible with the type `U` for any `U` such
   *    that `U` is a subtype of `T`, or `T` is a subtype of `U`.
   * 3. the result of `(T)x` is compatible with the type `U` if the list
   *    of fields of `T` is a prefix of the list of fields of `U`.
   *    For example, if `U` is `struct { unsigned char x; int y; };`
   *    and `T` is `struct { unsigned char uc; };`.
   * 4. the result of `(T)x` is compatible with the type `U` if the list
   *    of fields of `U` is a prefix of the list of fields of `T`.
   *
   *    Condition 4 is a bit controversial, since it assumes that the additional
   *    fields in `T` won't be accessed. This may result in some FNs.
   */
  bindingset[this, t]
  pragma[inline_late]
  predicate compatibleWith(Type t) {
    // Conition 1
    t.stripType() = this.getConvertedType()
    or
    // Condition 3
    prefix(this.getConvertedType(), t.stripType())
    or
    // Condition 4
    prefix(t.stripType(), this.getConvertedType())
    or
    // Condition 2 (a)
    t.stripType().(Class).getABaseClass+() = this.getConvertedType()
    or
    // Condition 2 (b)
    t.stripType() = this.getConvertedType().getABaseClass+()
  }
}

/**
 * Holds if `source` is an allocation that allocates a value of type `type`.
 */
predicate isSourceImpl(DataFlow::Node source, Class type) {
  exists(AllocationExpr alloc |
    alloc = source.asExpr() and
    type = alloc.getAllocatedElementType().stripType() and
    not exists(
      alloc
          .(NewOrNewArrayExpr)
          .getAllocator()
          .(OperatorNewAllocationFunction)
          .getPlacementArgument()
    )
  ) and
  exists(TypeDeclarationEntry tde |
    tde = type.getDefinition() and
    not tde.isFromUninstantiatedTemplate(_)
  )
}

/** A configuration describing flow from an allocation to a potentially unsafe cast. */
module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSourceImpl(source, _) }

  predicate isBarrier(DataFlow::Node node) {
    // We disable flow through global variables to reduce FPs from infeasible paths
    node instanceof DataFlow::VariableNode
    or
    exists(Class c | c = node.getType().stripType() |
      not c.hasDefinition()
      or
      exists(TypeDeclarationEntry tde |
        tde = c.getDefinition() and
        tde.isFromUninstantiatedTemplate(_)
      )
    )
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(UnsafeCast cast).getUnconverted() }

  int fieldFlowBranchLimit() { result = 0 }
}

module Flow = DataFlow::Global<Config>;

predicate relevantType(DataFlow::Node sink, Class allocatedType) {
  exists(DataFlow::Node source |
    Flow::flow(source, sink) and
    isSourceImpl(source, allocatedType)
  )
}

predicate isSinkImpl(
  DataFlow::Node sink, Class allocatedType, Type convertedType, boolean compatible
) {
  exists(UnsafeCast cast |
    relevantType(sink, allocatedType) and
    sink.asExpr() = cast.getUnconverted() and
    convertedType = cast.getConvertedType()
  |
    if cast.compatibleWith(allocatedType) then compatible = true else compatible = false
  )
}

from
  Flow::PathNode source, Flow::PathNode sink, Type badSourceType, Type sinkType,
  DataFlow::Node sinkNode
where
  Flow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  isSourceImpl(source.getNode(), badSourceType) and
  isSinkImpl(sinkNode, badSourceType, sinkType, false) and
  // If there is any flow that would result in a valid cast then we don't
  // report an alert here. This reduces the number of FPs from infeasible paths
  // significantly.
  not exists(DataFlow::Node goodSource, Type goodSourceType |
    isSourceImpl(goodSource, goodSourceType) and
    isSinkImpl(sinkNode, goodSourceType, sinkType, true) and
    Flow::flow(goodSource, sinkNode)
  )
select sinkNode, source, sink, "Conversion from $@ to $@ is invalid.", badSourceType,
  badSourceType.toString(), sinkType, sinkType.toString()
