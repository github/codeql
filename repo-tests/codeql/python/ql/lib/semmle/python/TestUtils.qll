/* This file contains test-related utility functions */
import python

/** Removes everything up to the occurrence of `sub` in the string `str` */
bindingset[str, sub]
string remove_prefix_before_substring(string str, string sub) {
  exists(int index |
    index = str.indexOf(sub) and
    result = str.suffix(index)
  )
  or
  not exists(str.indexOf(sub)) and
  result = str
}

/**
 * Removes the part of the `resources/lib` Python library path that may vary
 * from machine to machine.
 */
string remove_library_prefix(Location loc) {
  result = remove_prefix_before_substring(loc.toString(), "resources/lib")
}

/** Returns the location of an AST node in compact form: `basename:line:column` */
string compact_location(AstNode a) {
  exists(Location l | l = a.getLocation() |
    result = l.getFile().getBaseName() + ":" + l.getStartLine() + ":" + l.getStartColumn()
  )
}
