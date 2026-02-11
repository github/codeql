/**
 * @name Sensitive Data
 * @description List all sensitive data found in the database. Sensitive data is anything that
 *              should not be sent in unencrypted form.
 * @kind problem
 * @problem.severity info
 * @id rust/summary/sensitive-data
 * @tags summary
 */

import rust
import codeql.rust.security.SensitiveData

from SensitiveData d
select d, "Sensitive data (" + d.getClassification() + "): " + d.toString()
