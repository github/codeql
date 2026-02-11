/**
 * Provides classes for identifying files that created to test the
 * build configuration. It is often desirable to exclude these files
 * from analysis.
 */

import File

/**
 * A file created to test the system configuration.
 */
abstract class ConfigurationTestFile extends File { }

/**
 * A file created by CMake to test the system configuration.
 */
class CmakeTryCompileFile extends ConfigurationTestFile {
  CmakeTryCompileFile() {
    exists(Folder folder, Folder parent |
      folder = this.getParentContainer() and
      parent = folder.getParentContainer()
    |
      folder.getBaseName().matches("TryCompile-%") and
      parent.getBaseName() = "CMakeScratch" and
      parent.getParentContainer().getBaseName() = "CMakeFiles"
    )
  }
}
