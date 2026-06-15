/**
 * Provides shared predicates related to contextual queries in the code viewer.
 */

import codeql.files.FileSystem
private import codeql.util.FileSystem

/**
 * Returns an appropriately encoded version of a filename `name`
 * passed by the VS Code extension in order to coincide with the
 * output of `.getFile()` on locatable entities.
 */
cached
File getFileBySourceArchiveName(string name) {
  result = IdeContextual<File>::getFileBySourceArchiveName(name)
}
