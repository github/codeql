/**
 * @name XML is read insecurely
 * @description XML may include dangerous external references, which should
 *              be restricted using a secure resolver or disabling DTD processing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.1
 * @precision low
 * @id cs/insecure-xml-read
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-827
 *       external/cwe/cwe-776
 */

import csharp
import semmle.code.csharp.security.xml.InsecureXMLQuery

from InsecureXmlProcessing xmlProcessing, string reason
where xmlProcessing.isUnsafe(reason)
select xmlProcessing, "Insecure XML processing: " + reason
