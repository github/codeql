/**
 * @name AV Rule 138
 * @description Identifiers shall not simultaneously have both internal and external linkage in the same translation unit.
 * @kind problem
 * @id cpp/jsf/av-rule-138
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

/*
 * Interpretation: the standards doc is a bit unclear on this rule, making it sound like it is
 * about name shadowing when rule 135 prevents shadowing anyway. This is supported by the example,
 * which incorrectly points to a variable with static storage but no linkage as having internal
 * linkage.
 *
 * We interpret it as: do not have two declarations of the same identifier *anywhere* in the same
 * translation unit if one has internal linkage and the other external linkage.
 *
 * RESTRICTION: variable names only.
 * NOTE: only applies to C++; rules for C are different.
 */

/*
 * FOR FUTURE REFERENCE ONLY - CURRENTLY USELESS BECAUSE OF POPULATOR LIMITATIONS
 * We need to have all the declarations of a variable to make this work; the extractor
 * does not currently provide that.
 */

predicate externalLinkage(Variable v) {
  v.getADeclarationEntry().hasSpecifier("extern")
  or
  v instanceof GlobalVariable and
  not v.isConst() and
  not v.isStatic()
}

predicate internalLinkage(GlobalVariable v) {
  v.isStatic()
  or
  v.isConst() and
  not v.hasSpecifier("extern")
}

from Variable v
where externalLinkage(v) and internalLinkage(v)
select v,
  "AV Rule 138: Identifiers shall not simultaneously have both internal and external linkage in the same translation unit."
