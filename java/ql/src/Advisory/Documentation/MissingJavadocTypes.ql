/**
 * @name Missing Javadoc for public type
 * @description A public class or interface that does not have a Javadoc comment affects
 *              maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/undocumented-type
 * @tags maintainability
 */

import java
import JavadocCommon

from DocuRefType t
where not t.hasAcceptableDocText()
select t, "This type does not have a non-trivial Javadoc comment."
