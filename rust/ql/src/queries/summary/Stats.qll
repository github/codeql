/**
 * Predicates used in summary queries.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.rust.internal.AstConsistency as AstConsistency
private import codeql.rust.internal.PathResolutionConsistency as PathResolutionConsistency
private import codeql.rust.internal.TypeInferenceConsistency as TypeInferenceConsistency
private import codeql.rust.controlflow.internal.CfgConsistency as CfgConsistency
private import codeql.rust.dataflow.internal.DataFlowConsistency as DataFlowConsistency
private import codeql.rust.dataflow.internal.SsaImpl::Consistency as SsaConsistency
private import codeql.rust.Concepts
private import codeql.rust.Diagnostics
private import codeql.rust.security.SensitiveData
private import TaintReach
// import all query extensions files, so that all extensions of `QuerySink` are found
private import codeql.rust.security.regex.RegexInjectionExtensions
private import codeql.rust.security.AccessInvalidPointerExtensions
private import codeql.rust.security.CleartextLoggingExtensions
private import codeql.rust.security.CleartextStorageDatabaseExtensions
private import codeql.rust.security.CleartextTransmissionExtensions
private import codeql.rust.security.LogInjectionExtensions
private import codeql.rust.security.SqlInjectionExtensions
private import codeql.rust.security.TaintedPathExtensions
private import codeql.rust.security.UncontrolledAllocationSizeExtensions
private import codeql.rust.security.WeakSensitiveDataHashingExtensions
private import codeql.rust.security.HardcodedCryptographicValueExtensions

/**
 * Gets a count of the total number of lines of code in the database.
 */
int getLinesOfCode() { result = sum(File f | f.fromSource() | f.getNumberOfLinesOfCode()) }

/**
 * Gets a count of the total number of lines of code from the source code directory in the database.
 */
int getLinesOfUserCode() {
  result = sum(ExtractedFile f | exists(f.getRelativePath()) | f.getNumberOfLinesOfCode())
}

/**
 * Gets a count of the total number of abstract syntax tree inconsistencies in the database.
 */
int getTotalAstInconsistencies() {
  result = sum(string type | | AstConsistency::getAstInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of path resolution inconsistencies in the database.
 */
int getTotalPathResolutionInconsistencies() {
  result =
    sum(string type | | PathResolutionConsistency::getPathResolutionInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of type inference inconsistencies in the database.
 */
int getTotalTypeInferenceInconsistencies() {
  result = sum(string type | | TypeInferenceConsistency::getTypeInferenceInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of control flow graph inconsistencies in the database.
 */
int getTotalCfgInconsistencies() {
  result = sum(string type | | CfgConsistency::getCfgInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of SSA inconsistencies in the database.
 */
int getTotalSsaInconsistencies() {
  result = sum(string type | | SsaConsistency::getInconsistencyCounts(type))
}

/**
 * Gets a count of the total number of data flow inconsistencies in the database.
 */
int getTotalDataFlowInconsistencies() {
  result = sum(string type | | DataFlowConsistency::getInconsistencyCounts(type))
}

/**
 * Gets the total number of taint edges in the database.
 */
int getTaintEdgesCount() {
  result =
    count(DataFlow::Node a, DataFlow::Node b |
      RustTaintTracking::defaultAdditionalTaintStep(a, b, _)
    )
}

/**
 * Gets a count of the total number of query sinks in the database.
 */
int getQuerySinksCount() { result = count(QuerySink s) }

class CrateElement extends Element {
  CrateElement() {
    this instanceof Crate or
    this instanceof NamedCrate
  }
}

/**
 * Gets summary statistics about individual elements in the database.
 */
predicate elementStats(string key, int value) {
  key = "Elements extracted" and
  value = count(Element e | not e instanceof Unextracted and not e instanceof CrateElement)
  or
  key = "Elements unextracted" and value = count(Unextracted e)
}

/**
 * Gets summary statistics about extraction.
 */
predicate extractionStats(string key, int value) {
  key = "Extraction errors" and
  value = count(ExtractionError e | not exists(e.getLocation()) or e.getLocation().fromSource())
  or
  key = "Extraction warnings" and
  value = count(ExtractionWarning w | not exists(w.getLocation()) or w.getLocation().fromSource())
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
  key = "Macro calls - total" and value = count(MacroCall mc | mc.fromSource())
  or
  key = "Macro calls - resolved" and
  value = count(MacroCall mc | mc.fromSource() and mc.hasMacroCallExpansion())
  or
  key = "Macro calls - unresolved" and
  value = count(MacroCall mc | mc.fromSource() and not mc.hasMacroCallExpansion())
}

/**
 * Gets summary statistics about inconsistencies.
 */
predicate inconsistencyStats(string key, int value) {
  key = "Inconsistencies - AST" and value = getTotalAstInconsistencies()
  or
  key = "Inconsistencies - Path resolution" and value = getTotalPathResolutionInconsistencies()
  or
  key = "Inconsistencies - CFG" and value = getTotalCfgInconsistencies()
  or
  key = "Inconsistencies - SSA" and value = getTotalSsaInconsistencies()
  or
  key = "Inconsistencies - data flow" and value = getTotalDataFlowInconsistencies()
}

/**
 * Gets summary statistics about inconsistencies related to type inference.
 */
predicate typeInferenceInconsistencyStats(string key, int value) {
  key = "Inconsistencies - Type inference" and value = getTotalTypeInferenceInconsistencies()
}

/**
 * Gets summary statistics about taint.
 */
predicate taintStats(string key, int value) {
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
  key = "Taint reach - total non-summary nodes" and value = getTotalNodesCount()
  or
  key = "Taint reach - per million nodes" and value = getTaintReach().floor()
  or
  key = "Taint sinks - query sinks" and value = getQuerySinksCount()
  or
  key = "Taint sinks - cryptographic operations" and
  value = count(Cryptography::CryptographicOperation o)
}
