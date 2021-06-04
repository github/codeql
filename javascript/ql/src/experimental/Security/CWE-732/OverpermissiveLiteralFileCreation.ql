import ModableFileCreation

/** A file creation that provides mode as a literal. */
abstract class LiteralFileCreation extends LiteralEntryCreation, FileCreation {
  override Mask getMask() { result = getOverpermissiveFileMask() }
}

/** A file creation that provides a literal mode as an object property in argument 1. */
class LiteralObjectArgument1FileCreation extends
  ObjectArgument1FileCreation,
  LiteralFileCreation { }

/** A file creation that provides a literal mode as an immediate value in argument 2. */
class LiteralImmediateArgument2FileCreation extends
  ImmediateArgument2FileCreation,
  LiteralFileCreation { }

/** A file creation that provides a literal mode as an object property in argument 2. */
class LiteralObjectArgument2FileCreation extends
  ObjectArgument2FileCreation,
  LiteralFileCreation { }

from LiteralFileCreation creation
where creation.isOverpermissive()
select creation, "message"
