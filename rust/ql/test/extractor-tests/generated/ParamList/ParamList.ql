// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from ParamList x, int getNumberOfParams, string hasSelfParam
where
  toBeTested(x) and
  not x.isUnknown() and
  getNumberOfParams = x.getNumberOfParams() and
  if x.hasSelfParam() then hasSelfParam = "yes" else hasSelfParam = "no"
select x, "getNumberOfParams:", getNumberOfParams, "hasSelfParam:", hasSelfParam
