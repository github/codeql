/**
 * Provides classes and predicates related to contextual queries
 * in the code viewer.
 */

import go

/**
 * Gets the `File` with encoded name `name`.
 */
cached
File getEncodedFile(string name) { result.getAbsolutePath().replaceAll(":", "_") = name }
