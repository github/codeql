/**
 * @name Too many beans in file
 * @description Too many beans in a file can make the file difficult to understand and maintain.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/too-many-beans
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

from SpringBeanFile f
where count(f.getABean()) > 40
select f, "There are too many beans in this file."
