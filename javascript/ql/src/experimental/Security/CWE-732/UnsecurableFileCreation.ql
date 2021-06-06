/**
 * @name Unsecurable file creation
 * @description A file creation function that takes no mode defaults to world writable.
 *              Creating program files world writable may allow an attacker to control program
 *              behavior by modifying them.
 * @kind problem
 * @problem.severity warning
 * @id js/insecure-fs/unsecurable-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import OverpermissiveFileSystemMode

/** A file creation that cannot be secured, because it offers no way to specify mode. */
class UnsecurableFileCreation extends UnsecurableEntryCreation, FileCreation {
  UnsecurableFileCreation() {
    this =
      [
        DataFlow::moduleMember("fs-extra", "createFile"),
        DataFlow::moduleMember("fs-extra", "createFileSync"),
        DataFlow::moduleMember("fs-extra", "ensureFile"),
        DataFlow::moduleMember("fs-extra", "ensureFileSync"),
        DataFlow::moduleMember("fs-extra-p", "createFile"),
        DataFlow::moduleMember("fs-extra-p", "createFileSync"),
        DataFlow::moduleMember("fs-extra-p", "ensureFile"),
        DataFlow::moduleMember("fs-extra-p", "ensureFileSync"), DataFlow::moduleImport("trash")
      ].getAnInvocation()
  }
}

from UnsecurableFileCreation creation
select creation, "This unsecurable function creates world writable files."
