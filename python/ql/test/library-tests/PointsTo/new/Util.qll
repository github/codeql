import python
import semmle.python.objects.ObjectInternal

bindingset[which]
string locate(Location l, string which) {
  exists(string file, int line |
    file = l.getFile().getShortName() and
    line = l.getStartLine() and
    file.charAt(0) = which.charAt(_) and
    file.charAt(1) = "_" and
    result = file + ":" + line
  )
}

string repr(Object o) {
  /*
   * Do not show `unknownValue()` to keep noise levels down.
   * To show it add:
   * `o = unknownValue() and result = "*UNKNOWN VALUE*"`
   */

  not o instanceof StringObject and
  not o = undefinedVariable() and
  not o = theUnknownType() and
  not o = theBoundMethodType() and
  result = o.toString()
  or
  o = undefinedVariable() and result = "*UNDEFINED*"
  or
  o = theUnknownType() and result = "*UNKNOWN TYPE*"
  or
  /* Work around differing names in 2/3 */
  result = "'" + o.(StringObject).getText() + "'"
  or
  o = theBoundMethodType() and result = "builtin-class method"
}

predicate long_tuple(Value v) { v.(TupleObjectInternal).length() > 3 }

string vrepr(Value v) {
  /* Work around differing names in 2/3 */
  not v = ObjectInternal::boundMethod() and
  not long_tuple(v) and
  result = v.toString()
  or
  v = ObjectInternal::boundMethod() and result = "builtin-class method"
  or
  long_tuple(v) and result = "(..., ...)"
}
