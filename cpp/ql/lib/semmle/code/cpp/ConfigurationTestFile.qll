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

/**
 * A file created by Meson to test the system configuration.
 */
class MesonPrivateTestFile extends ConfigurationTestFile {
  MesonPrivateTestFile() {
    this.getBaseName() = "testfile.c" and
    exists(Folder folder, Folder parent |
      folder = this.getParentContainer() and
      parent = folder.getParentContainer()
    |
      folder.getBaseName().matches("tmp%") and
      parent.getBaseName() = "meson-private"
    )
  }
}

/**
 * A file created by a GNU autoconf configure script to test the system configuration.
 */
class AutoconfConfigureTestFile extends ConfigurationTestFile {
  AutoconfConfigureTestFile() { this.getBaseName().regexpMatch("conftest[0-9]*\\.c(pp)?") }
}
