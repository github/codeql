/**
 * Provides classes implementing a simple intra-procedural flow analysis for inferring abstract
 * values of nodes in the data-flow graph representation of the program.
 *
 * Properties of object literals and class/function instances are tracked to some degree, but
 * completeness should not be relied upon.
 *
 * The abstract value inference consists of a _local_ layer implemented by
 * `AnalyzedNode.getALocalValue()` and a _full_ layer implemented by
 * `AnalyzedNode.getAValue()`. The former only models flow through expressions, variables
 * (both local and global), IIFEs, ES6 imports that can be resolved unambiguously, and
 * flow through properties of CommonJS `module` and `exports` objects (including `require`).
 *
 * The full layer adds some modeling of flow through properties of object literals and of
 * function/class instances: any value that flows into the right-hand-side of a write to
 * property `p` of an abstract value `a` that represents an object literal or instance is
 * considered to flow out of all reads of `p` on `a`. However, in inferring which abstract
 * value `a` some property read or write refers to and what flows into the right-hand-side
 * of a property write, only local reasoning is used. In particular, the full layer does
 * not allow reasoning about nested property writes of the form `p.q.r` (except where `p.q`
 * is a module/exports object and hence handled by local flow).
 *
 * Also note that object inheritance is not modelled. Soundness is, however, preserved in
 * the sense that all expressions whole value derives (directly or indirectly) from a property
 * read are marked as indefinite.
 */

private import javascript
import AbstractValues
import AbstractProperties
private import InferredTypes
private import Refinements
private import internal.AbstractValuesImpl
import internal.BasicExprTypeInference
import internal.InterModuleTypeInference
import internal.InterProceduralTypeInference
import internal.PropertyTypeInference
import internal.VariableTypeInference

/**
 * A data flow node for which analysis results are available.
 */
class AnalyzedNode extends DataFlow::Node {
  /**
   * Gets another data flow node whose value flows into this node in one local step
   * (that is, not involving global variables).
   */
  AnalyzedNode localFlowPred() { result = getAPredecessor() }

  /**
   * Gets an abstract value that this node may evaluate to at runtime.
   *
   * This predicate tracks flow through expressions, variables (both local
   * and global), IIFEs, ES6-style imports that can be resolved uniquely, and
   * the properties of CommonJS `module` and `exports` objects. Some limited
   * tracking through the properties of object literals and function/class
   * instances is also performed.
   */
  cached
  AbstractValue getAValue() { result = getALocalValue() }

  /**
   * INTERNAL: Do not use.
   *
   * Gets an abstract value that this node may evaluate to at runtime.
   *
   * This predicate tracks flow through expressions, variables (both local
   * and global), IIFEs, ES6-style imports that can be resolved uniquely, and
   * the properties of CommonJS `module` and `exports` objects. No
   * tracking through the properties of object literals and function/class
   * instances is performed, other than those accounted for by `globalFlowPred`.
   */
  cached
  AbstractValue getALocalValue() {
    // model flow from other nodes; we do not currently
    // feed back the results from the (value) flow analysis into
    // the control flow analysis, so all flow predecessors are
    // considered as sources
    result = localFlowPred().getALocalValue()
    or
    // model flow that isn't captured by the data flow graph
    exists(DataFlow::Incompleteness cause |
      isIncomplete(cause) and result = TIndefiniteAbstractValue(cause)
    )
  }

  /** Gets a type inferred for this node. */
  pragma[nomagic]
  InferredType getAType() { result = getAValue().getType() }

  /**
   * Gets a primitive type to which the value of this node can be coerced.
   */
  PrimitiveType getAPrimitiveType() { result = getAValue().toPrimitive().getType() }

  /** Gets a Boolean value that this node evaluates to. */
  boolean getABooleanValue() { result = getAValue().getBooleanValue() }

  /** Gets the unique Boolean value that this node evaluates to, if any. */
  boolean getTheBooleanValue() { forex(boolean bv | bv = getABooleanValue() | result = bv) }

  /** Gets the unique type inferred for this node, if any. */
  InferredType getTheType() { result = unique(InferredType t | t = getAType()) }

  /**
   * Gets a pretty-printed representation of all types inferred for this node
   * as a comma-separated list, with the last comma being spelled "or".
   *
   * This is useful for violation message, since some expressions (in
   * particular addition) may have more than one inferred type.
   */
  string ppTypes() {
    exists(int n | n = getNumTypes() |
      // inferred no types
      n = 0 and result = ""
      or
      // inferred a single type
      n = 1 and result = getAType().toString()
      or
      // inferred all types
      n = count(InferredType it) and result = ppAllTypeTags()
      or
      // the general case: more than one type, but not all types
      // first pretty-print as a comma separated list, then replace last comma by "or"
      result = (getType(1) + ", " + ppTypes(2)).regexpReplaceAll(", ([^,]++)$", " or $1")
    )
  }

  /**
   * Gets the `i`th type inferred for this node in lexicographical order.
   *
   * Only defined if the number of types inferred for this node is between two
   * and one less than the total number of types.
   */
  private string getType(int i) {
    getNumTypes() in [2 .. count(InferredType it) - 1] and
    result = rank[i](InferredType tp | tp = getAType() | tp.toString())
  }

  /** Gets the number of types inferred for this node. */
  private int getNumTypes() { result = count(getAType()) }

  /**
   * Gets a pretty-printed comma-separated list of all types inferred for this node,
   * in lexicographical order, starting with the `i`th type (1-based), where `i` ranges
   * between two and one less than the total number of types. The single-type case and
   * the all-types case are handled specially above.
   */
  private string ppTypes(int i) {
    exists(int n | n = getNumTypes() and n in [2 .. count(InferredType it) - 1] |
      i = n and result = getType(i)
      or
      i in [2 .. n - 1] and result = getType(i) + ", " + ppTypes(i + 1)
    )
  }

  /** Holds if the flow analysis can infer at least one abstract value for this node. */
  predicate hasFlow() { exists(getAValue()) }

  /**
   * INTERNAL. Use `isIncomplete()` instead.
   *
   * Subclasses may override this to contribute additional incompleteness to this node
   * without overriding `isIncomplete()`.
   */
  predicate hasAdditionalIncompleteness(DataFlow::Incompleteness cause) { none() }
}

/**
 * A value node for which analysis results are available.
 */
class AnalyzedValueNode extends AnalyzedNode, DataFlow::ValueNode { }

/**
 * A module for which analysis results are available.
 *
 * The type inference supports AMD, CommonJS and ES2015 modules. All three
 * variants are modelled as CommonJS modules, with `module` object and a default
 * `exports` object which is the initial value of `module.exports`. ES2015
 * exports are modelled as property writes on `module.exports`, and imports
 * as property reads on any potential value of `module.exports`.
 */
class AnalyzedModule extends TopLevel {
  Module m;

  AnalyzedModule() { this = m }

  /** Gets the name of this module. */
  string getName() { result = m.getName() }

  /**
   * Gets the abstract value representing this module's `module` object.
   */
  AbstractModuleObject getModuleObject() { result.getModule() = this }

  /**
   * Gets the abstract property representing this module's `module.exports`
   * property.
   */
  AbstractProperty getExportsProperty() {
    result.getBase() = getModuleObject() and
    result.getPropertyName() = "exports"
  }

  /**
   * Gets an abstract value inferred for this module's `module.exports`
   * property.
   */
  AbstractValue getAnExportsValue() { result = getExportsProperty().getAValue() }

  /**
   * Gets an abstract value representing a value exported by this module
   * under the given `name`.
   */
  AbstractValue getAnExportedValue(string name) {
    exists(AbstractValue exports | exports = getAnExportsValue() |
      // CommonJS modules export `module.exports` as their `default`
      // export in an ES2015 setting
      not m instanceof ES2015Module and
      name = "default" and
      result = exports
      or
      exists(AbstractProperty exported |
        exported.getBase() = exports and
        exported.getPropertyName() = name and
        result = exported.getAValue()
      )
    )
  }
}

/**
 * Flow analysis for functions.
 */
class AnalyzedFunction extends DataFlow::AnalyzedValueNode {
  override Function astNode;

  override AbstractValue getALocalValue() { result = TAbstractFunction(astNode) }

  /**
   * Gets a return value for a call to this function.
   */
  AbstractValue getAReturnValue() {
    // explicit return value
    result = astNode.getAReturnedExpr().analyze().getALocalValue()
    or
    // implicit return value
    (
      // either because execution of the function may terminate normally
      mayReturnImplicitly()
      or
      // or because there is a bare `return;` statement
      exists(ReturnStmt ret | ret = astNode.getAReturnStmt() | not exists(ret.getExpr()))
    ) and
    result = TAbstractUndefined()
  }

  /**
   * Holds if the execution of this function may complete normally without
   * encountering a `return` or `throw` statement.
   *
   * Note that this is an overapproximation, that is, the predicate may hold
   * of functions that cannot actually complete normally, since it does not
   * account for `finally` blocks and does not check reachability.
   */
  private predicate mayReturnImplicitly() { terminalNode(astNode, any(ExprOrStmt st)) }
}

pragma[noinline]
private predicate terminalNode(Function f, ControlFlowNode final) {
  final.isAFinalNodeOfContainer(f) and
  not final instanceof ReturnStmt and
  not final instanceof ThrowStmt
}

/**
 * Flow analysis for generator functions.
 */
private class AnalyzedGeneratorFunction extends AnalyzedFunction {
  AnalyzedGeneratorFunction() { astNode.isGenerator() }

  override AbstractValue getAReturnValue() { result = TAbstractOtherObject() }
}

/**
 * Flow analysis for async functions.
 */
private class AnalyzedAsyncFunction extends AnalyzedFunction {
  AnalyzedAsyncFunction() { astNode.isAsync() }

  override AbstractValue getAReturnValue() { result = TAbstractOtherObject() }
}
