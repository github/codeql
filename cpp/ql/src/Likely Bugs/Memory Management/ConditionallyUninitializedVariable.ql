/**
 * @name Conditionally uninitialized variable
 * @description When an initialization function is used to initialize a local variable,
 *              but the returned status code is not checked, reading the variable may
 *              result in undefined behaviour.
 * @kind problem
 * @problem.severity warning
 * @opaque-id SM02313
 * @id cpp/conditionallyuninitializedvariable
 */

import cpp
import semmle.code.cpp.controlflow.SSA
private import semmle.code.cpp.security.UninitializedVariables

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
