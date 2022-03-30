/**
 * INTERNAL: Do not use directly.
 *
 * Provides predicates for modeling Node.js module resolution.
 */

import javascript

/**
 * Gets the priority with which a given file extension should be found by module resolution.
 * Extensions with a lower numeric priority value are preferred.
 *
 * File types that compile to `js` are preferred over the `js` file type itself.
 * This is to ensure we find the original source file in case the compiled output is also present.
 */
int getFileExtensionPriority(string ext) {
  ext = "tsx" and result = 0
  or
  ext = "ts" and result = 1
  or
  ext = "jsx" and result = 2
  or
  ext = "es6" and result = 3
  or
  ext = "es" and result = 4
  or
  ext = "mjs" and result = 5
  or
  ext = "cjs" and result = 6
  or
  ext = "js" and result = 7
  or
  ext = "json" and result = 8
  or
  ext = "node" and result = 9
}

int prioritiesPerCandidate() { result = 3 * (numberOfExtensions() + 1) }

int numberOfExtensions() { result = count(getFileExtensionPriority(_)) }

/**
 * Gets the resolution target with the given `priority` of `req`
 * when resolved from the root with priority `rootPriority`.
 */
File loadAsFile(Require req, int rootPriority, int priority) {
  exists(PathExpr path | path = req.getImportedPath() |
    result = path.resolve(rootPriority) and priority = 0
    or
    exists(Folder encl | encl = path.resolveUpTo(path.getNumComponent() - 1, rootPriority) |
      result = tryExtensions(encl, path.getBaseName(), priority - 1)
    )
  )
}

/**
 * Gets the default main module of the folder that is the resolution target
 * with the given `priority` of `req` when resolved from the root with
 * priority `rootPriority`.
 */
File loadAsDirectory(Require req, int rootPriority, int priority) {
  exists(Folder dir | dir = req.getImportedPath().resolve(rootPriority) |
    result = resolveMainModule(dir.(NpmPackage).getPackageJson(), priority) or
    result = tryExtensions(dir, "index", priority - (numberOfExtensions() + 1))
  )
}

/**
 * Gets a file in folder `dir` whose name is of the form `basename.extension`,
 * where `extension` has the given `priority`.
 *
 * This may resolve to an `mjs` file even though `require` will never find those files at runtime.
 * We do this to handle the case where an `mjs` file is transpiled to `js`, and we want to find the
 * original source file.
 */
bindingset[basename]
File tryExtensions(Folder dir, string basename, int priority) {
  exists(string ext | result = dir.getFile(basename, ext) |
    priority = getFileExtensionPriority(ext)
  )
}

/**
 * Gets `name` without a file extension.
 * Or `name`, if `name` has no file extension.
 */
bindingset[name]
private string getStem(string name) { result = name.regexpCapture("(.+?)(?:\\.([^.]+))?", 1) }

/**
 * Gets the main module described by `pkg` with the given `priority`.
 */
File resolveMainModule(PackageJson pkg, int priority) {
  exists(PathExpr main | main = MainModulePath::of(pkg) |
    result = main.resolve() and priority = 0
    or
    result = tryExtensions(main.resolve(), "index", priority)
    or
    not exists(main.resolve()) and
    exists(int n | n = main.getNumComponent() |
      result = tryExtensions(main.resolveUpTo(n - 1), getStem(main.getComponent(n - 1)), priority)
    )
  )
  or
  exists(Folder folder, Folder child |
    child = folder or
    child = folder.getChildContainer(getASrcFolderName()) or
    child =
      folder.getChildContainer(getASrcFolderName()).(Folder).getChildContainer(getASrcFolderName())
  |
    folder = pkg.getFile().getParentContainer() and
    result = tryExtensions(child, "index", priority - prioritiesPerCandidate())
  )
  or
  // if there is no main module, then we look for files that are explicitly included in the published package.
  exists(PathExpr file |
    // `FilesPath` only exists if there is no main module for a given package.
    file = FilesPath::of(pkg) and priority = 100 // fixing the priority, because there might be multiple files in the package.
  |
    result = file.resolve()
    or
    result = min(int i, File f | f = tryExtensions(file.resolve(), "index", i) | f order by i)
    or
    // resolve "file.js" to e.g. "file.ts".
    not exists(file.resolve()) and
    exists(int n | n = file.getNumComponent() |
      result =
        min(int i, File res |
          res = tryExtensions(file.resolveUpTo(n - 1), getStem(file.getComponent(n - 1)), i)
        |
          res order by i
        )
    )
  )
}

/**
 * Gets a folder name that is a common source folder name.
 */
private string getASrcFolderName() { result = ["ts", "js", "src", "lib"] }

/**
 * A JSON string in a `package.json` file specifying the path of the main
 * module of the package.
 */
class MainModulePath extends PathExpr, @json_string {
  PackageJson pkg;

  MainModulePath() { this = pkg.getPropValue(["main", "module"]) }

  /** Gets the `package.json` file in which this path occurs. */
  PackageJson getPackageJson() { result = pkg }

  /** DEPRECATED: Alias for getPackageJson */
  deprecated PackageJSON getPackageJSON() { result = getPackageJson() }

  override string getValue() { result = this.(JsonString).getValue() }

  override Folder getAdditionalSearchRoot(int priority) {
    priority = 0 and
    result = pkg.getFile().getParentContainer()
  }
}

module MainModulePath {
  MainModulePath of(PackageJson pkg) { result.getPackageJson() = pkg }
}

/**
 * A JSON string in a `package.json` file specifying a file that should be included in the published package.
 * These files are often imported directly from a client when a "main" module is not specified.
 * For performance reasons this only exists if there is no "main" field in the `package.json` file.
 */
private class FilesPath extends PathExpr, @json_string {
  PackageJson pkg;

  FilesPath() {
    this = pkg.getPropValue("files").(JsonArray).getElementValue(_) and
    not exists(MainModulePath::of(pkg))
  }

  /** Gets the `package.json` file in which this path occurs. */
  PackageJson getPackageJson() { result = pkg }

  /** DEPRECATED: Alias for getPackageJson */
  deprecated PackageJSON getPackageJSON() { result = getPackageJson() }

  override string getValue() { result = this.(JsonString).getValue() }

  override Folder getAdditionalSearchRoot(int priority) {
    priority = 0 and
    result = pkg.getFile().getParentContainer()
  }
}

private module FilesPath {
  FilesPath of(PackageJson pkg) { result.getPackageJson() = pkg }
}
