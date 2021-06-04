import OverpermissiveFileSystemMode

class UnsecurableFileCreation extends UnsecurableEntryCreation, FileCreation {
  UnsecurableFileCreation() {
    this = [
      DataFlow::moduleMember("fs-extra", "createFile"),
      DataFlow::moduleMember("fs-extra", "createFileSync"),
      DataFlow::moduleMember("fs-extra", "ensureFile"),
      DataFlow::moduleMember("fs-extra", "ensureFileSync"),
      DataFlow::moduleImport("trash")
    ].getAnInvocation()
  }
}

from UnsecurableFileCreation creation
select creation, "message"
