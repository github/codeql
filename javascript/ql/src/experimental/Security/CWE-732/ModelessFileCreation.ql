/**
 * @name Modeless file creation
 * @description Creating program files without specifying mode defaults to world writable
 *              which may allow an attacker to control program behavior by modifying them.
 * @kind problem
 * @id js/insecure-fs/modeless-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableFileCreation

from ModableFileCreation creation
where creation.isModeless()
select creation, "This modeless call creates world writable files."
