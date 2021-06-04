/** Provides classes for finding modable directory creations. */

import OverpermissiveFileSystemMode

/** A directory creation that takes mode. */
abstract class ModableDirectoryCreation extends ModableEntryCreation, DirectoryCreation { }

/** A directory creation that takes mode as an object property in argument 1. */
class ObjectArgument1DirectoryCreation extends
  ModableDirectoryCreation,
  Argument1EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument1DirectoryCreation() {
    this = [
      DataFlow::moduleImport("make-dir"),
      DataFlow::moduleMember("make-dir", "sync")
    ].getAnInvocation()
  }
}

/**
 * A directory creation that takes mode in argument 1
 * as either an immediate value or an object property.
 */
class ImmediateOrObjectArgument1DirectoryCreation extends
  ModableDirectoryCreation,
  Argument1EntryCreation,
  ImmediateOrPropertySpecifierEntryCreation
{
  ImmediateOrObjectArgument1DirectoryCreation() {
    this = [
      NodeJSLib::FS::moduleMember("mkdir"),
      NodeJSLib::FS::moduleMember("mkdirSync"),
      DataFlow::moduleMember("fs/promises", "mkdir"),
      DataFlow::moduleMember("fs-extra", "ensureDir"),
      DataFlow::moduleMember("fs-extra", "ensureDirSync"),
      DataFlow::moduleMember("fs-extra", "mkdirp"),
      DataFlow::moduleMember("fs-extra", "mkdirpSync"),
      DataFlow::moduleMember("fs-extra", "mkdirs"),
      DataFlow::moduleMember("fs-extra", "mkdirsSync"),
      DataFlow::moduleImport("mkdirp"),
      DataFlow::moduleMember("mkdirp", "manual"),
      DataFlow::moduleMember("mkdirp", "manualSync"),
      DataFlow::moduleMember("mkdirp", "native"),
      DataFlow::moduleMember("mkdirp", "nativeSync"),
      DataFlow::moduleMember("mkdirp", "sync"),

      // Legacy mkdirp interface
      DataFlow::moduleMember("mkdirp", "mkdirP"),
      DataFlow::moduleMember("mkdirp", "mkdirp")
    ].getAnInvocation()
  }
}
