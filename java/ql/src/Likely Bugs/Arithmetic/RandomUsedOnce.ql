/**
 * @name Random used only once
 * @description Creating an instance of 'Random' for each pseudo-random number required does not
 *              guarantee an evenly distributed sequence of random numbers.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/random-used-once
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-335
 */

import java
import semmle.code.java.security.RandomQuery

from RandomDataSource ma
where ma.getQualifier() instanceof ClassInstanceExpr
select ma, "Random object created and used only once."
