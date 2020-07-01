/**
 * @name Unused include
 * @description Finds #include directives that are not needed because none of
 *              the included elements are used.
 * @kind problem
 * @id cpp/unused-includes
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 *       useless-code
 */

import cpp

File sourceFile() {
  result instanceof CFile or
  result instanceof CppFile
}

from Include include, File source, File unneeded
where
  include.getFile() = source and
  source = sourceFile() and
  unneeded = include.getIncludedFile() and
  not unneeded.getAnIncludedFile*() = source.getMetrics().getAFileDependency() and
  unneeded.fromSource() and
  not unneeded.getBaseName().matches("%Debug.h")
select include, "Redundant include, this file does not require $@.", unneeded,
  unneeded.getAbsolutePath()
