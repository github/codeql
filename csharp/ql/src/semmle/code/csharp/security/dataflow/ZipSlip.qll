/**
 * Provides a taint tracking configuration for reasoning about unsafe zip extraction.
 */
import csharp

module ZipSlip {
  /**
   * A data flow source for unsafe zip extraction.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe zip extraction.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for unsafe zip extraction.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /** A taint tracking configuration for Zip Slip */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() {
      this = "ZipSlipTaintTracking"
    }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      node instanceof Sanitizer
    }
  }

  /** An access to the `FullName` property of a `ZipArchiveEntry`. */
  class ArchiveFullNameSource extends Source {
    ArchiveFullNameSource() {
      exists(PropertyAccess pa |
        this.asExpr() = pa |
        pa.getTarget().getDeclaringType().hasQualifiedName("System.IO.Compression.ZipArchiveEntry") and
        pa.getTarget().getName() = "FullName" 
      )
    }
  }

  /** An argument to the `ExtractToFile` extension method. */
  class ExtractToFileArgSink extends Sink {
    ExtractToFileArgSink() {
      exists(MethodCall mc |
        mc.getTarget().hasQualifiedName("System.IO.Compression.ZipFileExtensions", "ExtractToFile") and
        this.asExpr() = mc.getArgumentForName("destinationFileName")
      )
    }
  }

  /** A path argument to a `File.Open`, `File.OpenWrite`, or `File.Create` method call. */
  class FileOpenArgSink extends Sink {
    FileOpenArgSink() {
      exists(MethodCall mc |
        mc.getTarget().hasQualifiedName("System.IO.File", "Open") or
        mc.getTarget().hasQualifiedName("System.IO.File", "OpenWrite") or
        mc.getTarget().hasQualifiedName("System.IO.File", "Create") |
        this.asExpr() = mc.getArgumentForName("path")
      )
    }
  }

  /** A path argument to a call to the `FileStream` constructor. */
  class FileStreamArgSink extends Sink {
    FileStreamArgSink() {
      exists(ObjectCreation oc |
        oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.FileStream") |
        this.asExpr() = oc.getArgumentForName("path")
      )
    }
  }

  /**
   * A path argument to a call to the `FileStream` constructor.
   *
   * This constructor can accept a tainted file name and subsequently be used to open a file stream.
   */
  class FileInfoArgSink extends Sink {
    FileInfoArgSink() {
      exists(ObjectCreation oc |
        oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.FileInfo") |
        this.asExpr() = oc.getArgumentForName("fileName")
      )
    }
  }

  /**
   * An argument to `GetFileName`.
   *
   * This is considered a sanitizer because it extracts just the file name, not the full path.
   */
  class GetFileNameSanitizer extends Sanitizer {
    GetFileNameSanitizer() {
      exists(MethodCall mc |
        mc.getTarget().hasQualifiedName("System.IO.Path", "GetFileName") |
        this.asExpr() = mc.getAnArgument()
      )
    }
  }

  /**
   * A qualifier in a call to `StartsWith` or `Substring` string method.
   *
   * A call to a String method such as `StartsWith` or `Substring` can indicate a check for a
   * relative path, or a check against the destination folder for whitelisted/target path, etc.
   */
  class StringCheckSanitizer extends Sanitizer {
    StringCheckSanitizer() {
      exists(MethodCall mc |
        mc.getTarget().hasQualifiedName("System.String", "StartsWith") or
        mc.getTarget().hasQualifiedName("System.String", "Substring") |
        this.asExpr() = mc.getQualifier()
      )
    }
  }
}