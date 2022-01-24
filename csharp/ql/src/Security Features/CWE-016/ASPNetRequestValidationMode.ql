/**
 * @name Insecure configuration for ASP.NET requestValidationMode
 * @description Setting 'requestValidationMode' to less than 4.5 disables built-in validations
 *              included by default in ASP.NET. Disabling or downgrading this protection is not
 *              recommended.
 * @kind problem
 * @id cs/insecure-request-validation-mode
 * @problem.severity warning
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-016
 */

import csharp

from XMLAttribute reqValidationMode
where
  reqValidationMode.getName().toLowerCase() = "requestvalidationmode" and
  reqValidationMode.getValue().toFloat() < 4.5
select reqValidationMode,
  "Insecure value for requestValidationMode (" + reqValidationMode.getValue() + ")."
