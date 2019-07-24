import python


bindingset[name]
private predicate legalShortName(string name) {
    name.regexpMatch("(\\p{L}|_)(\\p{L}|\\d|_)*")
}

/** Holds if `f` is potentially a source package.
 * Does it have an __init__.py file (or --respect-init=False for Python 2) and is it within the source archive?
 */
private predicate isPotentialSourcePackage(Folder f) {
    f.getRelativePath() != "" and
    (
        exists(f.getFile("__init__.py"))
        or
        py_flags_versioned("options.respect_init", "False", _) and major_version() = 2
    )
}

private string moduleNameFromBase(Container file) {
    file instanceof Folder and result = file.getBaseName()
    or
    file instanceof File and result = file.getStem()
}

string moduleNameFromFile(Container file) {
    exists(string basename |
        basename = moduleNameFromBase(file) and
        legalShortName(basename)
        |
        result = moduleNameFromFile(file.getParent()) + "." + basename
        or
        isPotentialSourcePackage(file) and result = file.getStem() and
        (not isPotentialSourcePackage(file.getParent()) or not legalShortName(file.getParent().getBaseName()))
        or
        result = file.getStem() and file.getParent() = file.getImportRoot()
        or
        result = file.getStem() and isStubRoot(file.getParent())
    )
}

private predicate isStubRoot(Folder f) {
    not f.getParent*().isImportRoot() and
    f.getAbsolutePath().matches("%/data/python/stubs")
}


/** Holds if the Container `c` should be the preferred file or folder for
 * the given name when performing imports.
 * Trivially true for any container if it is the only one with its name.
 * However, if there are several modules with the same name, then
 * this is the module most likely to be imported under that name.
 */
predicate isPreferredModuleForName(Container c, string name) {
    exists(int p |
        p = min(int x | x = priorityForName(_, name)) and
        p = priorityForName(c, name)
    )
}

private int priorityForName(Container c, string name) {
    name = moduleNameFromFile(c) and
    (
        // In the source
        exists(c.getRelativePath()) and result = -1
        or
        // On an import path
        exists(c.getImportRoot(result))
        or
        // Otherwise
        result = 10000
    )
}
