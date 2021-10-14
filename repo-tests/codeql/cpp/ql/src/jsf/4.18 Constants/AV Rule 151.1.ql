/**
 * @name Constant string literals
 * @description A string literal must not be modified, as the result is undefined. To ensure this, only variables of type const char * or const char [] can hold string literals.
 * @kind problem
 * @id cpp/jsf/av-rule-151-1
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * Interpretation (from the example in AV151.1):
 *   rather than doing points-to to find writes into string literals, the
 *   check forbids assigning to non-const string variables, which prevents it.
 *
 * Casting the const-ness of the variable away is still possible; ideally it
 * should be prevented but it doesn't seem worth the effort since it will likely
 * flag another rule.
 */

class NonConstStringType extends DerivedType {
  NonConstStringType() {
    this.(ArrayType).getBaseType() instanceof CharType or
    this.(PointerType).getBaseType() instanceof CharType
  }
}

from StringLiteral l
where l.getFullyConverted().getType().getUnderlyingType() instanceof NonConstStringType
select l,
  "A string literal must not be used as a non-const value: modifying string literals leads to undefined behavior."
