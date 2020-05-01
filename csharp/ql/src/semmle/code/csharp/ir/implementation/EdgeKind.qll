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
 * Gets the single instance of `GotoEdge`, representing the unconditional successor of an
 * `Instruction`
 */
GotoEdge gotoEdge() { result = TGotoEdge() }

/**
 * A "true" edge, representing the successor of a conditional branch when the
 * condition is non-zero.
 */
class TrueEdge extends EdgeKind, TTrueEdge {
  final override string toString() { result = "True" }
}

/**
 * Gets the single instance of `TrueEdge`, representing the successor of a conditional branch when
 * the condition is non-zero.
 */
TrueEdge trueEdge() { result = TTrueEdge() }

/**
 * A "false" edge, representing the successor of a conditional branch when the
 * condition is zero.
 */
class FalseEdge extends EdgeKind, TFalseEdge {
  final override string toString() { result = "False" }
}

/**
 * Gets the single instance of `FalseEdge`, representing the successor of a conditional branch when
 * the condition is zero.
 */
FalseEdge falseEdge() { result = TFalseEdge() }

/**
 * An "exception" edge, representing the successor of an instruction when that
 * instruction's evaluation throws an exception.
 */
class ExceptionEdge extends EdgeKind, TExceptionEdge {
  final override string toString() { result = "Exception" }
}

/**
 * Gets the single instance of `ExceptionEdge`, representing the successor of an instruction when
 * that instruction's evaluation throws an exception.
 */
ExceptionEdge exceptionEdge() { result = TExceptionEdge() }

/**
 * A "default" edge, representing the successor of a `Switch` instruction when
 * none of the case values matches the condition value.
 */
class DefaultEdge extends EdgeKind, TDefaultEdge {
  final override string toString() { result = "Default" }
}

/**
 * Gets the single instance of `DefaultEdge`, representing the successor of a `Switch` instruction
 * when none of the case values matches the condition value.
 */
DefaultEdge defaultEdge() { result = TDefaultEdge() }

/**
 * A "case" edge, representing the successor of a `Switch` instruction when the
 * the condition value matches a correponding `case` label.
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

  string getMinValue() { result = minValue }

  string getMaxValue() { result = maxValue }
}

/**
 * Gets the `CaseEdge` representing the successor of a `Switch` instruction corresponding to the
 * `case` label with the specified lower and upper bounds.
 */
CaseEdge caseEdge(string minValue, string maxValue) { result = TCaseEdge(minValue, maxValue) }
