/**
 * @name Unextracted Elements
 * @description List all elements that weren't extracted due to unimplemented features or parse errors.
 * @kind diagnostic
 * @id rust/diagnostics/unextracted-elements
 */

import rust

/**
 * Gets a string along the lines of " (x2)", corresponding to the number `i`.
 * For `i = 1`, the result is the empty string.
 */
bindingset[i]
string multipleString(int i) {
  i = 1 and result = ""
  or
  i > 1 and result = " (x" + i.toString() + ")"
}

from string name, int c
where c = strictcount(Unextracted e | e.toString() = name)
// we don't have locations, so just list the number of each type of
// `Unextracted` element.
select name + multipleString(c)
