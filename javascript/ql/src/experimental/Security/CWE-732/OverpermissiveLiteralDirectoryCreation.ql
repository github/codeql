import ModableDirectoryCreation

abstract class LiteralDirectoryCreation extends
  LiteralEntryCreation,
  DirectoryCreation
{
  override Mask getMask() { result = getOverpermissiveDirectoryMask() }
}

class LiteralObjectArgument1DirectoryCreation extends
  ObjectArgument1DirectoryCreation,
  LiteralDirectoryCreation {}

class LiteralImmediateOrObjectArgument1DirectoryCreation extends
  ImmediateOrObjectArgument1DirectoryCreation,
  LiteralDirectoryCreation {}

from LiteralDirectoryCreation creation
where creation.isOverpermissive()
select creation, "message"
