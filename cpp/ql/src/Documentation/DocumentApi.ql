/**
 * @name Undocumented API function
 * @description Functions used from outside the file they are declared in
 *              should be documented, as they are part of a public API. Without
 *              comments, modifying such functions is dangerous because callers
 *              easily come to rely on their exact implementation.
 * @kind problem
 * @id cpp/document-api
 * @problem.severity recommendation
 * @precision medium
 * @tags maintainability
 *       documentation
 */

import cpp

predicate isCommented(FunctionDeclarationEntry f) {
  exists(Comment c | c.getCommentedElement() = f)
}

// Uses of 'f' in 'other'
Call uses(File other, Function f) { result.getTarget() = f and result.getFile() = other }

from File callerFile, Function f, Call use, int numCalls
where
  numCalls = strictcount(File other | exists(uses(other, f)) and other != f.getFile()) and
  not isCommented(f.getADeclarationEntry()) and
  not f instanceof Constructor and
  not f instanceof Destructor and
  not f.hasName("operator=") and
  f.getMetrics().getNumberOfLinesOfCode() >= 5 and
  numCalls > 1 and
  use = uses(callerFile, f) and
  callerFile != f.getFile()
select f, "Functions called from other files should be documented (called from $@).", use,
  use.getFile().getRelativePath()
