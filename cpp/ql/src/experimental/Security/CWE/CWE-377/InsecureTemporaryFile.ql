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
select fc, msg
