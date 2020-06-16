/**
 * @name Unused format argument
 * @description A format call with a format string that refers to fewer
 *              arguments than the number of supplied arguments will silently
 *              ignore the additional arguments.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/unused-format-argument
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-685
 */

import java
import semmle.code.java.StringFormat

int getNumberOfReferencedIndices(FormattingCall fmtcall) {
  exists(int maxref, int skippedrefs |
    maxref = max(FormatString fmt | fmtcall.getAFormatString() = fmt | fmt.getMaxFmtSpecIndex()) and
    skippedrefs =
      count(int i |
        forex(FormatString fmt | fmtcall.getAFormatString() = fmt |
          i = fmt.getASkippedFmtSpecIndex()
        )
      ) and
    result = maxref - skippedrefs
  )
}

from FormattingCall fmtcall, int refs, int args
where
  refs = getNumberOfReferencedIndices(fmtcall) and
  args = fmtcall.getVarargsCount() and
  refs < args and
  not (fmtcall.hasTrailingThrowableArgument() and refs = args - 1)
select fmtcall,
  "This format call refers to " + refs + " argument(s) but supplies " + args + " argument(s)."
