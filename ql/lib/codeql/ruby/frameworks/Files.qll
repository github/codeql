/**
 * Provides classes for working with file system libraries.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * Classes and predicates for modelling the `File` module from the standard
 * library.
 */
private module File {
  private class FileModuleReader extends FileSystemReadAccess::Range, DataFlow::CallNode {
    FileModuleReader() { this = API::getTopLevelMember("File").getAMethodCall(["new", "open"]) }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

    override DataFlow::Node getADataNode() { result = this }
  }

  private class FileModuleFilenameSource extends FileNameSource {
    FileModuleFilenameSource() {
      // Class methods
      this =
        API::getTopLevelMember("File")
            .getAMethodCall([
                "absolute_path", "basename", "expand_path", "join", "path", "readlink",
                "realdirpath", "realpath"
              ])
    }
  }

  private class FileModulePermissionModification extends FileSystemPermissionModification::Range,
    DataFlow::CallNode {
    private DataFlow::Node permissionArg;

    FileModulePermissionModification() {
      exists(string methodName | this = API::getTopLevelMember("File").getAMethodCall(methodName) |
        methodName in ["chmod", "lchmod"] and permissionArg = this.getArgument(0)
        or
        methodName = "mkfifo" and permissionArg = this.getArgument(1)
        or
        methodName in ["new", "open"] and permissionArg = this.getArgument(2)
        // TODO: defaults for optional args? This may depend on the umask
      )
    }

    override DataFlow::Node getAPermissionNode() { result = permissionArg }
  }
}

private module FileUtils {
  private class FileUtilsFilenameSource extends FileNameSource {
    FileUtilsFilenameSource() {
      // Note that many methods in FileUtils accept a `noop` option that will
      // perform a dry run of the command. This means that, for instance, `rm`
      // and similar methods may not actually delete/unlink a file.
      this =
        API::getTopLevelMember("FileUtils")
            .getAMethodCall([
                "chmod", "chmod_R", "chown", "chown_R", "getwd", "makedirs", "mkdir", "mkdir_p",
                "mkpath", "remove", "remove_dir", "remove_entry", "rm", "rm_f", "rm_r", "rm_rf",
                "rmdir", "rmtree", "safe_unlink", "touch"
              ])
    }
  }

  private class FileUtilsPermissionModification extends FileSystemPermissionModification::Range,
    DataFlow::CallNode {
    private DataFlow::Node permissionArg;

    FileUtilsPermissionModification() {
      exists(string methodName |
        this = API::getTopLevelMember("FileUtils").getAMethodCall(methodName)
      |
        methodName in ["chmod", "chmod_R"] and permissionArg = this.getArgument(0)
        or
        methodName in ["install", "makedirs", "mkdir", "mkdir_p", "mkpath"] and
        permissionArg = this.getKeywordArgument("mode")
        // TODO: defaults for optional args? This may depend on the umask
      )
    }

    override DataFlow::Node getAPermissionNode() { result = permissionArg }
  }
}

private module IO { }
