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
  or
  ext = "d.ts" and result = 10
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
    result = resolveMainModule(dir.(NpmPackage).getPackageJson(), priority, ".") or
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
private string getStem(string name) {
  // everything before the last dot
  result = name.regexpCapture("(.+?)(?:\\.([^.]+))?", 1)
  or
  // everything before the first dot
  result = name.regexpCapture("^([^.]*)\\..*$", 1)
}

/**
 * Gets a file that a main module from `pkg` exported as `mainPath` with the given `priority`.
 * `mainPath` is "." if it's the main module of the package.
 */
private File resolveMainPath(PackageJson pkg, string mainPath, int priority) {
  exists(PathExpr main | main = MainModulePath::of(pkg, mainPath) |
    result = main.resolve() and priority = 0
    or
    result = tryExtensions(main.resolve(), "index", priority)
    or
    not main.resolve() instanceof File and
    exists(int n | n = main.getNumComponent() |
      result = tryExtensions(main.resolveUpTo(n - 1), getStem(main.getComponent(n - 1)), priority)
    )
    or
    // assuming the files get moved from one dir to another during compilation:
    not exists(main.resolve()) and // didn't resolve
    count(int i, string comp | comp = main.getComponent(i) and not comp = "." | i) = 2 and // is down one folder
    exists(Folder subFolder | subFolder = pkg.getFile().getParentContainer().getAFolder() |
      // is in one folder below the package.json, and has the right basename
      result =
        tryExtensions(subFolder, getStem(main.getComponent(main.getNumComponent() - 1)),
          priority - 999) // very high priority, to make sure everything else is tried first
    )
  )
  or
  not exists(MainModulePath::of(pkg, _)) and
  exists(Folder parent |
    parent = pkg.getFile().getParentContainer() and
    result = tryExtensions(parent, "index", priority) and
    mainPath = "."
  )
}

/**
 * Gets the main module described by `pkg` with the given `priority`.
 */
File resolveMainModule(PackageJson pkg, int priority, string exportPath) {
  result = resolveMainPath(pkg, exportPath, priority)
  or
  exportPath = "." and
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
  exportPath = "." and
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
 * A JSON string in a `package.json` file specifying the path of one of the exported
 * modules of the package.
 */
class MainModulePath extends PathExpr, @json_string {
  PackageJson pkg;

  MainModulePath() {
    this = pkg.getPropValue(["main", "module"])
    or
    this = getAPartOfExportsSection(pkg)
  }

  /** Gets the `package.json` file in which this path occurs. */
  PackageJson getPackageJson() { result = pkg }

  /** Gets the relative path under which this is exported, usually starting with a `.`. */
  string getRelativePath() {
    result = getExportRelativePath(this)
    or
    not exists(getExportRelativePath(this)) and result = "."
  }

  override string getValue() { result = this.(JsonString).getValue() }

  override Folder getAdditionalSearchRoot(int priority) {
    priority = 0 and
    result = pkg.getFile().getParentContainer()
  }
}

private JsonValue getAPartOfExportsSection(PackageJson pkg) {
  result = pkg.getPropValue("exports")
  or
  result = getAPartOfExportsSection(pkg).getPropValue(_)
}

/** Gets the text of one of the conditions or paths enclosing the given `part` of an `exports` section. */
private string getAnEnclosingExportProperty(JsonValue part) {
  exists(JsonObject parent, string prop |
    parent = getAPartOfExportsSection(_) and
    part = parent.getPropValue(prop)
  |
    result = prop
    or
    result = getAnEnclosingExportProperty(parent)
  )
}

private string getExportRelativePath(JsonValue part) {
  result = getAnEnclosingExportProperty(part) and
  result.matches(".%")
}

module MainModulePath {
  /** Gets the path to the main entry point of `pkg`. */
  MainModulePath of(PackageJson pkg) { result = of(pkg, ".") }

  /** Gets the path to the file exported from `pkg` as `relativePath`. */
  MainModulePath of(PackageJson pkg, string relativePath) {
    result.getPackageJson() = pkg and
    result.getRelativePath() = relativePath
  }
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
    not exists(MainModulePath::of(pkg, _))
  }

  /** Gets the `package.json` file in which this path occurs. */
  PackageJson getPackageJson() { result = pkg }

  override string getValue() { result = this.(JsonString).getValue() }

  override Folder getAdditionalSearchRoot(int priority) {
    priority = 0 and
    result = pkg.getFile().getParentContainer()
  }
}

private module FilesPath {
  FilesPath of(PackageJson pkg) { result.getPackageJson() = pkg }
}

/**
 * A JSON string in a `package.json` file specifying the path of the
 * TypeScript typings entry point.
 */
class TypingsModulePathString extends PathString {
  PackageJson pkg;

  TypingsModulePathString() {
    this = pkg.getTypings()
    or
    not exists(pkg.getTypings()) and
    this = pkg.getMain().regexpReplaceAll("\\.[mc]?js$", ".d.ts")
  }

  /** Gets the `package.json` file containing this path. */
  PackageJson getPackageJson() { result = pkg }

  override Folder getARootFolder() { result = pkg.getFile().getParentContainer() }
}

/** Companion module to the `TypingsModulePathString` class. */
module TypingsModulePathString {
  /** Get the typings path for the given `package.json` file. */
  TypingsModulePathString of(PackageJson pkg) { result.getPackageJson() = pkg }
}
