/** Provides classes for finding modable directory creations. */

import OverpermissiveFileSystemMode

/** A directory creation that takes mode. */
abstract class ModableDirectoryCreation extends ModableEntryCreation, DirectoryCreation { }

/** A directory creation that takes mode as a `mode` object property in argument 1. */
class ModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  Argument1EntryCreation, PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  ModePropertyArgument1DirectoryCreation() {
    this =
      [DataFlow::moduleImport("make-dir"), DataFlow::moduleMember("make-dir", "sync")]
          .getAnInvocation()
  }
}

/**
 * A directory creation that takes mode in argument 1
 * as either an immediate value or a `mode` object property.
 */
class ImmediateOrModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  Argument1EntryCreation, ImmediateOrPropertySpecifierEntryCreation, ModePropertyEntryCreation {
  ImmediateOrModePropertyArgument1DirectoryCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("mkdir"), NodeJSLib::FS::moduleMember("mkdirSync"),
        DataFlow::moduleMember("fs/promises", "mkdir"),
        DataFlow::moduleMember("fs-extra", "ensureDir"),
        DataFlow::moduleMember("fs-extra", "ensureDirSync"),
        DataFlow::moduleMember("fs-extra", "mkdirp"),
        DataFlow::moduleMember("fs-extra", "mkdirpSync"),
        DataFlow::moduleMember("fs-extra", "mkdirs"),
        DataFlow::moduleMember("fs-extra", "mkdirsSync"),
        DataFlow::moduleMember("fs-extra-p", "ensureDir"),
        DataFlow::moduleMember("fs-extra-p", "ensureDirSync"),
        DataFlow::moduleMember("fs-extra-p", "mkdirp"),
        DataFlow::moduleMember("fs-extra-p", "mkdirpSync"),
        DataFlow::moduleMember("fs-extra-p", "mkdirs"),
        DataFlow::moduleMember("fs-extra-p", "mkdirsSync"), DataFlow::moduleImport("mkdirp"),
        DataFlow::moduleMember("mkdirp", "manual"), DataFlow::moduleMember("mkdirp", "manualSync"),
        DataFlow::moduleMember("mkdirp", "native"), DataFlow::moduleMember("mkdirp", "nativeSync"),
        DataFlow::moduleMember("mkdirp", "sync"),
        // Legacy mkdirp interface
        DataFlow::moduleMember("mkdirp", "mkdirP"), DataFlow::moduleMember("mkdirp", "mkdirp")
      ].getAnInvocation()
  }
}

/** A directory creation that takes mode as a `directoryMode` object property in argument 2. */
class DirectoryModePropertyArgument2DirectoryCreation extends ModableDirectoryCreation,
  Argument2EntryCreation, PropertySpecifierEntryCreation, DirectoryModePropertyEntryCreation {
  DirectoryModePropertyArgument2DirectoryCreation() {
    this =
      [
        DataFlow::moduleImport("move-file"), DataFlow::moduleMember("move-file", "sync"),
        DataFlow::moduleImport("cp-file"), DataFlow::moduleMember("cp-file", "sync")
      ].getAnInvocation()
  }
}
