/**
 * Provides the `PchFile` class representing precompiled header (PCH) files created and
 * used during the build process.
 */

import semmle.code.cpp.File

/**
 * A precompiled header (PCH) file created during the build process.
 */
class PchFile extends @pch {
  /**
   *  Gets a textual representation of this element.
   */
  string toString() { result = "PCH for " + this.getHeaderFile() }

  /**
   * Gets the header file from which the PCH file was created.
   */
  File getHeaderFile() { pch_creations(this, _, result) }

  /**
   * Gets a source file that includes the PCH.
   */
  File getAUse() { pch_uses(this, _, result) }
}
