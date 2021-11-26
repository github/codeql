/**
 * Flags regular expressions that are parsed ambigously
 */

import python
import semmle.python.RegexTreeView

from string str, int counter, Location loc
where
  counter =
    strictcount(RegExpTerm term |
      term.getLocation() = loc and term.isRootTerm() and term.toString() = str
    ) and
  counter > 1
select str, counter, loc
