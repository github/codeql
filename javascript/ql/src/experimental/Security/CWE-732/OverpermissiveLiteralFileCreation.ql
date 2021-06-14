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

/**
 * An insecure default file creation
 * that provides a literal mode as a `mode` property in argument 1.
 */
class LiteralInsecureModePropertyArgument1FileCreation extends InsecureModePropertyArgument1FileCreation,
  LiteralFileCreation { }

/**
 * A secure default file creation
 * that provides a literal mode as a `mode` property in argument 1.
 */
class LiteralSecureModePropertyArgument1FileCreation extends SecureModePropertyArgument1FileCreation,
  LiteralFileCreation { }

/**
 * An insecure default file creation
 * that provides a literal mode as an immediate value in argument 2.
 */
class LiteralInsecureImmediateArgument2FileCreation extends InsecureImmediateArgument2FileCreation,
  LiteralFileCreation { }

/**
 * A secure default file creation
 * that provides a literal mode as an immediate value in argument 2.
 */
class LiteralSecureImmediateArgument2FileCreation extends SecureImmediateArgument2FileCreation,
  LiteralFileCreation { }

/**
 * An insecure default file creation
 * that provides a literal mode as a `mode` property in argument 2.
 */
class LiteralInsecureModePropertyArgument2FileCreation extends InsecureModePropertyArgument2FileCreation,
  LiteralFileCreation { }

/**
 * A secure default file creation
 * that provides a literal mode as a `mode` property in argument 2.
 */
class LiteralSecureModePropertyArgument2FileCreation extends SecureModePropertyArgument2FileCreation,
  LiteralFileCreation { }

from LiteralFileCreation creation
where creation.isOverpermissive()
select creation, "This call uses an overpermissive mode that creates world writable files."
