/**
 * @name Unsecurable directory creation
 * @description A directory creation function that takes no mode defaults to world writable.
 *              Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind problem
 * @id js/insecure-fs/unsecurable-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import OverpermissiveFileSystemMode

/** A directory creation that cannot be secured, because it offers no way to specify mode. */
class UnsecurableDirectoryCreation extends UnsecurableEntryCreation, DirectoryCreation {
  UnsecurableDirectoryCreation() {
    this = [
      DataFlow::moduleMember("fs-extra", "createFile"),
      DataFlow::moduleMember("fs-extra", "createFileSync"),
      DataFlow::moduleMember("fs-extra", "createLink"),
      DataFlow::moduleMember("fs-extra", "createLinkSync"),
      DataFlow::moduleMember("fs-extra", "createSymlink"),
      DataFlow::moduleMember("fs-extra", "createSymlinkSync"),
      DataFlow::moduleMember("fs-extra", "emptyDir"),
      DataFlow::moduleMember("fs-extra", "emptyDirSync"),
      DataFlow::moduleMember("fs-extra", "emptydir"),
      DataFlow::moduleMember("fs-extra", "emptydirSync"),
      DataFlow::moduleMember("fs-extra", "ensureFile"),
      DataFlow::moduleMember("fs-extra", "ensureFileSync"),
      DataFlow::moduleMember("fs-extra", "ensureLink"),
      DataFlow::moduleMember("fs-extra", "ensureLinkSync"),
      DataFlow::moduleMember("fs-extra", "ensureSymlink"),
      DataFlow::moduleMember("fs-extra", "ensureSymlinkSync"),
      DataFlow::moduleMember("fs-extra", "outputFile"),
      DataFlow::moduleMember("fs-extra", "outputFileSync"),
      DataFlow::moduleMember("fs-extra", "outputJSON"),
      DataFlow::moduleMember("fs-extra", "outputJSONSync"),
      DataFlow::moduleMember("fs-extra", "outputJson"),
      DataFlow::moduleMember("fs-extra", "outputJsonSync"),
      DataFlow::moduleImport("cp-file"),
      DataFlow::moduleMember("cp-file", "sync"),
      DataFlow::moduleImport("cpy"),
      DataFlow::moduleImport("move-file"),
      DataFlow::moduleMember("move-file", "sync"),
      DataFlow::moduleImport("@npmcli/move-file"),
      DataFlow::moduleMember("@npmcli/move-file", "sync"),
      DataFlow::moduleImport("trash")
    ].getAnInvocation()
  }
}

from UnsecurableDirectoryCreation creation
select creation, "message"
