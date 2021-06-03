import OverpermissiveFileSystemMode

class UnsecurableFileCreation extends UnsecurableEntryCreation, FileCreation {
  UnsecurableFileCreation() {
    this = DataFlow::moduleMember("fs-extra", "createFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "createFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureFileSync").getAnInvocation() or
    this = DataFlow::moduleImport("trash").getAnInvocation()
  }
}

from UnsecurableFileCreation creation
select creation, "message"
