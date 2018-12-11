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

FunctionObject defines_equality(ClassObject c, string name) {
    (name = "__eq__" or major_version() = 2 and name = "__cmp__")
    and
    result = c.declaredAttribute(name)
}

FunctionObject implemented_method(ClassObject c, string name) {
    result = defines_equality(c, name)
    or
    result = c.declaredAttribute("__hash__") and name = "__hash__"
}

string unimplemented_method(ClassObject c) {
    not exists(defines_equality(c, _)) and 
    (result = "__eq__" and major_version() = 3 or major_version() = 2 and result = "__eq__ or __cmp__")
    or
    /* Python 3 automatically makes classes unhashable if __eq__ is defined, but __hash__ is not */
    not c.declaresAttribute(result) and result = "__hash__" and major_version() = 2
}

predicate violates_hash_contract(ClassObject c, string present, string missing, Object method) {
   not c.unhashable() and
   missing = unimplemented_method(c) and
   method = implemented_method(c, present) and
   not c.unknowableAttributes()
}

from ClassObject c, string present, string missing, FunctionObject method
where violates_hash_contract(c, present, missing, method) and
exists(c.getPyClass()) // Suppress results that aren't from source
select method, "Class $@ implements " + present + " but does not define " + missing + ".", c, c.getName()
