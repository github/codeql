/** Provides classes for finding modable file creations. */

import OverpermissiveFileSystemMode

/** A file creation that takes mode. */
abstract class ModableFileCreation extends ModableEntryCreation, FileCreation { }

/** A file creation that takes mode as a `mode` property in argument 1. */
class ModePropertyArgument1FileCreation extends ModableFileCreation, Argument1EntryCreation,
  PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  ModePropertyArgument1FileCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("createReadStream"),
        NodeJSLib::FS::moduleMember("createWriteStream")
      ].getAnInvocation()
  }
}

/** A file creation that takes mode as an immediate value in argument 2. */
class ImmediateArgument2FileCreation extends ModableFileCreation, Argument2EntryCreation,
  ImmediateSpecifierEntryCreation {
  ImmediateArgument2FileCreation() {
    this =
      [
        NodeJSLib::FS::moduleMember("open"), NodeJSLib::FS::moduleMember("openSync"),
        DataFlow::moduleMember("fs/promises", "open")
      ].getAnInvocation()
  }
}

/** A file creation that takes mode as a `mode` property in argument 2. */
class ModePropertyArgument2FileCreation extends ModableFileCreation, Argument2EntryCreation,
  PropertySpecifierEntryCreation, ModePropertyEntryCreation {
  ModePropertyArgument2FileCreation() {
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
