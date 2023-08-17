/**
 * @name Insecure Direct Object Reference
 * @description Using user input to control which object is modified without
 *              proper authorization checks allows an attacker to modify arbitrary objects.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @id cs/insecure-direct-object-reference
 * @tags security
 *       external/cwe-639
 */

import csharp
import semmle.code.csharp.security.auth.InsecureDirectObjectReferenceQuery

from ActionMethod m
where hasInsecureDirectObjectReference(m)
select m,
  "This method may be missing authorization checks for which users can access the resource of the provided ID."
