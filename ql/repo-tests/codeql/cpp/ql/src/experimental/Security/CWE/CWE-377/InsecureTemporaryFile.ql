/**
 * @name Insecure generation of filenames.
 * @description Using a predictable filename when creating a temporary file can lead to an attacker-controlled input.
 * @kind problem
 * @id cpp/insecure-generation-of-filename
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-377
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

from FunctionCall fc, string msg
where
  // search for functions for generating a name, without a guarantee of the absence of a file during the period of work with it.
  (
    fc.getTarget().hasGlobalOrStdName("tmpnam") or
    fc.getTarget().hasGlobalOrStdName("tmpnam_s") or
    fc.getTarget().hasGlobalOrStdName("tmpnam_r")
  ) and
  not exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("mktemp") or
      fctmp.getTarget().hasGlobalOrStdName("mkstemp") or
      fctmp.getTarget().hasGlobalOrStdName("mkstemps") or
      fctmp.getTarget().hasGlobalOrStdName("mkdtemp")
    ) and
    (
      fc.getBasicBlock().getASuccessor*() = fctmp.getBasicBlock() or
      fctmp.getBasicBlock().getASuccessor*() = fc.getBasicBlock()
    )
  ) and
  msg =
    "Finding the name of a file that does not exist does not mean that it will not be exist at the next operation."
  or
  // finding places to work with a file without setting permissions, but with predictable names.
  (
    fc.getTarget().hasGlobalOrStdName("fopen") or
    fc.getTarget().hasGlobalOrStdName("open")
  ) and
  fc.getNumberOfArguments() = 2 and
  exists(FunctionCall fctmp, int i |
    numberArgumentWrite(fctmp.getTarget(), i) and
    globalValueNumber(fc) = globalValueNumber(fctmp.getArgument(i))
  ) and
  not exists(FunctionCall fctmp, int i |
    numberArgumentRead(fctmp.getTarget(), i) and
    globalValueNumber(fc) = globalValueNumber(fctmp.getArgument(i))
  ) and
  exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("strcat") or
      fctmp.getTarget().hasGlobalOrStdName("strcpy")
    ) and
    globalValueNumber(fc.getArgument(0)) = globalValueNumber(fctmp.getAnArgument())
    or
    fctmp.getTarget().hasGlobalOrStdName("getenv") and
    globalValueNumber(fc.getArgument(0)) = globalValueNumber(fctmp)
    or
    (
      fctmp.getTarget().hasGlobalOrStdName("asprintf") or
      fctmp.getTarget().hasGlobalOrStdName("vasprintf") or
      fctmp.getTarget().hasGlobalOrStdName("xasprintf") or
      fctmp.getTarget().hasGlobalOrStdName("xvasprintf ")
    ) and
    exists(Variable vrtmp |
      vrtmp = fc.getArgument(0).(VariableAccess).getTarget() and
      vrtmp = fctmp.getArgument(0).(AddressOfExpr).getAddressable().(Variable) and
      not vrtmp instanceof Field
    )
  ) and
  not exists(FunctionCall fctmp |
    (
      fctmp.getTarget().hasGlobalOrStdName("umask") or
      fctmp.getTarget().hasGlobalOrStdName("fchmod") or
      fctmp.getTarget().hasGlobalOrStdName("chmod")
    ) and
    (
      fc.getBasicBlock().getASuccessor*() = fctmp.getBasicBlock() or
      fctmp.getBasicBlock().getASuccessor*() = fc.getBasicBlock()
    )
  ) and
  msg =
    "Creating a file for writing without evaluating its existence and setting permissions can be unsafe."
select fc, msg
