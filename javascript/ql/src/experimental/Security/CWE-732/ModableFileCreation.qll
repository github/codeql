import OverpermissiveFileSystemMode

abstract class ModableFileCreation extends ModableEntryCreation, FileCreation { }

class ObjectArgument1FileCreation extends
  ModableFileCreation,
  Argument1EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument1FileCreation() {
    this = [
      NodeJSLib::FS::moduleMember("createReadStream"),
      NodeJSLib::FS::moduleMember("createWriteStream")
    ].getAnInvocation()
  }
}

class ImmediateArgument2FileCreation extends
  ModableFileCreation,
  Argument2EntryCreation,
  ImmediateSpecifierEntryCreation
{
  ImmediateArgument2FileCreation() {
    this = [
      NodeJSLib::FS::moduleMember("open"),
      NodeJSLib::FS::moduleMember("openSync"),
      DataFlow::moduleMember("fs/promises", "open")
    ].getAnInvocation()
  }
}

class ObjectArgument2FileCreation extends
  ModableFileCreation,
  Argument2EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument2FileCreation() {
    this = [
      NodeJSLib::FS::moduleMember("appendFile"),
      NodeJSLib::FS::moduleMember("appendFileSync"),
      NodeJSLib::FS::moduleMember("writeFile"),
      NodeJSLib::FS::moduleMember("writeFileSync"),
      DataFlow::moduleMember("fs/promises", "appendFile"),
      DataFlow::moduleMember("fs/promises", "writeFile"),
      DataFlow::moduleMember("jsonfile", "writeFile"),
      DataFlow::moduleMember("jsonfile", "writeFileSync"),
      DataFlow::moduleMember("fs-extra", "writeJSON"),
      DataFlow::moduleMember("fs-extra", "writeJSONSync"),
      DataFlow::moduleMember("fs-extra", "writeJson"),
      DataFlow::moduleMember("fs-extra", "writeJsonSync")
    ].getAnInvocation()
  }
}
