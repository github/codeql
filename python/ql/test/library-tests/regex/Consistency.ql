/**
 * Flags regular expressions that are parsed ambigously
 */

import python
import semmle.python.regex

from string str, Location loc, int counter
where
  counter = strictcount(RegExp term | term.getLocation() = loc and term.getText() = str) and
  counter > 1
select str, counter, loc
