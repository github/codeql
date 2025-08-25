/**
 * @name Partial path traversal vulnerability
 * @description A prefix used to check that a canonicalised path falls within another must be slash-terminated.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision medium
 * @id java/partial-path-traversal
 * @tags security
 *       external/cwe/cwe-023
 */

import semmle.code.java.security.PartialPathTraversal

from PartialPathTraversalMethodCall ma
select ma, "Partial Path Traversal Vulnerability due to insufficient guard against path traversal."
