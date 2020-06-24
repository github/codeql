/**
 * @name Prototype pollution in utility function
 * @description Recursively assigning properties on objects may cause
 *              accidental modification of a built-in prototype object.
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
import semmle.javascript.DynamicPropertyAccess

/**
 * A call of form `x.split(".")` where `x` is a parameter.
 *
 * We restrict this to parameter nodes to focus on "deep assignment" functions.
 */
class SplitCall extends StringSplitCall {
  SplitCall() {
    getSeparator() = "." and
    getBaseString().getALocalSource() instanceof ParameterNode
  }
}

/**
 * Holds if `pred -> succ` should preserve polluted property names.
 */
predicate copyArrayStep(SourceNode pred, SourceNode succ) {
  // x -> [...x]
  exists(SpreadElement spread |
    pred.flowsTo(spread.getOperand().flow()) and
    succ.asExpr().(ArrayExpr).getAnElement() = spread
  )
  or
  // `x -> y` in `y.push( x[i] )`
  exists(MethodCallNode push |
    push = succ.getAMethodCall("push") and
    (
      getAnEnumeratedArrayElement(pred).flowsTo(push.getAnArgument())
      or
      pred.flowsTo(push.getASpreadArgument())
    )
  )
  or
  // x -> x.concat(...)
  exists(MethodCallNode concat_ |
    concat_.getMethodName() = "concat" and
    (pred = concat_.getReceiver() or pred = concat_.getAnArgument()) and
    succ = concat_
  )
}

/**
 * Holds if `node` may refer to a `SplitCall` or a copy thereof, possibly
 * returned through a function call.
 */
predicate isSplitArray(SourceNode node) {
  node instanceof SplitCall
  or
  exists(SourceNode pred | isSplitArray(pred) |
    copyArrayStep(pred, node)
    or
    pred.flowsToExpr(node.(CallNode).getACallee().getAReturnedExpr())
  )
}

/**
 * A property name originating from a `x.split(".")` call.
 */
class SplitPropName extends SourceNode {
  SourceNode array;

  SplitPropName() {
    isSplitArray(array) and
    this = getAnEnumeratedArrayElement(array)
  }

  /**
   * Gets the array from which this property name was obtained (the result from `split`).
   */
  SourceNode getArray() { result = array }

  /** Gets an element accessed on the same underlying array. */
  SplitPropName getAnAlias() { result.getArray() = getArray() }
}

/**
 * Holds if the properties of `node` are enumerated locally.
 */
predicate arePropertiesEnumerated(DataFlow::SourceNode node) {
  node = any(EnumeratedPropName name).getASourceObjectRef()
}

/**
 * Holds if `node` is a source of property names that we consider possible
 * prototype pollution payloads.
 */
predicate isPollutedPropNameSource(DataFlow::Node node) {
  node instanceof EnumeratedPropName
  or
  node instanceof SplitPropName
}

/**
 * Holds if `node` may flow from a source of polluted propery names, possibly
 * into function calls (but not returns).
 */
predicate isPollutedPropName(Node node) {
  isPollutedPropNameSource(node)
  or
  exists(Node pred | isPollutedPropName(pred) |
    node = pred.getASuccessor()
    or
    argumentPassingStep(_, pred, _, node)
    or
    // Handle one level of callbacks
    exists(FunctionNode function, ParameterNode callback, int i |
      pred = callback.getAnInvocation().getArgument(i) and
      argumentPassingStep(_, function, _, callback) and
      node = function.getParameter(i)
    )
  )
}

/**
 * Holds if `node` may refer to `Object.prototype` obtained through dynamic property
 * read of a property obtained through property enumeration.
 */
predicate isPotentiallyObjectPrototype(SourceNode node) {
  exists(Node base, Node key |
    dynamicPropReadStep(base, key, node) and
    isPollutedPropName(key) and
    // Ignore cases where the properties of `base` are enumerated, to avoid FPs
    // where the key came from that enumeration (and thus will not return Object.prototype).
    // For example, `src[key]` in `for (let key in src) { ... src[key] ... }` will generally
    // not return Object.prototype because `key` is an enumerable property of `src`.
    not arePropertiesEnumerated(base.getALocalSource())
  )
  or
  exists(Node use | isPotentiallyObjectPrototype(use.getALocalSource()) |
    argumentPassingStep(_, use, _, node)
  )
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
    not arePropertiesEnumerated(base.getALocalSource()) and
    // Prune writes that are unlikely to modify Object.prototype.
    // This is mainly for performance, but may block certain results due to
    // not tracking out of function returns and into callbacks.
    isPotentiallyObjectPrototype(base.getALocalSource()) and
    // Ignore writes with an obviously safe RHS.
    not exists(Expr e | e = rhs.asExpr() |
      e instanceof Literal or
      e instanceof ObjectExpr or
      e instanceof ArrayExpr
    )
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
    (
      isPollutedPropNameSource(node)
      or
      node = any(EnumeratedPropName prop).getASourceProp()
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
    node instanceof DataFlow::VarAccessBarrier
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    node instanceof BlacklistEqualityGuard or
    node instanceof WhitelistEqualityGuard or
    node instanceof HasOwnPropertyGuard or
    node instanceof InExprGuard or
    node instanceof InstanceOfGuard or
    node instanceof TypeofGuard or
    node instanceof BlacklistInclusionGuard or
    node instanceof WhitelistInclusionGuard or
    node instanceof IsPlainObjectGuard
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
    this instanceof TaintTracking::PositiveIndexOfSanitizer
    or
    this instanceof TaintTracking::MembershipTestSanitizer and
    not this = any(MembershipCandidate::ObjectPropertyNameMembershipCandidate c).getTest() // handled with more precision in `HasOwnPropertyGuard`
  }

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    this.(TaintTracking::AdditionalSanitizerGuardNode).sanitizes(outcome, e) and
    lbl instanceof UnsafePropLabel
  }
}

/**
 * A check of form `isPlainObject(e)` or similar, which sanitizes the `constructor`
 * payload in the true case, since it rejects objects with a non-standard `constructor`
 * property.
 */
class IsPlainObjectGuard extends DataFlow::LabeledBarrierGuardNode, DataFlow::CallNode {
  IsPlainObjectGuard() {
    exists(string name | name = "is-plain-object" or name = "is-extendable" |
      this = moduleImport(name).getACall()
    )
  }

  override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    e = getArgument(0).asExpr() and
    outcome = true and
    lbl = "constructor"
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
  result = "here"
}

/**
 * Holds if the dynamic property write `base[prop] = rhs` can pollute the prototype
 * of `base` due to flow from `propNameSource`.
 *
 * In most cases this will result in an alert, the exception being the case where
 * `base` does not have a prototype at all.
 */
predicate isPrototypePollutingAssignment(Node base, Node prop, Node rhs, Node propNameSource) {
  dynamicPropWrite(base, prop, rhs) and
  isPollutedPropNameSource(propNameSource) and
  exists(PropNameTracking cfg |
    cfg.hasFlow(propNameSource, base) and
    if propNameSource instanceof EnumeratedPropName
    then
      cfg.hasFlow(propNameSource, prop) and
      cfg.hasFlow(propNameSource.(EnumeratedPropName).getASourceProp(), rhs)
    else (
      cfg.hasFlow(propNameSource.(SplitPropName).getAnAlias(), prop) and
      rhs.getALocalSource() instanceof ParameterNode
    )
  )
}

/** Gets a data flow node leading to the base of a prototype-polluting assignment. */
private DataFlow::SourceNode getANodeLeadingToBase(DataFlow::TypeBackTracker t, Node base) {
  t.start() and
  isPrototypePollutingAssignment(base, _, _, _) and
  result = base.getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = getANodeLeadingToBase(t2, base).backtrack(t2, t))
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
  PropNameTracking cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Node prop, Node base,
  string msg, Node col1, Node col2
where
  isPollutedPropName(prop) and
  cfg.hasFlowPath(source, sink) and
  isPrototypePollutingAssignment(base, _, _, prop) and
  sink.getNode() = base and
  source.getNode() = prop and
  (
    getANodeLeadingToBaseBase(base) instanceof ObjectLiteralNode
    or
    not getANodeLeadingToBaseBase(base) instanceof ObjectCreateNullCall
  ) and
  // Generate different messages for deep merge and deep assign cases.
  if prop instanceof EnumeratedPropName
  then (
    col1 = prop.(EnumeratedPropName).getSourceObject() and
    col2 = base and
    msg = "Properties are copied from $@ to $@ without guarding against prototype pollution."
  ) else (
    col1 = prop and
    col2 = base and
    msg =
      "The property chain $@ is recursively assigned to $@ without guarding against prototype pollution."
  )
select base, source, sink, msg, col1, deriveExprName(col1), col2, deriveExprName(col2)
