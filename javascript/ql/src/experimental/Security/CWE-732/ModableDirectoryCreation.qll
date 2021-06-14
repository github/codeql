/** Provides classes for finding modable directory creations. */

import OverpermissiveFileSystemMode

/** A directory creation that takes mode. */
abstract class ModableDirectoryCreation extends ModableEntryCreation, DirectoryCreation { }

/**
 * An insecure default directory creation
 * that takes mode as a `mode` object property in argument 1.
 */
class InsecureModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  InsecureEntryCreation, Argument1EntryCreation, PropertySpecifierEntryCreation,
  ModePropertyEntryCreation {
  InsecureModePropertyArgument1DirectoryCreation() {
    this =
      [DataFlow::moduleImport("make-dir"), DataFlow::moduleMember("make-dir", "sync")]
          .getAnInvocation()
  }
}

/**
 * An insecure default directory creation that takes mode in argument 1
 * as either an immediate value or a `mode` object property.
 */
class InsecureImmediateOrModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  InsecureEntryCreation, Argument1EntryCreation, ImmediateOrPropertySpecifierEntryCreation,
  ModePropertyEntryCreation {
  InsecureImmediateOrModePropertyArgument1DirectoryCreation() {
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

/**
 * A secure default directory creation
 * that takes mode as a `dirMode` object property in argument 1.
 */
class SecureDirModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  SecureEntryCreation, Argument1EntryCreation, PropertySpecifierEntryCreation,
  DirModePropertyEntryCreation {
  SecureDirModePropertyArgument1DirectoryCreation() {
    this = [
      DataFlow::moduleMember("secure-fs-extra", "createFile"),
      DataFlow::moduleMember("secure-fs-extra", "createFileSync"),
      DataFlow::moduleMember("secure-fs-extra", "ensureFile"),
      DataFlow::moduleMember("secure-fs-extra", "ensureFileSync")
    ].getAnInvocation()
  }
}

/**
 * A secure default directory creation that takes mode in argument 1
 * as either an immediate value or a `mode` object property.
 */
class SecureImmediateOrModePropertyArgument1DirectoryCreation extends ModableDirectoryCreation,
  SecureEntryCreation, Argument1EntryCreation, ImmediateOrPropertySpecifierEntryCreation,
  ModePropertyEntryCreation {
    SecureImmediateOrModePropertyArgument1DirectoryCreation() {
    this =
      [
        DataFlow::moduleMember("secure-fs", "mkdir"),
        DataFlow::moduleMember("secure-fs", "mkdirSync"),
        DataFlow::moduleMember("secure-fs/promises", "mkdir"),
        DataFlow::moduleMember("secure-fs-extra", "emptyDir"),
        DataFlow::moduleMember("secure-fs-extra", "emptyDirSync"),
        DataFlow::moduleMember("secure-fs-extra", "emptydir"),
        DataFlow::moduleMember("secure-fs-extra", "emptydirSync"),
        DataFlow::moduleMember("secure-fs-extra", "ensureDir"),
        DataFlow::moduleMember("secure-fs-extra", "ensureDirSync"),
        DataFlow::moduleMember("secure-fs-extra", "mkdirp"),
        DataFlow::moduleMember("secure-fs-extra", "mkdirpSync"),
        DataFlow::moduleMember("secure-fs-extra", "mkdirs"),
        DataFlow::moduleMember("secure-fs-extra", "mkdirsSync")
      ].getAnInvocation()
  }
}

/**
 * An insecure default directory creation
 * that takes mode as a `directoryMode` object property in argument 2.
 */
class InsecureDirectoryModePropertyArgument2DirectoryCreation extends ModableDirectoryCreation,
  InsecureEntryCreation, Argument2EntryCreation, PropertySpecifierEntryCreation,
  DirectoryModePropertyEntryCreation {
  InsecureDirectoryModePropertyArgument2DirectoryCreation() {
    this =
      [
        DataFlow::moduleImport("move-file"), DataFlow::moduleMember("move-file", "sync"),
        DataFlow::moduleImport("cp-file"), DataFlow::moduleMember("cp-file", "sync")
      ].getAnInvocation()
  }
}

/**
 * A secure default directory creation
 * that takes mode as a `dirMode` object property in argument 2.
 */
class SecureDirModePropertyArgument2DirectoryCreation extends ModableDirectoryCreation,
  SecureEntryCreation, Argument2EntryCreation, PropertySpecifierEntryCreation,
  DirModePropertyEntryCreation {
  SecureDirModePropertyArgument2DirectoryCreation() {
    this = [
      DataFlow::moduleMember("secure-fs-extra", "createLink"),
      DataFlow::moduleMember("secure-fs-extra", "createLinkSync"),
      DataFlow::moduleMember("secure-fs-extra", "createSymlink"),
      DataFlow::moduleMember("secure-fs-extra", "createSymlinkSync"),
      DataFlow::moduleMember("secure-fs-extra", "ensureLink"),
      DataFlow::moduleMember("secure-fs-extra", "ensureLinkSync"),
      DataFlow::moduleMember("secure-fs-extra", "ensureSymlink"),
      DataFlow::moduleMember("secure-fs-extra", "ensureSymlinkSync"),
      DataFlow::moduleMember("secure-fs-extra", "outputFile"),
      DataFlow::moduleMember("secure-fs-extra", "outputFileSync"),
      DataFlow::moduleMember("secure-fs-extra", "outputJSON"),
      DataFlow::moduleMember("secure-fs-extra", "outputJSONSync"),
      DataFlow::moduleMember("secure-fs-extra", "outputJson"),
      DataFlow::moduleMember("secure-fs-extra", "outputJsonSync")
    ].getAnInvocation()
  }
}
