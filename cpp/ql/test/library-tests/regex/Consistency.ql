/**
 * Flags positions in regular expressions that failed to parse.
 * An empty expected output confirms that all regex constructs in the test
 * file were parsed successfully.
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView::RegexTreeView as RTV
import semmle.code.cpp.regex.internal.ParseRegExp

from RegExp re, int i
where re.failedToParse(i)
select re, i, "Failed to parse character at offset " + i + " in " + re.getValue()
