/**
 * Provides different types of control flow successor types.
 */
overlay[local?]
module;

import java
private import codeql.util.Boolean

private newtype TSuccessorType =
  TNormalSuccessor() or
  TBooleanSuccessor(Boolean branch) or
  TExceptionSuccessor()

/** The type of a control flow successor. */
class SuccessorType extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { result = "SuccessorType" }
}

/** A normal control flow successor. */
class NormalSuccessor extends SuccessorType, TNormalSuccessor { }

/**
 * An exceptional control flow successor.
 *
 * This marks control flow edges that are taken when an exception is thrown.
 */
class ExceptionSuccessor extends SuccessorType, TExceptionSuccessor { }

/**
 * A conditional control flow successor.
 *
 * This currently only includes boolean successors (`BooleanSuccessor`).
 */
class ConditionalSuccessor extends SuccessorType, TBooleanSuccessor {
  /** Gets the Boolean value of this successor. */
  boolean getValue() { this = TBooleanSuccessor(result) }
}

/**
 * A Boolean control flow successor.
 *
 * For example, this program fragment:
 *
 * ```java
 * if (x < 0)
 *     return 0;
 * else
 *     return 1;
 * ```
 *
 * has a control flow graph containing Boolean successors:
 *
 * ```
 *        if
 *        |
 *      x < 0
 *       / \
 *      /   \
 *     /     \
 *  true    false
 *    |        \
 * return 0   return 1
 * ```
 */
class BooleanSuccessor = ConditionalSuccessor;

/**
 * A nullness control flow successor. This is currently unused for Java.
 */
class NullnessSuccessor extends ConditionalSuccessor {
  NullnessSuccessor() { none() }
}
