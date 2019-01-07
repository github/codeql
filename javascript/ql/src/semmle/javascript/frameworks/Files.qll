/**
 * Provides classes for working with file system libraries.
 */

import javascript

/**
 * A file name from the `walk-sync` library.
 */
private class WalkSyncFileNameSource extends FileNameSource {
  WalkSyncFileNameSource() {
    // `require('walkSync')()`
    this = DataFlow::moduleImport("walkSync").getACall()
  }
}

/**
 * A file name or an array of file names from the `walk` library.
 */
private class WalkFileNameSource extends FileNameSource {
  WalkFileNameSource() {
    // `stats.name` in `require('walk').walk(_).on(_,  (_, stats) => stats.name)`
    exists(DataFlow::FunctionNode callback |
      callback = DataFlow::moduleMember("walk", "walk")
            .getACall()
            .getAMethodCall("on")
            .getCallback(1)
    |
      this = callback.getParameter(1).getAPropertyRead("name")
    )
  }
}

/**
 * A file name or an array of file names from the `glob` library.
 */
private class GlobFileNameSource extends FileNameSource {
  GlobFileNameSource() {
    exists(string moduleName | moduleName = "glob" |
      // `require('glob').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      // `name` in `require('glob')(_, (e, name) => ...)`
      this = DataFlow::moduleImport(moduleName).getACall().getCallback([1 .. 2]).getParameter(1)
      or
      exists(DataFlow::NewNode instance |
        instance = DataFlow::moduleMember(moduleName, "Glob").getAnInstantiation()
      |
        // `name` in `new require('glob').Glob(_, (e, name) => ...)`
        this = instance.getCallback([1 .. 2]).getParameter(1)
        or
        // `new require('glob').Glob(_).found`
        this = instance.getAPropertyRead("found")
      )
    )
  }
}

/**
 * A file name or an array of file names from the `globby` library.
 */
private class GlobbyFileNameSource extends FileNameSource {
  GlobbyFileNameSource() {
    exists(string moduleName | moduleName = "globby" |
      // `require('globby').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      // `files` in `require('globby')(_).then(files => ...)`
      this = DataFlow::moduleImport(moduleName)
            .getACall()
            .getAMethodCall("then")
            .getCallback(0)
            .getParameter(0)
    )
  }
}

/**
 * A file name or an array of file names from the `fast-glob` library.
 */
private class FastGlobFileNameSource extends FileNameSource {
  FastGlobFileNameSource() {
    exists(string moduleName | moduleName = "fast-glob" |
      // `require('fast-glob').sync(_)`
      this = DataFlow::moduleMember(moduleName, "sync").getACall()
      or
      exists(DataFlow::SourceNode f |
        f = DataFlow::moduleImport(moduleName)
        or
        f = DataFlow::moduleMember(moduleName, "async")
      |
        // `files` in `require('fast-glob')(_).then(files => ...)` and
        // `files` in `require('fast-glob').async(_).then(files => ...)`
        this = f.getACall().getAMethodCall("then").getCallback(0).getParameter(0)
      )
      or
      // `file` in `require('fast-glob').stream(_).on(_,  file => ...)`
      this = DataFlow::moduleMember(moduleName, "stream")
            .getACall()
            .getAMethodCall("on")
            .getCallback(1)
            .getParameter(0)
    )
  }
}
