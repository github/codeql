/**
 * @name Partial Path Traversal Vulnerability
 * @description A misuse of the String `startsWith` method as a guard to protect against path traversal is insufficient.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/partial-path-traversal
 * @tags security
 *       external/cwe/cwe-023
 */

import java 


class MethodStringStartsWith extends Method {
    MethodStringStartsWith() {
        this.hasName("startsWith")
    }
}

from MethodAccess ma 
where ma.getMethod() instanceof MethodStringStartsWith
select ma, "Partial Path Traversal Vulnerability due to insufficient guard against path traversal"