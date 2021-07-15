/**
 * @name Conditionally uninitialized variable
 * @description An initialization function is used to initialize a local variable, but the
 *              returned status code is not checked. The variable may be left in an uninitialized
 *              state, and reading the variable may result in undefined behavior.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @id cpp/conditionally-uninitialized-variable
 * @tags security
 *       external/cwe/cwe-457
 */

import cpp
import semmle.code.cpp.controlflow.SSA
private import UninitializedVariables

from
  ConditionallyInitializedVariable v, ConditionalInitializationFunction f,
  ConditionalInitializationCall call, string defined, Evidence e
where
  exists(v.getARiskyAccess(f, call, e)) and
  (
    if e = DefinitionInSnapshot()
    then defined = ""
    else
      if e = SuggestiveSALAnnotation()
      then defined = "externally defined (SAL) "
      else defined = "externally defined (CSV) "
  )
select call,
  "The status of this call to " + defined +
    "$@ is not checked, potentially leaving $@ uninitialized.", f, f.getName(), v, v.getName()
