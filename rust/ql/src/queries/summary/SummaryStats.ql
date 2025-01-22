/**
 * @name Summary Statistics
 * @description A table of summary statistics about a database.
 * @kind metric
 * @id rust/summary/summary-statistics
 * @tags summary
 */

import rust
import codeql.rust.Concepts
import codeql.rust.security.SensitiveData
import codeql.rust.security.WeakSensitiveDataHashingExtensions
import codeql.rust.Diagnostics
import Stats
import TaintReach

from string key, int value
where
  key = "Elements extracted" and value = count(Element e | not e instanceof Unextracted)
  or
  key = "Elements unextracted" and value = count(Unextracted e)
  or
  key = "Extraction errors" and value = count(ExtractionError e)
  or
  key = "Extraction warnings" and value = count(ExtractionWarning w)
  or
  key = "Files extracted - total" and value = count(ExtractedFile f | exists(f.getRelativePath()))
  or
  key = "Files extracted - with errors" and
  value =
    count(ExtractedFile f |
      exists(f.getRelativePath()) and not f instanceof SuccessfullyExtractedFile
    )
  or
  key = "Files extracted - without errors" and
  value = count(SuccessfullyExtractedFile f | exists(f.getRelativePath()))
  or
  key = "Files extracted - without errors %" and
  value =
    (count(SuccessfullyExtractedFile f | exists(f.getRelativePath())) * 100) /
      count(ExtractedFile f | exists(f.getRelativePath()))
  or
  key = "Lines of code extracted" and value = getLinesOfCode()
  or
  key = "Lines of user code extracted" and value = getLinesOfUserCode()
  or
  key = "Inconsistencies - AST" and value = getTotalAstInconsistencies()
  or
  key = "Inconsistencies - CFG" and value = getTotalCfgInconsistencies()
  or
  key = "Inconsistencies - data flow" and value = getTotalDataFlowInconsistencies()
  or
  key = "Macro calls - total" and value = count(MacroCall mc)
  or
  key = "Macro calls - resolved" and value = count(MacroCall mc | mc.hasExpanded())
  or
  key = "Macro calls - unresolved" and value = count(MacroCall mc | not mc.hasExpanded())
  or
  key = "Taint sources - active" and value = count(ActiveThreatModelSource s)
  or
  key = "Taint sources - disabled" and
  value = count(ThreatModelSource s | not s instanceof ActiveThreatModelSource)
  or
  key = "Taint sources - sensitive data" and value = count(SensitiveData d)
  or
  key = "Taint edges - number of edges" and value = getTaintEdgesCount()
  or
  key = "Taint reach - nodes tainted" and value = getTaintedNodesCount()
  or
  key = "Taint reach - per million nodes" and value = getTaintReach().floor()
  or
  key = "Taint sinks - query sinks" and value = getQuerySinksCount()
  or
  key = "Taint sinks - cryptographic operations" and
  value = count(Cryptography::CryptographicOperation o)
select key, value order by key
