/**
 * Provides classes that specify the conditions under which control flows along a given edge.
 */

private import internal.EdgeKindInternal

private newtype TEdgeKind =
  TGotoEdge() or // Single successor (including fall-through)
  TTrueEdge() or // 'true' edge of conditional branch
  TFalseEdge() or // 'false' edge of conditional branch
  TExceptionEdge() or // Thrown exception
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
abstract class EdgeKind extends TEdgeKind {
  /** Gets a textual representation of this edge kind. */
  abstract string toString();
}

/**
 * A "goto" edge, representing the unconditional successor of an `Instruction`
 * or `IRBlock`.
 */
class GotoEdge extends EdgeKind, TGotoEdge {
  final override string toString() { result = "Goto" }
}

/**
 * A "true" edge, representing the successor of a conditional branch when the
 * condition is non-zero.
 */
class TrueEdge extends EdgeKind, TTrueEdge {
  final override string toString() { result = "True" }
}

/**
 * A "false" edge, representing the successor of a conditional branch when the
 * condition is zero.
 */
class FalseEdge extends EdgeKind, TFalseEdge {
  final override string toString() { result = "False" }
}

/**
 * An "exception" edge, representing the successor of an instruction when that
 * instruction's evaluation throws an exception.
 */
class ExceptionEdge extends EdgeKind, TExceptionEdge {
  final override string toString() { result = "Exception" }
}

/**
 * A "default" edge, representing the successor of a `Switch` instruction when
 * none of the case values matches the condition value.
 */
class DefaultEdge extends EdgeKind, TDefaultEdge {
  final override string toString() { result = "Default" }
}

/**
 * A "case" edge, representing the successor of a `Switch` instruction when the
 * the condition value matches a corresponding `case` label.
 */
class CaseEdge extends EdgeKind, TCaseEdge {
  string minValue;
  string maxValue;

  CaseEdge() { this = TCaseEdge(minValue, maxValue) }

  final override string toString() {
    if minValue = maxValue
    then result = "Case[" + minValue + "]"
    else result = "Case[" + minValue + ".." + maxValue + "]"
  }

  /**
   * Gets the smallest value of the switch expression for which control will flow along this edge.
   */
  final string getMinValue() { result = minValue }

  /**
   * Gets the largest value of the switch expression for which control will flow along this edge.
   */
  final string getMaxValue() { result = maxValue }
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
   * Gets the single instance of the `ExceptionEdge` class.
   */
  ExceptionEdge exceptionEdge() { result = TExceptionEdge() }

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
