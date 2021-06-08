/**
 * Defines the public interface to temporary variable tags, which describe the reason a particular
 * `IRTempVariable` was generated.
 */

private import internal.TempVariableTagInternal
private import Imports::TempVariableTag

/**
 * A reason that a particular IR temporary variable was generated. For example, it could be
 * generated to hold the return value of a function, or to hold the result of a `?:` operator
 * computed on each branch. The set of possible `TempVariableTag`s is language-dependent.
 */
class TempVariableTag extends TTempVariableTag {
  /** Gets a textual representation of this tag. */
  string toString() { result = getTempVariableTagId(this) }
}
