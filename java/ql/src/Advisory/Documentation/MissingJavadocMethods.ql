/**
 * @name Missing Javadoc for public method or constructor
 * @description A public method or constructor that does not have a Javadoc comment affects
 *              maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/undocumented-function
 * @tags maintainability
 */

import java
import JavadocCommon

from DocuCallable c
where not c.hasAcceptableDocText()
select c,
  "This " + c.toMethodOrConstructorString() + " does not have a non-trivial Javadoc comment."
