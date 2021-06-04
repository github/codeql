import OverpermissiveFileSystemMode

abstract class ModableDirectoryCreation extends ModableEntryCreation, DirectoryCreation { }

class ObjectArgument1DirectoryCreation extends
  ModableDirectoryCreation,
  Argument1EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument1DirectoryCreation() {
    this = DataFlow::moduleImport("make-dir").getAnInvocation() or
    this = DataFlow::moduleMember("make-dir", "sync").getAnInvocation()
  }
}

class ImmediateOrObjectArgument1DirectoryCreation extends
  ModableDirectoryCreation,
  Argument1EntryCreation,
  ImmediateOrPropertySpecifierEntryCreation
{
  ImmediateOrObjectArgument1DirectoryCreation() {
    this = NodeJSLib::FS::moduleMember("mkdir").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("mkdirSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs/promises", "mkdir").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureDir").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "ensureDirSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "mkdirp").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "mkdirpSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "mkdirs").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "mkdirsSync").getAnInvocation() or
    this = DataFlow::moduleImport("mkdirp").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "manual").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "manualSync").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "native").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "nativeSync").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "sync").getAnInvocation() or

    // Legacy mkdirp interface
    this = DataFlow::moduleMember("mkdirp", "mkdirP").getAnInvocation() or
    this = DataFlow::moduleMember("mkdirp", "mkdirp").getAnInvocation()
  }
}
