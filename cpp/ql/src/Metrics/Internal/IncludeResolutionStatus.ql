/**
 * @name Include file resolution status
 * @description Counts unresolved and resolved #includes.
 *              This query is for internal use only and may change without notice.
 * @kind table
 * @id cpp/include-resolution-status
 */

import cpp

/**
 * A cannot open file error.
 *
 * Typically this is due to a missing include.
 */
class CannotOpenFileError extends CompilerError {
  CannotOpenFileError() { this.hasTag(["cannot_open_file", "cannot_open_file_reason"]) }
}

select count(CannotOpenFileError e) as failed_includes, count(Include i) as successful_includes
