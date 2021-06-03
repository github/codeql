import OverpermissiveFileSystemMode

class UnsecurableDirectoryCreation extends
  UnsecurableEntryCreation,
  DirectoryCreation
{
  UnsecurableDirectoryCreation() {
    this = DataFlow::moduleMember("fs-extra", "createFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createLink").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createLinkSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createSymlink").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createSymlinkSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "emptyDir").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "emptyDirSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "emptydir").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "emptydirSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureLink").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureLinkSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureSymlink").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureSymlinkSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputJSON").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputJSONSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputJson").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "outputJsonSync").getAnInvocation() or
    this = DataFlow::moduleImport("cp-file").getAnInvocation() or
    this = DataFlow::moduleMember("cp-file", "sync").getAnInvocation() or
    this = DataFlow::moduleImport("cpy").getAnInvocation() or
    this = DataFlow::moduleImport("move-file").getAnInvocation() or
    this = DataFlow::moduleMember("move-file", "sync").getAnInvocation() or
    this = DataFlow::moduleImport("@npmcli/move-file").getAnInvocation() or
    this = DataFlow::moduleMember("@npmcli/move-file", "sync").getAnInvocation() or
    this = DataFlow::moduleImport("trash").getAnInvocation()
  }
}

from UnsecurableDirectoryCreation creation
select creation, "message"
