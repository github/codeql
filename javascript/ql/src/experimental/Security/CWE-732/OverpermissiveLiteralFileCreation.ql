import ModableFileCreation

abstract class LiteralFileCreation extends LiteralEntryCreation, FileCreation {
  override Mask getMask() { result = getOverpermissiveFileMask() }
}

class LiteralObjectArgument1FileCreation extends
  ObjectArgument1FileCreation,
  LiteralFileCreation {}

class LiteralImmediateArgument2FileCreation extends
  ImmediateArgument2FileCreation,
  LiteralFileCreation {}

class LiteralObjectArgument2FileCreation extends
  ObjectArgument2FileCreation,
  LiteralFileCreation {}

from LiteralFileCreation creation
where creation.isOverpermissive()
select creation, "message"
