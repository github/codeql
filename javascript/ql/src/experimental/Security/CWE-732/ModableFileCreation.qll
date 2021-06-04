import OverpermissiveFileSystemMode

abstract class ModableFileCreation extends ModableEntryCreation, FileCreation { }

class ObjectArgument1FileCreation extends
  ModableFileCreation,
  Argument1EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument1FileCreation() {
    this = NodeJSLib::FS::moduleMember("createReadStream").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("createWriteStream").getAnInvocation()
  }
}

class ImmediateArgument2FileCreation extends
  ModableFileCreation,
  Argument2EntryCreation,
  ImmediateSpecifierEntryCreation
{
  ImmediateArgument2FileCreation() {
    this = NodeJSLib::FS::moduleMember("open").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("openSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs/promises", "open").getAnInvocation()
  }
}

class ObjectArgument2FileCreation extends
  ModableFileCreation,
  Argument2EntryCreation,
  PropertySpecifierEntryCreation
{
  ObjectArgument2FileCreation() {
    this = NodeJSLib::FS::moduleMember("appendFile").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("appendFileSync").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("writeFile").getAnInvocation() or
    this = NodeJSLib::FS::moduleMember("writeFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs/promises", "appendFile").getAnInvocation() or
    this = DataFlow::moduleMember("fs/promises", "writeFile").getAnInvocation() or
    this = DataFlow::moduleMember("jsonfile", "writeFile").getAnInvocation() or
    this = DataFlow::moduleMember("jsonfile", "writeFileSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "writeJSON").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "writeJSONSync").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "writeJson").getAnInvocation() or
    this = DataFlow::moduleMember("fs-extra", "writeJsonSync").getAnInvocation()
  }
}
