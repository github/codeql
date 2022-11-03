/**
 * @name Taint test
 * @kind table
 * @id cpp/points-to/tainted-format-strings
 * @deprecated This query is not suitable for production use and has been deprecated.
 */

import cpp
import semmle.code.cpp.pointsto.PointsTo
import semmle.code.cpp.pointsto.CallGraph

predicate inputArgument(string function, int arg) {
  function = "read" and arg = 1
  or
  function = "fread" and arg = 0
  or
  function = "fgets" and arg = 0
  // ... add more
}

predicate inputBuffer(Expr e) {
  exists(FunctionCall fc, string fname, int i |
    fc.getTarget().getName() = fname and
    inputArgument(fname, i) and
    e = fc.getArgument(i)
  )
}

class InputBuffer extends PointsToExpr {
  InputBuffer() { inputBuffer(this) }

  override predicate interesting() { inputBuffer(this) }
}

predicate formatArgument(string function, int i) {
  function = "printf" and i = 0
  or
  function = "fprintf" and i = 1
  or
  function = "sprintf" and i = 1
  or
  function = "snprintf" and i = 2
  or
  function = "d_printf" and i = 0
  or
  function = "talloc_asprintf" and i = 1
  or
  function = "fstr_sprintf" and i = 1
  or
  function = "talloc_asprintf_append" and i = 1
  or
  function = "d_fprintf" and i = 1
  or
  function = "asprintf" and i = 1
  or
  function = "talloc_asprintf_append_buffer" and i = 1
  or
  function = "fdprintf" and i = 1
  or
  function = "d_vfprintf" and i = 1
  or
  function = "smb_xvasprintf" and i = 1
  or
  function = "asprintf_strupper_m" and i = 1
  or
  function = "talloc_asprintf_strupper_m" and i = 1
  or
  function = "sprintf_append" and i = 4
  or
  function = "x_vfprintf" and i = 1
  or
  function = "x_fprintf" and i = 1
  or
  function = "vasprintf" and i = 1
  or
  function = "ldb_asprintf_errstring" and i = 1
  or
  function = "talloc_vasprintf" and i = 1
  or
  function = "talloc_vasprintf" and i = 1
  or
  function = "fprintf_file" and i = 1
  or
  function = "vsnprintf" and i = 2
  or
  function = "talloc_vasprintf_append" and i = 1
  or
  function = "__talloc_vaslenprintf_append" and i = 2
  or
  function = "talloc_vasprintf_append_buffer" and i = 1
  or
  function = "fprintf_attr" and i = 2
  or
  function = "vprintf" and i = 0
  or
  function = "vsprintf" and i = 1
}

predicate formatBuffer(Expr e) {
  exists(FunctionCall fc, string fname, int i |
    fc.getTarget().getName() = fname and
    formatArgument(fname, i) and
    fc.getArgument(i) = e
  )
}

class FormatBuffer extends PointsToExpr {
  FormatBuffer() { formatBuffer(this) }

  override predicate interesting() { formatBuffer(this) }
}

predicate potentialViolation(InputBuffer source, FormatBuffer dest) {
  source.pointsTo() = dest.pointsTo() and
  not exists(FunctionCall fc |
    fc = dest and fc.getTarget().hasName("lang_msg_rotate") and fc.getArgument(1) instanceof Literal
  )
}

from InputBuffer source, FormatBuffer dest
where potentialViolation(source, dest)
select dest.getFile() as File, dest as FormatString
