/**
 * @name Overpermissive literal file creation
 * @description Creating program files world writable may allow an attacker to control program
 *              behavior by modifying them.
 * @kind problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-literal-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableFileCreation

/** A file creation that provides mode as a literal. */
abstract class LiteralFileCreation extends LiteralEntryCreation, FileCreation {
  override Mask getMask() { result = getOverpermissiveFileMask() }
}

/** A file creation that provides a literal mode as a `mode` property in argument 1. */
class LiteralModePropertyArgument1FileCreation extends ModePropertyArgument1FileCreation, LiteralFileCreation {
}

/** A file creation that provides a literal mode as an immediate value in argument 2. */
class LiteralImmediateArgument2FileCreation extends ImmediateArgument2FileCreation,
  LiteralFileCreation { }

/** A file creation that provides a literal mode as a `mode` property in argument 2. */
class LiteralModePropertyArgument2FileCreation extends ModePropertyArgument2FileCreation, LiteralFileCreation {
}

from LiteralFileCreation creation
where creation.isOverpermissive()
select creation, "This call uses an overpermissive mode that creates world writable files."
