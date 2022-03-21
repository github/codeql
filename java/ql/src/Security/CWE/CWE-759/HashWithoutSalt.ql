/**
 * @name Use of a hash function without a salt
 * @description Hashed passwords without a salt are vulnerable to dictionary attacks.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/hash-without-salt
 * @tags security
 *       external/cwe/cwe-759
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.HashWithoutSaltQuery

from Expr pw, Expr hash
where passwordHashWithoutSalt(pw, hash)
select hash, "$@ is hashed without a salt.", pw, "This password"
