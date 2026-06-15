/**
 * @name Apache Struts development mode enabled
 * @description Enabling struts development mode in production environment
 *  can lead to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/struts-development-mode
 * @tags security
 *       experimental
 *       external/cwe/cwe-489
 */

import java
deprecated import experimental.semmle.code.xml.StrutsXML

bindingset[path]
predicate isLikelyDemoProject(string path) { path.regexpMatch("(?i).*(demo|test|example).*") }

deprecated query predicate problems(ConstantParameter c, string message) {
  c.getNameValue() = "struts.devMode" and
  c.getValueValue() = "true" and
  not isLikelyDemoProject(c.getFile().getRelativePath()) and
  message = "Enabling development mode in production environments is dangerous."
}
