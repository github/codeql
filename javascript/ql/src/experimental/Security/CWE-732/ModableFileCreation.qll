/** Provides classes for finding modable file creations. */

import OverpermissiveFileSystemMode

/** A file creation that takes mode. */
abstract class ModableFileCreation extends ModableEntryCreation, FileCreation { }

/** An insecure default file creation that takes mode as a `mode` property in argument 1. */
class InsecureModePropertyArgument1FileCreation extends ModableFileCreation, InsecureEntryCreation,
  Argument1EntryCreation, PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  InsecureModePropertyArgument1FileCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("createReadStream"),
        NodeJSLib::FS::moduleMember("createWriteStream")
      ].getAnInvocation()
  }
}

/** A secure default file creation that takes mode as a `mode` property in argument 1. */
class SecureModePropertyArgument1FileCreation extends ModableFileCreation, SecureEntryCreation,
  Argument1EntryCreation, PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  SecureModePropertyArgument1FileCreation() {
    this =
      [
        DataFlow::moduleMember("secure-fs", "createReadStream"),
        DataFlow::moduleMember("secure-fs", "createWriteStream")
      ].getAnInvocation()
  }
}

/** An insecure default file creation that takes mode as an immediate value in argument 2. */
class InsecureImmediateArgument2FileCreation extends ModableFileCreation, InsecureEntryCreation,
  Argument2EntryCreation, ImmediateSpecifierEntryCreation {
  InsecureImmediateArgument2FileCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("open"), NodeJSLib::FS::moduleMember("openSync"),
        DataFlow::moduleMember("fs/promises", "open")
      ].getAnInvocation()
  }
}

/** A secure default file creation that takes mode as an immediate value in argument 2. */
class SecureImmediateArgument2FileCreation extends ModableFileCreation, SecureEntryCreation,
  Argument2EntryCreation, ImmediateSpecifierEntryCreation {
  SecureImmediateArgument2FileCreation() {
    this =
      [
        DataFlow::moduleMember("secure-fs", "open"),
        DataFlow::moduleMember("secure-fs", "openSync"),
        DataFlow::moduleMember("secure-fs/promises", "open")
      ].getAnInvocation()
  }
}

/** An insecure default file creation that takes mode as a `mode` property in argument 2. */
class InsecureModePropertyArgument2FileCreation extends ModableFileCreation, InsecureEntryCreation,
  Argument2EntryCreation, PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  InsecureModePropertyArgument2FileCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("appendFile"), NodeJSLib::FS::moduleMember("appendFileSync"),
        NodeJSLib::FS::moduleMember("writeFile"), NodeJSLib::FS::moduleMember("writeFileSync"),
        DataFlow::moduleMember("fs/promises", "appendFile"),
        DataFlow::moduleMember("fs/promises", "writeFile"),
        DataFlow::moduleMember("jsonfile", "writeFile"),
        DataFlow::moduleMember("jsonfile", "writeFileSync"),
        DataFlow::moduleMember("fs-extra", "writeJSON"),
        DataFlow::moduleMember("fs-extra", "writeJSONSync"),
        DataFlow::moduleMember("fs-extra", "writeJson"),
        DataFlow::moduleMember("fs-extra", "writeJsonSync"),
        DataFlow::moduleMember("fs-extra-p", "writeJSON"),
        DataFlow::moduleMember("fs-extra-p", "writeJSONSync"),
        DataFlow::moduleMember("fs-extra-p", "writeJson"),
        DataFlow::moduleMember("fs-extra-p", "writeJsonSync")
      ].getAnInvocation()
  }
}

/** A secure default file creation that takes mode as a `mode` property in argument 2. */
class SecureModePropertyArgument2FileCreation extends ModableFileCreation, SecureEntryCreation,
  Argument2EntryCreation, PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  SecureModePropertyArgument2FileCreation() {
    this =
      [
        DataFlow::moduleMember("secure-fs", "appendFile"),
        DataFlow::moduleMember("secure-fs", "appendFileSync"),
        DataFlow::moduleMember("secure-fs", "writeFile"),
        DataFlow::moduleMember("secure-fs", "writeFileSync"),
        DataFlow::moduleMember("secure-fs/promises", "appendFile"),
        DataFlow::moduleMember("secure-fs/promises", "writeFile"),
        DataFlow::moduleMember("secure-fs-extra", "createFile"),
        DataFlow::moduleMember("secure-fs-extra", "createFileSync"),
        DataFlow::moduleMember("secure-fs-extra", "ensureFile"),
        DataFlow::moduleMember("secure-fs-extra", "ensureFileSync"),
        DataFlow::moduleMember("secure-fs-extra", "writeJSON"),
        DataFlow::moduleMember("secure-fs-extra", "writeJSONSync"),
        DataFlow::moduleMember("secure-fs-extra", "writeJson"),
        DataFlow::moduleMember("secure-fs-extra", "writeJsonSync")
      ].getAnInvocation()
  }
}
