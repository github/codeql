/**
 * @id java/freemarker-unsafe-configuration
 * @name Unsafe Freemarker Configuration
 * @description There is an unsafe Freemarker Configuration, that may lead to SSTI vulnerability
 *              that results in RCE. To protect against this 
 *              1) set class resolver to ALLOWS_NOTHING_RESOLVER,
 *              2) dont set setAPIBuiltinEnabled to true
 *              3) dont interpret user-input inside of template.
 * @kind problem
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-094
 * @precision high
 */

import java
import Freemarker

from Freemarker::FreemarkerTemplateConfigurationSource c
where not c.isSafe()
select c, "Unsafe Freemarker Configuration"
