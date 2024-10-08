// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from
  TypeAlias x, int getNumberOfAttrs, string hasGenericParamList, string isDefault, string hasName,
  string hasTy, string hasTypeBoundList, string hasVisibility, string hasWhereClause
where
  toBeTested(x) and
  not x.isUnknown() and
  getNumberOfAttrs = x.getNumberOfAttrs() and
  (if x.hasGenericParamList() then hasGenericParamList = "yes" else hasGenericParamList = "no") and
  (if x.isDefault() then isDefault = "yes" else isDefault = "no") and
  (if x.hasName() then hasName = "yes" else hasName = "no") and
  (if x.hasTy() then hasTy = "yes" else hasTy = "no") and
  (if x.hasTypeBoundList() then hasTypeBoundList = "yes" else hasTypeBoundList = "no") and
  (if x.hasVisibility() then hasVisibility = "yes" else hasVisibility = "no") and
  if x.hasWhereClause() then hasWhereClause = "yes" else hasWhereClause = "no"
select x, "getNumberOfAttrs:", getNumberOfAttrs, "hasGenericParamList:", hasGenericParamList,
  "isDefault:", isDefault, "hasName:", hasName, "hasTy:", hasTy, "hasTypeBoundList:",
  hasTypeBoundList, "hasVisibility:", hasVisibility, "hasWhereClause:", hasWhereClause
