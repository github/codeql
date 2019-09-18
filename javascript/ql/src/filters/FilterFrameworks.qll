import semmle.javascript.dependencies.FrameworkLibraries

/**
 * Holds if file `f` does not contain a framework library.
 */
pragma[nomagic]
predicate nonFrameworkFile(File f) { not exists(FrameworkLibraryInstance fl | fl.getFile() = f) }
