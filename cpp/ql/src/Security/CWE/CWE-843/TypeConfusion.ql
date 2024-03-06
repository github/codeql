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
import BadFlow::PathGraph

/**
 * Holds if `f` is a field located at byte offset `offset` in `c`.
 *
 * Note that predicate is recursive, so that given the following:
 * ```cpp
 * struct S1 {
 *   int a;
 *   void* b;
 * };
 *
 * struct S2 {
 *   S1 s1;
 *   char c;
 * };
 * ```
 * both `hasAFieldWithOffset(S2, s1, 0)` and `hasAFieldWithOffset(S2, a, 0)`
 * holds.
 */
predicate hasAFieldWithOffset(Class c, Field f, int offset) {
  // Base case: `f` is a field in `c`.
  f = c.getAField() and
  offset = f.getByteOffset() and
  not f.getUnspecifiedType().(Class).hasDefinition()
  or
  // Otherwise, we find the struct that is a field of `c` which then has
  // the field `f` as a member.
  exists(Field g |
    g = c.getAField() and
    // Find the field with the largest offset that's less than or equal to
    // offset. That's the struct we need to search recursively.
    g =
      max(Field cand, int candOffset |
        cand = c.getAField() and
        candOffset = cand.getByteOffset() and
        offset >= candOffset
      |
        cand order by candOffset
      ) and
    hasAFieldWithOffset(g.getUnspecifiedType(), f, offset - g.getByteOffset())
  )
}

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
  exists(Field f2 | hasAFieldWithOffset(c2, f2, offset) |
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
      hasAFieldWithOffset(c1, f1, offset)
    |
      hasCompatibleFieldAtOffset(f1, offset, c2)
    )
  else
    forall(Field f1, int offset |
      // Let's not deal with bit-fields for now.
      not f1 instanceof BitField and
      hasAFieldWithOffset(c1, f1, offset)
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

  bindingset[this, t]
  pragma[inline_late]
  predicate compatibleWith(Type t) {
    t.stripType() = this.getConvertedType()
    or
    prefix(this.getConvertedType(), t.stripType())
    or
    t.stripType().(Class).getABaseClass+() = this.getConvertedType()
    or
    t.stripType() = this.getConvertedType().getABaseClass+()
  }
}

/**
 * Holds if `source` is an allocation that allocates a value of type `state`.
 */
predicate isSourceImpl(DataFlow::Node source, Class state) {
  state = source.asExpr().(AllocationExpr).getAllocatedElementType().stripType() and
  exists(TypeDeclarationEntry tde |
    tde = state.getDefinition() and
    not tde.isFromUninstantiatedTemplate(_)
  )
}

/**
 * The `RelevantStateConfig` configuration is used to find the set of
 * states for the `BadConfig` and `GoodConfig`. The flow computed by
 * `RelevantStateConfig` is used to implement the `relevantState` predicate
 * which is used to avoid a cartesian product in `isSinkImpl`.
 */
module RelevantStateConfig implements DataFlow::ConfigSig {
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

  predicate isSink(DataFlow::Node sink) {
    exists(UnsafeCast cast | sink.asExpr() = cast.getUnconverted())
  }
}

module RelevantStateFlow = DataFlow::Global<RelevantStateConfig>;

predicate relevantState(DataFlow::Node sink, Class state) {
  exists(DataFlow::Node source |
    RelevantStateFlow::flow(source, sink) and
    isSourceImpl(source, state)
  )
}

predicate isSinkImpl(DataFlow::Node sink, Class state, Type convertedType, boolean compatible) {
  exists(UnsafeCast cast |
    relevantState(sink, state) and
    sink.asExpr() = cast.getUnconverted() and
    convertedType = cast.getConvertedType()
  |
    if cast.compatibleWith(state) then compatible = true else compatible = false
  )
}

/**
 * The `BadConfig` configuration tracks flow from an allocation to an
 * incompatible cast.
 *
 * We use `FlowState` to track the type of the source, and compare the
 * flow state to the target of the cast in the `isSink` definition.
 */
module BadConfig implements DataFlow::StateConfigSig {
  class FlowState extends Class {
    FlowState() { relevantState(_, this) }
  }

  predicate isSource(DataFlow::Node source, FlowState state) { isSourceImpl(source, state) }

  predicate isBarrier(DataFlow::Node node) { RelevantStateConfig::isBarrier(node) }

  predicate isSink(DataFlow::Node sink, FlowState state) { isSinkImpl(sink, state, _, false) }

  predicate isBarrierOut(DataFlow::Node sink, FlowState state) { isSink(sink, state) }
}

module BadFlow = DataFlow::GlobalWithState<BadConfig>;

/**
 * The `GoodConfig` configuration tracks flow from an allocation to a
 * compatible cast.
 *
 * We use `GoodConfig` to reduce the number of FPs from infeasible paths.
 * For example, consider the following example:
 * ```cpp
 * struct Animal { virtual ~Animal(); };
 *
 * struct Cat : public Animal {
 *   Cat();
 *   ~Cat();
 * };
 *
 * struct Dog : public Animal {
 *   Dog();
 *   ~Dog();
 * };
 *
 * void test9(bool b) {
 *   Animal* a;
 *   if(b) {
 *     a = new Cat;
 *   } else {
 *     a = new Dog;
 *   }
 *   if(b) {
 *    Cat* d = static_cast<Cat*>(a);
 *   }
 * }
 * ```
 * Here, `BadConfig` finds a flow from `a = new Dog` to `static_cast<Cat*>(a)`.
 * However, that path is never realized in an actual execution path. So in
 * order to remove this result we exclude results where there exists an
 * allocation of a type that's compatible with `static_cast<Cat*>(a)`.
 *
 * We use `FlowState` to track the type of the source, and compare the
 * flow state to the target of the cast in the `isSink` definition.
 */
module GoodConfig implements DataFlow::StateConfigSig {
  class FlowState = BadConfig::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) { BadConfig::isSource(source, state) }

  predicate isBarrier(DataFlow::Node node) { BadConfig::isBarrier(node) }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    isSinkImpl(sink, state, _, true) and
    BadFlow::flowTo(sink)
  }
}

module GoodFlow = DataFlow::GlobalWithState<GoodConfig>;

from
  BadFlow::PathNode source, BadFlow::PathNode sink, Type sourceType, Type sinkType,
  DataFlow::Node sinkNode
where
  BadFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  // If there is any flow that would result in a valid cast then we don't
  // report an alert here. This reduces the number of FPs from infeasible paths
  // significantly.
  not GoodFlow::flowTo(sinkNode) and
  isSourceImpl(source.getNode(), sourceType) and
  isSinkImpl(sinkNode, _, sinkType, false)
select sinkNode, source, sink, "Conversion from $@ to $@ is invalid.", sourceType,
  sourceType.toString(), sinkType, sinkType.toString()
