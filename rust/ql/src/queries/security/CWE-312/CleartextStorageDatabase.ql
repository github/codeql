/**
 * @name Cleartext storage of sensitive information in a database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision high
 * @id rust/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import rust

select 0
