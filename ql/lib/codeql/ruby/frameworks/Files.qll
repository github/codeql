/**
 * Provides classes for working with file system libraries.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/** A permissions argument of a call to a File/FileUtils method that may modify file permissions */
/*
class PermissionArgument extends DataFlow::Node {
  private DataFlow::CallNode call;

  PermissionArgument() {
    exists(string methodName |
      call = API::getTopLevelMember(["File", "FileUtils"]).getAMethodCall(methodName)
    |
      methodName in ["chmod", "chmod_R", "lchmod"] and this = call.getArgument(0)
      or
      methodName = "mkfifo" and this = call.getArgument(1)
      or
      methodName in ["new", "open"] and this = call.getArgument(2)
      or
      methodName in ["install", "makedirs", "mkdir", "mkdir_p", "mkpath"] and
      this = call.getKeywordArgument("mode")
      // TODO: defaults for optional args? This may depend on the umask
    )
  }

  MethodCall getCall() { result = call.asExpr().getExpr() }
}
*/


class StdLibFileNameSource extends FileNameSource {
  StdLibFileNameSource() {
    this = API::getTopLevelMember("File").getAMethodCall(["join", "path", "to_path", "readlink"])

  }
}

/**
 * Classes and predicates for modelling the `File` module from the standard
 * library.
 */
private module File {

  class FileModuleReader extends FileSystemReadAccess, DataFlow::CallNode {
    FileModuleReader() {
      this = API::getTopLevelMember("File").getAMethodCall(["new", "open"])
    }
  }

}