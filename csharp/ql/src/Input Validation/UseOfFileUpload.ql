/**
 * @name Use of file upload
 * @description Finds uses of file upload
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/web/file-upload
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-434
 */

import csharp

from PropertyAccess pa
where
  pa.getTarget().hasName("PostedFile") and
  pa.getTarget().getDeclaringType().hasQualifiedName("System.Web.UI.HtmlControls", "HtmlInputFile")
select pa, "Avoid using file upload."
