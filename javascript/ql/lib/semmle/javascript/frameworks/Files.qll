/**
 * Provides classes for working with file system libraries.
 */

import javascript

/**
 * A file name from the `walk-sync` library.
 */
private class WalkSyncFileNameSource extends FileNameSource {
  WalkSyncFileNameSource() {
    // `require('walk-sync')()`
    this = DataFlow::moduleImport("walk-sync").getACall()
  }
}

/**
 * A file name or an array of file names from the `walk` library.
 */
private class WalkFileNameSource extends FileNameSource {
  WalkFileNameSource() {
    // `stats.name` in `require('walk').walk(_).on(_,  (_, stats) => stats.name)`
    exists(DataFlow::FunctionNode callback |
      callback =
        DataFlow::moduleMember("walk", "walk")
            .getACall()
            .getAMethodCall(EventEmitter::on())
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
 * Gets a file name or an array of file names from the `globby` library.
 */
private API::Node globbyFileNameSource() {
  // `require('globby').sync(_)`
  result = API::moduleImport("globby").getMember("sync").getReturn()
  or
  // `files` in `require('globby')(_).then(files => ...)`
  result = API::moduleImport("globby").getReturn().getPromised()
}

/**
 * A file name or an array of file names from the `globby` library.
 */
private class GlobbyFileNameSource extends FileNameSource {
  GlobbyFileNameSource() { this = globbyFileNameSource().getAnImmediateUse() }
}

/** Gets a file name or an array of file names from the `fast-glob` library. */
private API::Node fastGlobFileName() {
  // `require('fast-glob').sync(_)
  result = API::moduleImport("fast-glob").getMember("sync").getReturn()
  or
  exists(API::Node base |
    base = [API::moduleImport("fast-glob"), API::moduleImport("fast-glob").getMember("async")]
  |
    result = base.getReturn().getPromised()
  )
  or
  result =
    API::moduleImport("fast-glob")
        .getMember("stream")
        .getReturn()
        .getMember(EventEmitter::on())
        .getParameter(1)
        .getParameter(0)
}

/**
 * A file name or an array of file names from the `fast-glob` library.
 */
private class FastGlobFileNameSource extends FileNameSource {
  FastGlobFileNameSource() { this = fastGlobFileName().getAnImmediateUse() }
}
