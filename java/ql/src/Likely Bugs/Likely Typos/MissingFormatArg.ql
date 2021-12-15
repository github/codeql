/**
 * @name Missing format argument
 * @description A format call with an insufficient number of arguments causes
 *              an 'IllegalFormatException'.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/missing-format-argument
 * @tags correctness
 *       external/cwe/cwe-685
 */

import java
import semmle.code.java.StringFormat

from FormattingCall fmtcall, FormatString fmt, int refs, int args
where
  fmtcall.getAFormatString() = fmt and
  refs = fmt.getMaxFmtSpecIndex() and
  args = fmtcall.getVarargsCount() and
  refs > args
select fmtcall,
  "This format call refers to " + refs + " argument(s) but only supplies " + args + " argument(s)."
