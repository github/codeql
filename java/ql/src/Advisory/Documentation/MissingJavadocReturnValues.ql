/**
 * @name Missing Javadoc for method return value
 * @description A public method that does not have a Javadoc tag for its return
 *              value affects maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/undocumented-return-value
 * @tags maintainability
 */

import java
import JavadocCommon

from DocuReturn c
where not c.hasAcceptableReturnTag()
select c, "This method's return value does not have a non-trivial Javadoc tag."
