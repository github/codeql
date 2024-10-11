import codeql.rust.Diagnostics

query predicate extractionError(ExtractionError ee) { any() }

query predicate extractionWarning(ExtractionWarning ew) { any() }
