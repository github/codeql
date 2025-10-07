/**
 * Provides predicates for use in `Folder::ResolveSig` in order to resolve
 * paths using JavaScript semantics.
 */

private import javascript
private import semmle.javascript.TSConfig

/**
 * Gets a folder name that is a common source folder name.
 */
string getASrcFolderName() { result = ["ts", "js", "src", "lib"] }

/**
 * Gets a folder name that is a common build output folder name.
 */
string getABuildOutputFolderName() { result = ["dist", "build", "out", "lib"] }

/**
 * Provides predicates for use in a `Folder::ResolveSig` in order to resolve
 * paths using JavaScript semantics.
 *
 * This accounts for two things:
 * - automatic file extensions (e.g `./foo` may resolve to `./foo.js`)
 * - mapping compiled-generated files back to their original source files
 */
module JSPaths {
  private Container getAnAdditionalChildFromBuildMapping(Container base, string name) {
    // When importing a .js file, map to the original file that compiles to the .js file.
    exists(string stem |
      result = base.(Folder).getJavaScriptFileOrTypings(stem) and
      name = stem + ".js"
    )
    or
    // Redirect './bar' to 'foo' given a tsconfig like:
    //
    //   { include: ["foo"], compilerOptions: { outDir: "./bar" }}
    //
    exists(TSConfig tsconfig |
      name =
        tsconfig.getCompilerOptions().getPropStringValue("outDir").regexpReplaceAll("^\\./", "") and
      base = tsconfig.getFolder() and
      result = tsconfig.getEffectiveRootDir()
    )
  }

  /**
   * Gets an additional child of `base` to include when resolving JS paths.
   */
  pragma[nomagic]
  Container getAnAdditionalChild(Container base, string name) {
    // Automatically fill in file extensions
    result = base.(Folder).getJavaScriptFileOrTypings(name)
    or
    result = getAnAdditionalChildFromBuildMapping(base, name)
    or
    // Heuristic version of the above based on commonly used source and build folder names
    not exists(getAnAdditionalChildFromBuildMapping(base, name)) and
    exists(Folder folder | base = folder |
      folder = any(PackageJson pkg).getFolder() and
      name = getABuildOutputFolderName() and
      not exists(folder.getJavaScriptFileOrTypings(name)) and
      (
        result = folder.getChildContainer(getASrcFolderName())
        or
        result = folder
      )
    )
  }
}
