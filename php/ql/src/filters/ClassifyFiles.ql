/**
 * File classification filter for PHP code analysis.
 *
 * This filter categorizes PHP files into different classes for better
 * organization of results and filtering of false positives.
 *
 * @name File Classification
 * @kind problem
 * @id php/file-classification
 * @severity info
 */

import php

private string getClassification(File f) {
  (
    f.getBaseName().toLowerCase().matches("%test%") and
    result = "test"
  )
  or
  (
    f.getAbsolutePath().toLowerCase().matches("%vendor%") and
    result = "third-party"
  )
  or
  (
    f.getAbsolutePath().toLowerCase().matches("%node_modules%") and
    result = "third-party"
  )
  or
  (
    f.getBaseName().toLowerCase().matches("%migration%") and
    result = "generated"
  )
  or
  (
    f.getBaseName().toLowerCase().matches("%seed%") and
    result = "generated"
  )
  or
  (
    not f.getBaseName().toLowerCase().matches("%test%") and
    not f.getAbsolutePath().toLowerCase().matches("%vendor%") and
    not f.getAbsolutePath().toLowerCase().matches("%node_modules%") and
    not f.getBaseName().toLowerCase().matches("%migration%") and
    not f.getBaseName().toLowerCase().matches("%seed%") and
    result = "source"
  )
}

/**
 * A classification for a file indicating its role in the codebase.
 */
string getFileClassification(File f) {
  result = getClassification(f)
}

/**
 * Check if a file should be excluded from results.
 */
predicate shouldExcludeFile(File f) {
  getFileClassification(f) = "test" or
  getFileClassification(f) = "third-party" or
  getFileClassification(f) = "generated"
}

from File f, string classification
where classification = getFileClassification(f)
select f, "File classified as: " + classification
