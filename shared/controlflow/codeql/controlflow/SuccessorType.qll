/**
 * Provides different types of control flow successor types. These are used as
 * edge labels in the control flow graph.
 */
overlay[local]
module;

private import codeql.util.Boolean

/*
 * SuccessorType
 *  |- NormalSuccessor
 *  |   |- DirectSuccessor
 *  |   \- ConditionalSuccessor
 *  |       |- BooleanSuccessor
 *  |       |- NullnessSuccessor
 *  |       |- MatchingSuccessor
 *  |       \- EmptinessSuccessor
 *  \- AbruptSuccessor
 *      |- ExceptionSuccessor
 *      |- ReturnSuccessor
 *      |- ExitSuccessor (program termination)
 *      \- JumpSuccessor
 *          |- BreakSuccessor
 *          |- ContinueSuccessor
 *          |- GotoSuccessor
 *          |- RedoSuccessor // rare, used in Ruby
 *          |- RetrySuccessor // rare, used in Ruby
 *          \- JavaYieldSuccessor
 */

private newtype TSuccessorType =
  TDirectSuccessor() or
  TBooleanSuccessor(Boolean branch) or
  TNullnessSuccessor(Boolean isNull) or
  TMatchingSuccessor(Boolean isMatch) or
  TEmptinessSuccessor(Boolean isEmpty) or
  TExceptionSuccessor() or
  TReturnSuccessor() or
  TExitSuccessor() or
  TBreakSuccessor() or
  TContinueSuccessor() or
  TGotoSuccessor() or
  TRedoSuccessor() or
  TRetrySuccessor() or
  TJavaYieldSuccessor()

/**
 * The type of a control flow successor.
 *
 * A successor is either normal, which covers direct and conditional
 * successors, or abrupt, which covers all other types of successors including
 * for example exceptions, returns, and other jumps.
 */
class SuccessorType extends TSuccessorType {
  /** Gets a textual representation of this successor type. */
  abstract string toString();
}

private class TNormalSuccessor = TDirectSuccessor or TConditionalSuccessor;

/**
 * A normal control flow successor. This is either a direct or a conditional
 * successor.
 */
abstract class NormalSuccessor extends SuccessorType, TNormalSuccessor { }

/** A direct control flow successor. */
class DirectSuccessor extends NormalSuccessor, TDirectSuccessor {
  override string toString() { result = "successor" }
}

private class TConditionalSuccessor =
  TBooleanSuccessor or TMatchingSuccessor or TNullnessSuccessor or TEmptinessSuccessor;

/**
 * A conditional control flow successor. Either a Boolean successor (`BooleanSuccessor`),
 * a nullness successor (`NullnessSuccessor`), a matching successor (`MatchingSuccessor`),
 * or an emptiness successor (`EmptinessSuccessor`).
 */
abstract class ConditionalSuccessor extends NormalSuccessor, TConditionalSuccessor {
  /** Gets the Boolean value of this successor. */
  abstract boolean getValue();
}

/**
 * A Boolean control flow successor.
 *
 * For example, this program fragment:
 *
 * ```csharp
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
class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor {
  override boolean getValue() { this = TBooleanSuccessor(result) }

  override string toString() { result = this.getValue().toString() }
}

/**
 * A nullness control flow successor.
 *
 * For example, this program fragment:
 *
 * ```csharp
 * int? M(string s) => s?.Length;
 * ```
 *
 * has a control flow graph containing nullness successors:
 *
 * ```
 *      enter M
 *        |
 *        s
 *       / \
 *      /   \
 *     /     \
 *  null   non-null
 *     \      |
 *      \   Length
 *       \   /
 *        \ /
 *      exit M
 * ```
 */
class NullnessSuccessor extends ConditionalSuccessor, TNullnessSuccessor {
  /** Holds if this is a `null` successor. */
  predicate isNull() { this = TNullnessSuccessor(true) }

  override boolean getValue() { this = TNullnessSuccessor(result) }

  override string toString() { if this.isNull() then result = "null" else result = "non-null" }
}

/**
 * A matching control flow successor.
 *
 * For example, this program fragment:
 *
 * ```csharp
 * switch (x) {
 *     case 0 :
 *         return 0;
 *     default :
 *         return 1;
 * }
 * ```
 *
 * has a control flow graph containing matching successors:
 *
 * ```
 *      switch
 *        |
 *        x
 *        |
 *      case 0
 *       / \
 *      /   \
 *     /     \
 *  match   no-match
 *    |        \
 * return 0   default
 *              |
 *           return 1
 * ```
 */
class MatchingSuccessor extends ConditionalSuccessor, TMatchingSuccessor {
  /** Holds if this is a match successor. */
  predicate isMatch() { this = TMatchingSuccessor(true) }

  override boolean getValue() { this = TMatchingSuccessor(result) }

  override string toString() { if this.isMatch() then result = "match" else result = "no-match" }
}

/**
 * An emptiness control flow successor.
 *
 * For example, this program fragment:
 *
 * ```csharp
 * foreach (var arg in args)
 * {
 *     yield return arg;
 * }
 * yield return "";
 * ```
 *
 * has a control flow graph containing emptiness successors:
 *
 * ```
 *           args
 *            |
 *        loop-header------<-----
 *           / \                 \
 *          /   \                |
 *         /     \               |
 *        /       \              |
 *     empty    non-empty        |
 *       |          \            |
 * yield return ""   \           |
 *                 var arg       |
 *                    |          |
 *             yield return arg  |
 *                     \_________/
 * ```
 */
class EmptinessSuccessor extends ConditionalSuccessor, TEmptinessSuccessor {
  /** Holds if this is an empty successor. */
  predicate isEmpty() { this = TEmptinessSuccessor(true) }

  override boolean getValue() { this = TEmptinessSuccessor(result) }

  override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
}

private class TAbruptSuccessor =
  TExceptionSuccessor or TReturnSuccessor or TExitSuccessor or TJumpSuccessor;

/** An abrupt control flow successor. */
abstract class AbruptSuccessor extends SuccessorType, TAbruptSuccessor { }

/**
 * An exceptional control flow successor.
 *
 * Example:
 *
 * ```csharp
 * int M(string s)
 * {
 *     if (s == null)
 *         throw new ArgumentNullException(nameof(s));
 *     return s.Length;
 * }
 * ```
 *
 * The callable exit node of `M` is an exceptional successor of the node
 * `throw new ArgumentNullException(nameof(s));`.
 */
class ExceptionSuccessor extends AbruptSuccessor, TExceptionSuccessor {
  override string toString() { result = "exception" }
}

/**
 * A `return` control flow successor.
 *
 * Example:
 *
 * ```csharp
 * void M()
 * {
 *     return;
 * }
 * ```
 *
 * The callable exit node of `M` is a `return` successor of the `return;`
 * statement.
 */
class ReturnSuccessor extends AbruptSuccessor, TReturnSuccessor {
  override string toString() { result = "return" }
}

/**
 * An exit control flow successor.
 *
 * Example:
 *
 * ```csharp
 * int M(string s)
 * {
 *     if (s == null)
 *         System.Environment.Exit(0);
 *     return s.Length;
 * }
 * ```
 *
 * The callable exit node of `M` is an exit successor of the node on line 4.
 */
class ExitSuccessor extends AbruptSuccessor, TExitSuccessor {
  override string toString() { result = "exit" }
}

private class TJumpSuccessor =
  TBreakSuccessor or TContinueSuccessor or TGotoSuccessor or TRedoSuccessor or TRetrySuccessor or
      TJavaYieldSuccessor;

/**
 * A jump control flow successor.
 *
 * This covers non-exceptional, non-local control flow, such as `break`,
 * `continue`, and `goto`.
 */
abstract class JumpSuccessor extends AbruptSuccessor, TJumpSuccessor { }

/** A `break` control flow successor. */
class BreakSuccessor extends JumpSuccessor, TBreakSuccessor {
  override string toString() { result = "break" }
}

/** A `continue` control flow successor. */
class ContinueSuccessor extends JumpSuccessor, TContinueSuccessor {
  override string toString() { result = "continue" }
}

/** A `goto` control flow successor. */
class GotoSuccessor extends JumpSuccessor, TGotoSuccessor {
  override string toString() { result = "goto" }
}

/** A `redo` control flow successor (rare, used in Ruby). */
class RedoSuccessor extends JumpSuccessor, TRedoSuccessor {
  override string toString() { result = "redo" }
}

/** A `retry` control flow successor (rare, used in Ruby). */
class RetrySuccessor extends JumpSuccessor, TRetrySuccessor {
  override string toString() { result = "retry" }
}

/** A Java `yield` control flow successor. */
class JavaYieldSuccessor extends JumpSuccessor, TJavaYieldSuccessor {
  override string toString() { result = "yield" }
}

/** Holds if `t` is an abnormal exit type out of a CFG scope. */
predicate isAbnormalExitType(SuccessorType t) {
  t instanceof ExceptionSuccessor or
  t instanceof ExitSuccessor
}
