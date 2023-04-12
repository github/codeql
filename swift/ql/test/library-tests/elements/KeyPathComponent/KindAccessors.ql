import codeql.swift.elements
import TestUtils

from
  KeyPathComponent x, string property, string subscript, string opt_forcing, string opt_chaining,
  string opt_wrapping, string self, string tuple_indexing
where
  toBeTested(x) and
  not x.isUnknown() and
  (if x.isProperty() then property = "property" else property = "") and
  (if x.isSubscript() then subscript = "subscript" else subscript = "") and
  (if x.isOptionalForcing() then opt_forcing = "optional forcing" else opt_forcing = "") and
  (if x.isOptionalChaining() then opt_chaining = "optional chaining" else opt_chaining = "") and
  (if x.isOptionalWrapping() then opt_wrapping = "optional wrapping" else opt_wrapping = "") and
  (if x.isSelf() then self = "self" else self = "") and
  if x.isTupleIndexing() then tuple_indexing = "tuple indexing" else tuple_indexing = ""
select x, "getKind:", x.getKind(), property, subscript, opt_forcing, opt_chaining, opt_wrapping,
  self, tuple_indexing
