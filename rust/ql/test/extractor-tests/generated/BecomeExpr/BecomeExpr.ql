// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from BecomeExpr x, int getNumberOfAttrs, string hasExpr
where
  toBeTested(x) and
  not x.isUnknown() and
  getNumberOfAttrs = x.getNumberOfAttrs() and
  if x.hasExpr() then hasExpr = "yes" else hasExpr = "no"
select x, "getNumberOfAttrs:", getNumberOfAttrs, "hasExpr:", hasExpr
