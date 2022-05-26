/**
 * @name Writing to a file without setting permissions.
 * @description Lack of restriction on file access rights can be unsafe.
 * @kind problem
 * @id cpp/work-with-file-without-permissions-rights
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       maintainability
 *       security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-264
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Holds for a function `f` that has an argument at index `apos` used to read the file. */
predicate numberArgumentRead(Function f, int apos) {
  f.hasGlobalOrStdName("fgets") and apos = 2
  or
  f.hasGlobalOrStdName("fread") and apos = 3
  or
  f.hasGlobalOrStdName("read") and apos = 0
  or
  f.hasGlobalOrStdName("fscanf") and apos = 0
}

/** Holds for a function `f` that has an argument at index `apos` used to write to file */
predicate numberArgumentWrite(Function f, int apos) {
  f.hasGlobalOrStdName("fprintf") and apos = 0
  or
  f.hasGlobalOrStdName("fputs") and apos = 1
  or
  f.hasGlobalOrStdName("write") and apos = 0
  or
  f.hasGlobalOrStdName("fwrite") and apos = 3
  or
  f.hasGlobalOrStdName("fflush") and apos = 0
}

from FunctionCall fc
where
  // a file is opened
  (
    fc.getTarget().hasGlobalOrStdName("fopen") or
    fc.getTarget().hasGlobalOrStdName("open")
  ) and
  fc.getNumberOfArguments() = 2 and
  // the file is used for writing (but not reading)
  exists(FunctionCall fctmp, int i |
    numberArgumentWrite(fctmp.getTarget(), i) and
    globalValueNumber(fc) = globalValueNumber(fctmp.getArgument(i))
  ) and
  not exists(FunctionCall fctmp, int i |
    numberArgumentRead(fctmp.getTarget(), i) and
    globalValueNumber(fc) = globalValueNumber(fctmp.getArgument(i))
  ) and
  // a file creation mode is not set globally by `umask` anywhere in the program
  not exists(FunctionCall fctmp |
    fctmp.getTarget().hasGlobalOrStdName("umask") or
    fctmp.getTarget().hasGlobalOrStdName("fchmod") or
    fctmp.getTarget().hasGlobalOrStdName("chmod")
  )
select fc, "You may have forgotten to restrict access rights when working with a file."
