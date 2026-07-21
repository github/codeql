/**
 * Regression guard: every corpus regex must parse without leaving any
 * character unaccounted for. Expected output is empty.
 */

import cpp
import semmle.code.cpp.regex.internal.ParseRegExp

from RegExp re, int i
where re.failedToParse(i)
select re, i, re.getChar(i)
