/**
 * @name Inconsistent equality and hashing
 * @description Defining equality for a class without also defining hashability (or vice-versa) violates the object model.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-581
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/equals-hash-mismatch
 */

import python

CallableValue defines_equality(ClassValue c, string name) {
  (
    name = "__eq__"
    or
    major_version() = 2 and name = "__cmp__"
  ) and
  result = c.declaredAttribute(name)
}

CallableValue implemented_method(ClassValue c, string name) {
  result = defines_equality(c, name)
  or
  result = c.declaredAttribute("__hash__") and name = "__hash__"
}

string unimplemented_method(ClassValue c) {
  not exists(defines_equality(c, _)) and
  (
    result = "__eq__" and major_version() = 3
    or
    major_version() = 2 and result = "__eq__ or __cmp__"
  )
  or
  /* Python 3 automatically makes classes unhashable if __eq__ is defined, but __hash__ is not */
  not c.declaresAttribute(result) and result = "__hash__" and major_version() = 2
}

/** Holds if this class is unhashable */
predicate unhashable(ClassValue cls) {
  cls.lookup("__hash__") = Value::named("None")
  or
  cls.lookup("__hash__").(CallableValue).neverReturns()
}

predicate violates_hash_contract(ClassValue c, string present, string missing, Value method) {
  not unhashable(c) and
  missing = unimplemented_method(c) and
  method = implemented_method(c, present) and
  not c.failedInference(_)
}

from ClassValue c, string present, string missing, CallableValue method
where
  violates_hash_contract(c, present, missing, method) and
  exists(c.getScope()) // Suppress results that aren't from source
select method, "Class $@ implements " + present + " but does not define " + missing + ".", c,
  c.getName()
