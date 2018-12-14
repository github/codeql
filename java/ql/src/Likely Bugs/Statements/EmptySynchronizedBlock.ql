/**
 * @name Empty synchronized block
 * @description Empty synchronized blocks may indicate the presence of
 *              incomplete code or incorrect synchronization, and may lead to concurrency problems.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/empty-synchronized-block
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-585
 */

import java

from SynchronizedStmt sync
where not exists(sync.getBlock().getAChild())
select sync, "Empty synchronized block."
