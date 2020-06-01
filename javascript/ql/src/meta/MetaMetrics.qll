/**
 * Helpers to generating meta metrics, that is, metrics about the CodeQL analysis and extractor.
 */
private import javascript

/**
 * Gets the root folder of the snapshot.
 *
 * This is selected as the location for project-wide metrics.
 */
Folder projectRoot() { result.getRelativePath() = "" }
