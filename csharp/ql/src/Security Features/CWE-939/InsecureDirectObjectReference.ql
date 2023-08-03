/**
 * @name Insecure Direct Object Reference
 * @description Using user input to control which object is modified without
 *              proper authorization checks allows an attacker to modify arbitrary objects.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id cs/insecure-direct0object-reference
 * @tags security
 *       external/cwe/639
 */

import csharp
import semmle.code.csharp.security.auth.InsecureDirectObjectReferenceQuery

from ActionMethod m
where hasInsecureDirectObjectReference(m)
select m,
  "This method may not verify which users should be able to access resources of the provided ID."
