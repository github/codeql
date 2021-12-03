/**
 * Provides classes and predicates related to contextual queries
 * in the code viewer.
 */

import go

/**
 * Returns the `File` matching the given source file name as encoded by the VS
 * Code extension.
 */
cached
File getFileBySourceArchiveName(string name) {
  // The name provided for a file in the source archive by the VS Code extension
  // has some differences from the absolute path in the database:
  // 1. colons are replaced by underscores
  // 2. there's a leading slash, even for Windows paths: "C:/foo/bar" ->
  //    "/C_/foo/bar"
  // 3. double slashes in UNC prefixes are replaced with a single slash
  // We can handle 2 and 3 together by unconditionally adding a leading slash
  // before replacing double slashes.
  name = ("/" + result.getAbsolutePath().replaceAll(":", "_")).replaceAll("//", "/")
}
