// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from Module x, int getNumberOfAttrs, string hasItemList, string hasName, string hasVisibility
where
  toBeTested(x) and
  not x.isUnknown() and
  getNumberOfAttrs = x.getNumberOfAttrs() and
  (if x.hasItemList() then hasItemList = "yes" else hasItemList = "no") and
  (if x.hasName() then hasName = "yes" else hasName = "no") and
  if x.hasVisibility() then hasVisibility = "yes" else hasVisibility = "no"
select x, "getNumberOfAttrs:", getNumberOfAttrs, "hasItemList:", hasItemList, "hasName:", hasName,
  "hasVisibility:", hasVisibility
