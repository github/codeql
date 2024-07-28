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
      // A call to os.FileInfo.Name
      exists(Method m | m.implements("io/fs", "FileInfo", "Name") |
        m = this.(DataFlow::CallNode).getTarget()
      )
    }
  }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink instanceof SharedXss::Sink { }
}
