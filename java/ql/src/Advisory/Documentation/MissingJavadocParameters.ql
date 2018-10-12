/**
 * @name Missing Javadoc for parameter
 * @description A public method or constructor that does not have a Javadoc tag for each parameter
 *              affects maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/undocumented-parameter
 * @tags maintainability
 */

import java
import JavadocCommon

from DocuParam p
where not p.hasAcceptableParamTag()
select p, "This parameter does not have a non-trivial Javadoc tag."
