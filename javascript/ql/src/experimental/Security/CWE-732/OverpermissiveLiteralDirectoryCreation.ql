/**
 * @name Overpermissive literal directory creation
 * @description Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-literal-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableDirectoryCreation

/** A directory creation that provides mode as a literal. */
abstract class LiteralDirectoryCreation extends LiteralEntryCreation, DirectoryCreation {
  override Mask getMask() { result = getOverpermissiveDirectoryMask() }
}

/**
 * An insecure default directory creation
 * that provides a literal mode as a `mode` property in argument 1.
 */
class LiteralInsecureModePropertyArgument1DirectoryCreation extends InsecureModePropertyArgument1DirectoryCreation,
  LiteralDirectoryCreation { }

/**
 * An insecure default directory creation
 * that provides a literal mode as a `directoryMode` property in argument 2.
 */
class LiteralInsecureDirectoryModePropertyArgument2DirectoryCreation extends InsecureDirectoryModePropertyArgument2DirectoryCreation,
  LiteralDirectoryCreation { }

/**
 * An insecure default directory creation
 * that provides a literal mode in argument 1 as either an immediate value or a `mode` property.
 */
class LiteralInsecureImmediateOrModePropertyArgument1DirectoryCreation extends InsecureImmediateOrModePropertyArgument1DirectoryCreation,
  LiteralDirectoryCreation { }

/**
 * A secure default directory creation
 * that provides a literal mode in argument 1 as either an immediate value or a `mode` property.
 */
class LiteralSecureImmediateOrModePropertyArgument1DirectoryCreation extends SecureImmediateOrModePropertyArgument1DirectoryCreation,
  LiteralDirectoryCreation { }

from LiteralDirectoryCreation creation
where creation.isOverpermissive()
select creation, "This call uses an overpermissive mode that creates world writable directories."
