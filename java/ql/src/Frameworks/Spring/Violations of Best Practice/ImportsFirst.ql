/**
 * @name Imports should come before bean definitions
 * @description Putting 'import' statements before bean definitions in a Spring bean configuration
 *              file makes it easier to immediately see all the file's dependencies.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/import-location
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringImport i
where
  exists(SpringBean b |
    i.getSpringBeanFile() = b.getSpringBeanFile() and
    i.getLocation().getStartLine() > b.getLocation().getStartLine()
  )
select i, "Imports should come before bean definitions."
