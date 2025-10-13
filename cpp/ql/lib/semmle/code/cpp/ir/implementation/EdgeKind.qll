/**
 * Provides classes that specify the conditions under which control flows along a given edge.
 */

private import codeql.controlflow.SuccessorType
private import internal.EdgeKindInternal

private newtype TEdgeKind =
  TGotoEdge() or // Single successor (including fall-through)
  TTrueEdge() or // 'true' edge of conditional branch
  TFalseEdge() or // 'false' edge of conditional branch
  TCppExceptionEdge() or // Thrown C++ exception
  TSehExceptionEdge() or // Thrown SEH exception
  TDefaultEdge() or // 'default' label of switch
  TCaseEdge(string minValue, string maxValue) {
    // Case label of switch
    Language::hasCaseEdge(minValue, maxValue)
  }

/**
 * Represents the kind of an edge in the IR control flow graph. Each
 * `Instruction` or `IRBlock` has at most one successor of any single
 * `EdgeKind`.
 */
abstract private class EdgeKindImpl extends TEdgeKind {
  /** Gets a textual representation of this edge kind. */
  abstract string toString();
}

final class EdgeKind = EdgeKindImpl;

private SuccessorType getAMatchingSpecificSuccessorType(EdgeKind k) {
  result.(BooleanSuccessor).getValue() = true and k instanceof TrueEdge
  or
  result.(BooleanSuccessor).getValue() = false and k instanceof FalseEdge
  or
  result instanceof ExceptionSuccessor and k instanceof ExceptionEdge
}

SuccessorType getAMatchingSuccessorType(EdgeKind k) {
  result = getAMatchingSpecificSuccessorType(k)
  or
  not exists(getAMatchingSpecificSuccessorType(k)) and
  result instanceof DirectSuccessor
}

/**
 * A "goto" edge, representing the unconditional successor of an `Instruction`
 * or `IRBlock`.
 */
class GotoEdge extends EdgeKindImpl, TGotoEdge {
  final override string toString() { result = "Goto" }
}

/**
 * A "true" or "false" edge representing a successor of a conditional branch.
 */
abstract private class BooleanEdgeKindImpl extends EdgeKindImpl { }

final class BooleanEdge = BooleanEdgeKindImpl;

/**
 * A "true" edge, representing the successor of a conditional branch when the
 * condition is non-zero.
 */
class TrueEdge extends BooleanEdgeKindImpl, TTrueEdge {
  final override string toString() { result = "True" }
}

/**
 * A "false" edge, representing the successor of a conditional branch when the
 * condition is zero.
 */
class FalseEdge extends BooleanEdgeKindImpl, TFalseEdge {
  final override string toString() { result = "False" }
}

abstract private class ExceptionEdgeImpl extends EdgeKindImpl { }

/**
 * An "exception" edge, representing the successor of an instruction when that
 * instruction's evaluation throws an exception.
 *
 * Exception edges are expclitly sublcassed to `CppExceptionEdge` and `SehExceptionEdge`
 * only. Further sublcasses, if required, should be added privately here for IR efficiency.
 */
final class ExceptionEdge = ExceptionEdgeImpl;

/**
 * An "exception" edge, representing the successor of an instruction when that
 * instruction's evaluation throws a C++ exception.
 */
class CppExceptionEdge extends ExceptionEdgeImpl, TCppExceptionEdge {
  final override string toString() { result = "C++ Exception" }
}

/**
 * An "exception" edge, representing the successor of an instruction when that
 * instruction's evaluation throws an SEH exception.
 */
class SehExceptionEdge extends ExceptionEdgeImpl, TSehExceptionEdge {
  final override string toString() { result = "SEH Exception" }
}

/**
 * An edge from a `Switch` instruction to one of the cases, or to the default
 * branch.
 */
abstract private class SwitchEdgeKindImpl extends EdgeKindImpl {
  /**
   * Gets the smallest value of the switch expression for which control will flow along this edge.
   */
  string getMinValue() { none() }

  /**
   * Gets the largest value of the switch expression for which control will flow along this edge.
   */
  string getMaxValue() { none() }

  /**
   * Gets the unique value of the switch expression for which control will
   * flow along this edge, if any.
   */
  final string getValue() { result = unique( | | [this.getMinValue(), this.getMaxValue()]) }

  /** Holds if this edge is the default edge. */
  predicate isDefault() { none() }
}

final class SwitchEdge = SwitchEdgeKindImpl;

/**
 * A "default" edge, representing the successor of a `Switch` instruction when
 * none of the case values matches the condition value.
 */
class DefaultEdge extends SwitchEdgeKindImpl, TDefaultEdge {
  final override string toString() { result = "Default" }

  final override predicate isDefault() { any() }
}

/**
 * A "case" edge, representing the successor of a `Switch` instruction when the
 * the condition value matches a corresponding `case` label.
 */
class CaseEdge extends SwitchEdgeKindImpl, TCaseEdge {
  string minValue;
  string maxValue;

  CaseEdge() { this = TCaseEdge(minValue, maxValue) }

  final override string toString() {
    if minValue = maxValue
    then result = "Case[" + minValue + "]"
    else result = "Case[" + minValue + ".." + maxValue + "]"
  }

  final override string getMinValue() { result = minValue }

  final override string getMaxValue() { result = maxValue }
}

/**
 * Predicates to access the single instance of each `EdgeKind` class.
 */
module EdgeKind {
  /**
   * Gets the single instance of the `GotoEdge` class.
   */
  GotoEdge gotoEdge() { result = TGotoEdge() }

  /**
   * Gets the single instance of the `TrueEdge` class.
   */
  TrueEdge trueEdge() { result = TTrueEdge() }

  /**
   * Gets the single instance of the `FalseEdge` class.
   */
  FalseEdge falseEdge() { result = TFalseEdge() }

  /**
   * Gets the single instance of the `CppExceptionEdge` class.
   */
  CppExceptionEdge cppExceptionEdge() { result = TCppExceptionEdge() }

  /**
   * Gets the single instance of the `SehExceptionEdge` class.
   */
  SehExceptionEdge sehExceptionEdge() { result = TSehExceptionEdge() }

  /**
   * Gets the single instance of the `DefaultEdge` class.
   */
  DefaultEdge defaultEdge() { result = TDefaultEdge() }

  /**
   * Gets the `CaseEdge` representing a `case` label with the specified lower and upper bounds.
   * For example:
   * ```
   * switch (x) {
   *   case 1:  // Edge kind is `caseEdge("1", "1")`
   *     return x;
   *   case 2...8:  // Edge kind is `caseEdge("2", "8")`
   *     return x - 1;
   *   default:  // Edge kind is `defaultEdge()`
   *     return 0;
   *  }
   * ```
   */
  CaseEdge caseEdge(string minValue, string maxValue) { result = TCaseEdge(minValue, maxValue) }
}
