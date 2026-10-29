/**
 * Provides classes and predicates used by the Stored XSS query.
 */

import go
import Xss

/** Provides classes and predicates used by the stored XSS query. */
module StoredXss {
  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for stored XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for stored XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A shared XSS sanitizer as a sanitizer for stored XSS. */
  private class SharedXssSanitizer extends Sanitizer instanceof SharedXss::Sanitizer { }

  /** A database query result, considered as a flow source for stored XSS. */
  private class DatabaseQueryAsSource extends Source {
    DatabaseQueryAsSource() { this = any(SQL::Query q).getAResult() }
  }

  /** A file name, considered as a source for a stored XSS attack. */
  class FileNameSource extends Source {
    FileNameSource() {
      // the second parameter to a filepath.Walk function
      exists(DataFlow::FunctionNode f, Function walkFn | this = f.getParameter(0) |
        walkFn.hasQualifiedName("path/filepath", ["Walk", "WalkDir"]) and
        walkFn.getACall().getArgument(1) = f.getASuccessor*()
      )
      or
      // The return value of a call to `os.DirEntry.Name`, `os.FileInfo.Name`
      // or `os.File.ReadDirNames`.
      exists(DataFlow::CallNode cn, Method m | m = cn.getTarget() and this = cn.getResult(0) |
        m.implements("io/fs", ["DirEntry", "FileInfo"], "Name") or
        m.hasQualifiedName("os", "File", "ReadDirNames")
      )
    }
  }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink instanceof SharedXss::Sink { }
}
