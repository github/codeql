/**
 * @deprecated
 * @name Mostly duplicate class
 * @description Classes in which most of the methods are duplicated in another class make code more
 *              difficult to understand and introduce a risk of changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/duplicate-class
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java

from Class c, string message, Class link
where none()
select c, message, link, link.getQualifiedName()
