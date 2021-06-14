/**
 * @name Modeless directory creation
 * @description Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind problem
 * @problem.severity warning
 * @id js/insecure-fs/modeless-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableDirectoryCreation

from ModableDirectoryCreation creation
where creation.isInsecure() and creation.isModeless()
select creation, "This modeless call creates world writable directories."
