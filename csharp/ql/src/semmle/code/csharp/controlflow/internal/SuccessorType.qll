/**
 * INTERNAL: Do not use.
 *
 * Provides different types of control flow successor types.
 */

import csharp
private import semmle.code.csharp.controlflow.internal.Completion
private import semmle.code.csharp.Caching

cached
private newtype TSuccessorType =
  TSuccessorSuccessor() { Stages::ControlFlowStage::forceCachingInSameStage() } or
  TBooleanSuccessor(boolean b) { b = true or b = false } or
  TNullnessSuccessor(boolean isNull) { isNull = true or isNull = false } or
  TMatchingSuccessor(boolean isMatch) { isMatch = true or isMatch = false } or
  TEmptinessSuccessor(boolean isEmpty) { isEmpty = true or isEmpty = false } or
  TReturnSuccessor() or
  TBreakSuccessor() or
  TContinueSuccessor() or
  TGotoSuccessor(string label) { label = any(GotoStmt gs).getLabel() } or
  TExceptionSuccessor(ExceptionClass ec) { exists(ThrowCompletion c | c.getExceptionClass() = ec) } or
  TExitSuccessor()

/** The type of a control flow successor. */
class SuccessorType extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { none() }

  /** Holds if this successor type matches completion `c`. */
  predicate matchesCompletion(Completion c) { none() }
}

/** Provides different types of control flow successor types. */
module SuccessorTypes {
  /** A normal control flow successor. */
  class NormalSuccessor extends SuccessorType, TSuccessorSuccessor {
    override string toString() { result = "successor" }

    override predicate matchesCompletion(Completion c) {
      c instanceof NormalCompletion and
      not c instanceof ConditionalCompletion and
      not c instanceof BreakNormalCompletion
    }
  }

  /**
   * A conditional control flow successor. Either a Boolean successor (`BooleanSuccessor`),
   * a nullness successor (`NullnessSuccessor`), a matching successor (`MatchingSuccessor`),
   * or an emptiness successor (`EmptinessSuccessor`).
   */
  abstract class ConditionalSuccessor extends SuccessorType {
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

    override string toString() { result = getValue().toString() }

    override predicate matchesCompletion(Completion c) {
      c.(BooleanCompletion).getInnerCompletion().(BooleanCompletion).getValue() = this.getValue()
    }
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

    override predicate matchesCompletion(Completion c) {
      if this.isNull() then c.(NullnessCompletion).isNull() else c.(NullnessCompletion).isNonNull()
    }
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
   * has a control flow graph containing macthing successors:
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

    override predicate matchesCompletion(Completion c) {
      if this.isMatch()
      then c.(MatchingCompletion).isMatch()
      else c.(MatchingCompletion).isNonMatch()
    }
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
   *          foreach------<-------
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

    override predicate matchesCompletion(Completion c) {
      if this.isEmpty()
      then c.(EmptinessCompletion).isEmpty()
      else c = any(EmptinessCompletion ec | not ec.isEmpty())
    }
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
  class ReturnSuccessor extends SuccessorType, TReturnSuccessor {
    override string toString() { result = "return" }

    override predicate matchesCompletion(Completion c) { c instanceof ReturnCompletion }
  }

  /**
   * A `break` control flow successor.
   *
   * Example:
   *
   * ```csharp
   * int M(int x)
   * {
   *     while (true)
   *     {
   *         if (x++ > 10)
   *             break;
   *     }
   *     return x;
   * }
   * ```
   *
   * The node `return x;` is a `break` succedssor of the node `break;`.
   */
  class BreakSuccessor extends SuccessorType, TBreakSuccessor {
    override string toString() { result = "break" }

    override predicate matchesCompletion(Completion c) {
      c instanceof BreakCompletion or
      c instanceof BreakNormalCompletion
    }
  }

  /**
   * A `continue` control flow successor.
   *
   * Example:
   *
   * ```csharp
   * int M(int x)
   * {
   *     while (true) {
   *         if (x++ < 10)
   *             continue;
   *     }
   *     return x;
   * }
   * ```
   *
   * The node `while (true) { ... }` is a `continue` successor of the node
   * `continue;`.
   */
  class ContinueSuccessor extends SuccessorType, TContinueSuccessor {
    override string toString() { result = "continue" }

    override predicate matchesCompletion(Completion c) { c instanceof ContinueCompletion }
  }

  /**
   * A `goto` control flow successor.
   *
   * Example:
   *
   * ```csharp
   * int M(int x)
   * {
   *     while (true)
   *     {
   *         if (x++ > 10)
   *             goto Return;
   *     }
   *     Return: return x;
   * }
   * ```
   *
   * The node `Return: return x` is a `goto label` successor of the node
   * `goto Return;`.
   */
  class GotoSuccessor extends SuccessorType, TGotoSuccessor {
    /** Gets the `goto` label. */
    string getLabel() { this = TGotoSuccessor(result) }

    override string toString() { result = "goto(" + this.getLabel() + ")" }

    override predicate matchesCompletion(Completion c) {
      c.(GotoCompletion).getLabel() = this.getLabel()
    }
  }

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
   * The callable exit node of `M` is an exceptional successor (of type
   * `ArgumentNullException`) of the node `throw new ArgumentNullException(nameof(s));`.
   */
  class ExceptionSuccessor extends SuccessorType, TExceptionSuccessor {
    /** Gets the type of exception. */
    ExceptionClass getExceptionClass() { this = TExceptionSuccessor(result) }

    override string toString() { result = "exception(" + getExceptionClass().getName() + ")" }

    override predicate matchesCompletion(Completion c) {
      c.(ThrowCompletion).getExceptionClass() = getExceptionClass()
    }
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
  class ExitSuccessor extends SuccessorType, TExitSuccessor {
    override string toString() { result = "exit" }

    override predicate matchesCompletion(Completion c) { c instanceof ExitCompletion }
  }
}
