/**
 * @name Extraction consistency
 * @description Lists the extraction inconsistencies (errors) in the database.  This query is intended for internal use.
 * @kind table
 * @id rust/diagnostics/extraction-consistency
 */

import codeql.rust.Diagnostics

query predicate extractionError(ExtractionError ee) {
  not exists(ee.getLocation()) or ee.getLocation().fromSource()
}

query predicate extractionWarning(ExtractionWarning ew) {
  (not exists(ew.getLocation()) or ew.getLocation().fromSource()) and
  // macro expansion failures are expected for macros like compile_error! and panic!
  not ew.getMessage().matches("macro expansion failed for%")
}
