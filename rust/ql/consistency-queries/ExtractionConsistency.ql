/**
 * @name Extraction consistency
 * @description Lists the extraction inconsistencies (errors) in the database.  This query is intended for internal use.
 * @kind table
 * @id rust/diagnostics/extraction-consistency
 */

import codeql.rust.Diagnostics

query predicate extractionError(ExtractionError ee) { any() }

query predicate extractionWarning(ExtractionWarning ew) { any() }
