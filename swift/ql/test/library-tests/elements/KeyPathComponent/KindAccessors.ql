import codeql.swift.elements
import TestUtils

from
  KeyPathComponent x, string property, string subscript, string opt_forcing, string opt_chaining,
  string opt_wrapping, string self, string tuple_indexing
where
  toBeTested(x) and
  not x.isUnknown() and
  (if x.is_property() then property = "property" else property = "") and
  (if x.is_subscript() then subscript = "subscript" else subscript = "") and
  (if x.is_optional_forcing() then opt_forcing = "optional forcing" else opt_forcing = "") and
  (if x.is_optional_chaining() then opt_chaining = "optional chaining" else opt_chaining = "") and
  (if x.is_optional_wrapping() then opt_wrapping = "optional wrapping" else opt_wrapping = "") and
  (if x.is_self() then self = "self" else self = "") and
  if x.is_tuple_indexing() then tuple_indexing = "tuple indexing" else tuple_indexing = ""
select x, "getKind:", x.getKind(), property, subscript, opt_forcing, opt_chaining, opt_wrapping,
  self, tuple_indexing
