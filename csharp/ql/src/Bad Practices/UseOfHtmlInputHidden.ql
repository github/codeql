/**
 * @name Use of HTMLInputHidden
 * @description Finds uses of hidden fields on forms
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id cs/web/html-hidden-input
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-472
 */

import csharp

from ObjectCreation oc
where oc.getType().(Class).hasFullyQualifiedName("System.Web.UI.HtmlControls", "HtmlInputHidden")
select oc, "Avoid using 'HTMLInputHidden' fields."
