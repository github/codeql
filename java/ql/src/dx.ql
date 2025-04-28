/**
 * @name sm
 * @kind problem
 * @id java/sm
 * @severity warning
 */

import semmle.code.java.dataflow.internal.ExternalFlowExtensions

from
  string s, string package, string type, boolean subtypes, string name, string signature,
  string ext, string input, string output, string kind, string provenance,
  QlBuiltins::ExtensionId madId
where
  summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance, madId) and
  s = package + "." + type + "." + name + signature
select s, "summary model"
