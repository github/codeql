/**
 * @name Prototype pollution in utility function
 * @description Recursively copying properties between objects may cause
                accidental modification of a built-in prototype object.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/prototype-pollution-utility
 * @tags security
 *       external/cwe/cwe-400
 *       external/cwe/cwe-471
 */

import javascript
import DataFlow
import PathGraph
import semmle.javascript.dataflow.InferredTypes

/**
 * Gets a node that refers to an element of `array`, likely obtained
 * as a result of enumerating the elements of the array.
 */
SourceNode getAnEnumeratedArrayElement(SourceNode array) {
  exists(MethodCallNode call, string name |
    call = array.getAMethodCall(name) and
    (name = "forEach" or name = "map") and
    result = call.getCallback(0).getParameter(0)
  )
  or
  exists(DataFlow::PropRead read |
    read = array.getAPropertyRead() and
    not exists(read.getPropertyName()) and
    not read.getPropertyNameExpr().analyze().getAType() = TTString() and
    result = read
  )
}

/**
 * A data flow node that refers to the name of a property obtained by enumerating
 * the properties of some object.
 */
abstract class EnumeratedPropName extends DataFlow::Node {
  /**
   * Gets the object whose properties are being enumerated.
   *
   * For example, gets `src` in `for (var key in src)`.
   */
  abstract DataFlow::Node getSourceObject();

  /**
   * Gets a property read that accesses the corresponding property value in the source object.
   *
   * For example, gets `src[key]` in `for (var key in src) { src[key]; }`.
   */
  PropRead getASourceProp() {
    result = AccessPath::getASourceAccess(getSourceObject()).getAPropertyRead() and
    result.getPropertyNameExpr().flow().getImmediatePredecessor*() = this
  }
}

/**
 * Property enumeration through `for-in` for `Object.keys` or similar.
 */
class ForInEnumeratedPropName extends EnumeratedPropName {
  DataFlow::Node object;

  ForInEnumeratedPropName() {
    exists(ForInStmt stmt |
      this = DataFlow::lvalueNode(stmt.getLValue()) and
      object = stmt.getIterationDomain().flow()
    )
    or
    exists(CallNode call |
      call = globalVarRef("Object").getAMemberCall("keys")
      or
      call = globalVarRef("Object").getAMemberCall("getOwnPropertyNames")
      or
      call = globalVarRef("Reflect").getAMemberCall("ownKeys")
    |
      object = call.getArgument(0) and
      this = getAnEnumeratedArrayElement(call)
    )
  }

  override Node getSourceObject() { result = object }
}

/**
 * Property enumeration through `Object.entries`.
 */
class EntriesEnumeratedPropName extends EnumeratedPropName {
  CallNode entries;
  SourceNode entry;

  EntriesEnumeratedPropName() {
    entries = globalVarRef("Object").getAMemberCall("entries") and
    entry = getAnEnumeratedArrayElement(entries) and
    this = entry.getAPropertyRead("0")
  }

  override DataFlow::Node getSourceObject() {
    result = entries.getArgument(0)
  }

  override PropRead getASourceProp() {
    result = super.getASourceProp()
    or
    result = entry.getAPropertyRead("1")
  }
}

/**
 * Holds if the properties of `node` are enumerated locally.
 */
predicate arePropertiesEnumerated(DataFlow::SourceNode node) {
  node = any(EnumeratedPropName name).getASourceObjectRef()
}

/**
 * A dynamic property access that is not obviously an array access.
 */
class DynamicPropRead extends DataFlow::SourceNode, DataFlow::ValueNode {
  // Use IndexExpr instead of PropRead as we're not interested in implicit accesses like
  // rest-patterns and for-of loops.
  override IndexExpr astNode;

  DynamicPropRead() {
    not exists(astNode.getPropertyName()) and
    // Exclude obvious array access
    astNode.getPropertyNameExpr().analyze().getAType() = TTString()
  }

  /** Gets the base of the dynamic read. */
  DataFlow::Node getBase() { result = astNode.getBase().flow() }

  /**
   * Holds if the value of this read was assigned to earlier in the same basic block.
   *
   * For example, this is true for `dst[x]` on line 2 below:
   * ```js
   * dst[x] = {};
   * dst[x][y] = src[y];
   * ```
   */
  predicate hasDominatingAssignment() {
    exists(DataFlow::PropWrite write, BasicBlock bb, int i, int j, SsaVariable ssaVar |
      write = getBase().getALocalSource().getAPropertyWrite() and
      bb.getNode(i) = write.getWriteNode() and
      bb.getNode(j) = astNode and
      i < j and
      write.getPropertyNameExpr() = ssaVar.getAUse() and
      astNode.getIndex() = ssaVar.getAUse()
    )
  }
}

/**
 * Holds if there is a dynamic property assignment of form `base[prop] = rhs`
 * which might act as the writing operation in a recursive merge function.
 *
 * Only assignments to pre-existing objects are of interest, so object/array literals
 * are not included.
 *
 * Additionally, we ignore cases where the properties of `base` are enumerated, as this
 * would typically not happen in a merge function.
 */
predicate dynamicPropWrite(DataFlow::Node base, DataFlow::Node prop, DataFlow::Node rhs) {
  exists(AssignExpr write, IndexExpr index |
    index = write.getLhs() and
    base = index.getBase().flow() and
    prop = index.getPropertyNameExpr().flow() and
    rhs = write.getRhs().flow() and
    not exists(prop.getStringValue()) and
    not arePropertiesEnumerated(base.getALocalSource())
  )
}

/** Gets the name of a property that can lead to `Object.prototype`. */
string unsafePropName() {
  result = "__proto__"
  or
  result = "constructor"
}

/**
 * Flow label representing an unsafe property name, or an object obtained
 * by using such a property in a dynamic read.
 */
class UnsafePropLabel extends FlowLabel {
  UnsafePropLabel() { this = unsafePropName() }
}

/**
 * Tracks data from property enumerations to dynamic property writes.
 *
 * The intent is to find code of the general form:
 * ```js
 * function merge(dst, src) {
 *   for (var key in src)
 *     if (...)
 *       merge(dst[key], src[key])
 *     else
 *       dst[key] = src[key]
 * }
 * ```
 *
 * This configuration is used to find three separate data flow paths originating
 * from a property enumeration, all leading to the same dynamic property write.
 *
 * In particular, the base and property name of the property write should all
 * depend on the enumerated property name (`key`) and the right-hand side should
 * depend on the source property (`src[key]`), while allowing steps of form
 * `x -> x[p]` and `p -> x[p]`.
 *
 * Note that in the above example, the flow from `key` to the base of the write (`dst`)
 * requires stepping through the recursive call.
 * Such a path would be absent for a shallow copying operation, where the `dst` object
 * isn't derived from a property of the source object.
 *
 * This configuration can't enforce that all three paths must end at the same
 * dynamic property write, so we treat the paths independently here and check
 * for coinciding paths afterwards.  This means this configuration can't be used as
 * a standalone configuration like in most path queries.
 */
class PropNameTracking extends DataFlow::Configuration {
  PropNameTracking() { this = "PropNameTracking" }

  override predicate isSource(DataFlow::Node node, FlowLabel label) {
    label instanceof UnsafePropLabel and
    exists(EnumeratedPropName prop |
      node = prop
      or
      node = prop.getASourceProp()
    )
  }

  override predicate isSink(DataFlow::Node node, FlowLabel label) {
    label instanceof UnsafePropLabel and
    (
      dynamicPropWrite(node, _, _) or
      dynamicPropWrite(_, node, _) or
      dynamicPropWrite(_, _, node)
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, FlowLabel predlbl, FlowLabel succlbl
  ) {
    predlbl instanceof UnsafePropLabel and
    succlbl = predlbl and
    (
      // Step through `p -> x[p]`
      exists(PropRead read |
        pred = read.getPropertyNameExpr().flow() and
        not read.(DynamicPropRead).hasDominatingAssignment() and
        succ = read
      )
      or
      // Step through `x -> x[p]`
      exists(DynamicPropRead read |
        not read.hasDominatingAssignment() and
        pred = read.getBase() and
        succ = read
      )
    )
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node)
    or
    exists(ConditionGuardNode guard, SsaRefinementNode refinement |
      node = DataFlow::ssaDefinitionNode(refinement) and
      refinement.getGuard() = guard and
      guard.getTest() instanceof VarAccess and
      guard.getOutcome() = false
    )
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    node instanceof BlacklistEqualityGuard or
    node instanceof WhitelistEqualityGuard or
    node instanceof HasOwnPropertyGuard or
    node instanceof InExprGuard or
    node instanceof InstanceOfGuard or
    node instanceof TypeofGuard or
    node instanceof BlacklistInclusionGuard or
    node instanceof WhitelistInclusionGuard
  }
}

/**
 * Sanitizer guard of form `x === "__proto__"` or `x === "constructor"`.
 */
class BlacklistEqualityGuard extends DataFlow::LabeledBarrierGuardNode, ValueNode {
  override EqualityTest astNode;
  string propName;

  BlacklistEqualityGuard() {
    astNode.getAnOperand().getStringValue() = propName and
    propName = unsafePropName()
  }

  override predicate blocks(boolean outcome, Expr e, FlowLabel label) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity().booleanNot() and
    label = propName
  }
}

/**
 * An equality test with something other than `__proto__` or `constructor`.
 */
class WhitelistEqualityGuard extends DataFlow::LabeledBarrierGuardNode, ValueNode {
  override EqualityTest astNode;

  WhitelistEqualityGuard() {
    not astNode.getAnOperand().getStringValue() = unsafePropName() and
    astNode.getAnOperand() instanceof Literal
  }

  override predicate blocks(boolean outcome, Expr e, FlowLabel label) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity() and
    label instanceof UnsafePropLabel
  }
}

/**
 * Sanitizer guard for calls to `Object.prototype.hasOwnProperty`.
 *
 * A malicious source object will have `__proto__` and/or `constructor` as own properties,
 * but the destination object generally doesn't. It is therefore only a sanitizer when
 * used on the destination object.
 */
class HasOwnPropertyGuard extends DataFlow::BarrierGuardNode, CallNode {
  HasOwnPropertyGuard() {
    // Make sure we handle reflective calls since libraries love to do that.
    getCalleeNode().getALocalSource().(DataFlow::PropRead).getPropertyName() = "hasOwnProperty" and
    exists(getReceiver()) and
    // Try to avoid `src.hasOwnProperty` by requiring that the receiver
    // does not locally have its properties enumerated. Typically there is no
    // reason to enumerate the properties of the destination object.
    not arePropertiesEnumerated(getReceiver().getALocalSource())
  }

  override predicate blocks(boolean outcome, Expr e) {
    e = getArgument(0).asExpr() and outcome = true
  }
}

/**
 * Sanitizer guard for `key in dst`.
 *
 * Since `"__proto__" in obj` and `"constructor" in obj` is true for most objects,
 * this is seen as a sanitizer for `key` in the false outcome.
 */
class InExprGuard extends DataFlow::BarrierGuardNode, DataFlow::ValueNode {
  override InExpr astNode;

  InExprGuard() {
    // Exclude tests of form `key in src` for the same reason as in HasOwnPropertyGuard
    not arePropertiesEnumerated(astNode.getRightOperand().flow().getALocalSource())
  }

  override predicate blocks(boolean outcome, Expr e) {
    e = astNode.getLeftOperand() and outcome = false
  }
}

/**
 * Sanitizer guard for `instanceof` expressions.
 *
 * `Object.prototype instanceof X` is never true, so this blocks the `__proto__` label.
 *
 * It is still possible to get to `Function.prototype` through `constructor.constructor.prototype`
 * so we do not block the `constructor` label.
 */
class InstanceOfGuard extends DataFlow::LabeledBarrierGuardNode, DataFlow::ValueNode {
  override InstanceOfExpr astNode;

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = astNode.getLeftOperand() and outcome = true and label = "__proto__"
  }
}

/**
 * Sanitizer guard of form `typeof x === "object"` or `typeof x === "function"`.
 *
 * The former blocks the `constructor` label as that payload must pass through a function,
 * and the latter blocks the `__proto__` label as that only passes through objects.
 */
class TypeofGuard extends DataFlow::LabeledBarrierGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;
  TypeofExpr typeof;
  string typeofStr;

  TypeofGuard() {
    typeof = astNode.getAnOperand() and
    typeofStr = astNode.getAnOperand().getStringValue()
  }

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = typeof.getOperand() and
    outcome = astNode.getPolarity() and
    (
      typeofStr = "object" and
      label = "constructor"
      or
      typeofStr = "function" and
      label = "__proto__"
    )
    or
    e = typeof.getOperand() and
    outcome = astNode.getPolarity().booleanNot() and
    (
      // If something is not an object, sanitize object, as both must end
      // in non-function prototype object.
      typeofStr = "object" and
      label instanceof UnsafePropLabel
      or
      typeofStr = "function" and
      label = "constructor"
    )
  }
}

/**
 * A check of form `["__proto__"].includes(x)` or similar.
 */
class BlacklistInclusionGuard extends DataFlow::LabeledBarrierGuardNode, InclusionTest {
  UnsafePropLabel label;

  BlacklistInclusionGuard() {
    exists(DataFlow::ArrayCreationNode array |
      array.getAnElement().getStringValue() = label and
      array.flowsTo(getContainerNode())
    )
  }

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    outcome = getPolarity().booleanNot() and
    e = getContainedNode().asExpr() and
    label = lbl
  }
}

/**
 * A check of form `xs.includes(x)` or similar, which sanitizes `x` in the true case.
 */
class WhitelistInclusionGuard extends DataFlow::LabeledBarrierGuardNode {
  WhitelistInclusionGuard() {
    this instanceof TaintTracking::PositiveIndexOfSanitizer or
    this instanceof TaintTracking::InclusionSanitizer
  }

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    this.(TaintTracking::AdditionalSanitizerGuardNode).sanitizes(outcome, e) and
    lbl instanceof UnsafePropLabel
  }
}

/**
 * Gets a meaningful name for `node` if possible.
 */
string getExprName(DataFlow::Node node) {
  result = node.asExpr().(Identifier).getName()
  or
  result = node.asExpr().(DotExpr).getPropertyName()
}

/**
 * Gets a name to display for `node`.
 */
string deriveExprName(DataFlow::Node node) {
  result = getExprName(node)
  or
  not exists(getExprName(node)) and
  result = "this object"
}

/**
 * Holds if the dynamic property write `base[prop] = rhs` can pollute the prototype
 * of `base` due to flow from `enum`.
 *
 * In most cases this will result in an alert, the exception being the case where
 * `base` does not have a prototype at all.
 */
predicate isPrototypePollutingAssignment(Node base, Node prop, Node rhs, EnumeratedPropName enum) {
  dynamicPropWrite(base, prop, rhs) and
  exists(PropNameTracking cfg |
    cfg.hasFlow(enum, base) and
    cfg.hasFlow(enum, prop) and
    cfg.hasFlow(enum.getASourceProp(), rhs)
  )
}

/** Gets a data flow node leading to the base of a prototype-polluting assignment. */
private DataFlow::SourceNode getANodeLeadingToBase(DataFlow::TypeBackTracker t, Node base) {
  t.start() and
  isPrototypePollutingAssignment(base, _, _, _) and
  result = base.getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 |
    result = getANodeLeadingToBase(t2, base).backtrack(t2, t)
  )
}

/**
 * Gets a data flow node leading to the base of dynamic property read leading to a
 * prototype-polluting assignment.
 *
 * For example, this is the `dst` in `dst[key1][key2] = ...`.
 * This dynamic read is where the reference to a built-in prototype object is obtained,
 * and we need this to ensure that this object actually has a prototype.
 */
private DataFlow::SourceNode getANodeLeadingToBaseBase(DataFlow::TypeBackTracker t, Node base) {
  exists(DynamicPropRead read |
    read = getANodeLeadingToBase(t, base) and
    result = read.getBase().getALocalSource()
  )
  or
  exists(DataFlow::TypeBackTracker t2 |
    result = getANodeLeadingToBaseBase(t2, base).backtrack(t2, t)
  )
}

DataFlow::SourceNode getANodeLeadingToBaseBase(Node base) {
  result = getANodeLeadingToBaseBase(DataFlow::TypeBackTracker::end(), base)
}

/** A call to `Object.create(null)`. */
class ObjectCreateNullCall extends CallNode {
  ObjectCreateNullCall() {
    this = globalVarRef("Object").getAMemberCall("create") and
    getArgument(0).asExpr() instanceof NullLiteral
  }
}

from
  PropNameTracking cfg, DataFlow::PathNode source, DataFlow::PathNode sink, EnumeratedPropName enum,
  Node base
where
  cfg.hasFlowPath(source, sink) and
  isPrototypePollutingAssignment(base, _, _, enum) and
  sink.getNode() = base and
  source.getNode() = enum and
  (
    getANodeLeadingToBaseBase(base) instanceof ObjectLiteralNode
    or
    not getANodeLeadingToBaseBase(base) instanceof ObjectCreateNullCall
  )
select base, source, sink,
  "Properties are copied from $@ to $@ without guarding against prototype pollution.",
  enum.getSourceObject(), deriveExprName(enum.getSourceObject()), base, deriveExprName(base)
