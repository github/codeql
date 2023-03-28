/**
 * @name Delegated security sensitive validations for JsonWebTokenHandler always return true, medium precision
 * @description Security sensitive validations for `JsonWebTokenHandler` are being delegated to a function that seems to always return true.
 *   Higher precision version checks for exception throws, so less false positives are expected.
 * @kind problem
 * @tags security
 *       experimental
 *       JsonWebTokenHandler
 *       manual-verification-required
 * @id cs/json-webtoken-handler/delegated-security-validations-always-return-true
 * @problem.severity error
 * @precision high
 */

import csharp
import DataFlow
import JsonWebTokenHandlerLib
import semmle.code.csharp.commons.QualifiedName

from
  TokenValidationParametersProperty p, CallableAlwaysReturnsTrueHigherPrecision e, string qualifier,
  string name
where e = p.getAnAssignedValue() and p.hasQualifiedName(qualifier, name)
select e,
  "JsonWebTokenHandler security-sensitive property $@ is being delegated to this callable that always returns \"true\".",
  p, getQualifiedName(qualifier, name)
