/**
 * @name Missing Javadoc for thrown exception
 * @description A public method or constructor that throws an exception but does not have a
 *              Javadoc tag for the exception affects maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/undocumented-exception
 * @tags maintainability
 */

import java
import JavadocCommon

from DocuThrows c, RefType t
where
  exists(Exception e |
    c.getAnException() = e and
    e.getType() = t and
    not c.hasAcceptableThrowsTag(e)
  )
select c,
  "This " + c.toMethodOrConstructorString() +
    " throws $@ but does not have a corresponding Javadoc tag.", t, t.getName()
