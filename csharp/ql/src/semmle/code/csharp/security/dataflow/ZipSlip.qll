/**
 * Provides a taint-tracking configuration for reasoning about unsafe zip extraction.
 */
import csharp

module ZipSlip {
  // access to full name of the archive item
  Expr archiveFullName(PropertyAccess pa) {
    pa.getTarget().getDeclaringType().hasQualifiedName("System.IO.Compression.ZipArchiveEntry")
    and pa.getTarget().getName() = "FullName"
    and result = pa
  }

  // argument to extract to file extension method
  Expr compressionExtractToFileArgument(MethodCall mc) {
    mc.getTarget().hasQualifiedName("System.IO.Compression.ZipFileExtensions", "ExtractToFile")
    and result = mc.getArgumentForName("destinationFileName")
  }

  // File Stream created from tainted file name through File.Open/File.Create
  Expr fileOpenArgument(MethodCall mc) {
    (mc.getTarget().hasQualifiedName("System.IO.File", "Open") or
     mc.getTarget().hasQualifiedName("System.IO.File", "OpenWrite") or
     mc.getTarget().hasQualifiedName("System.IO.File", "Create"))
     and result = mc.getArgumentForName("path")
  }

  // File Stream created from tainted file name passed directly to the constructor
  Expr streamConstructorArgument(ObjectCreation oc) {
    oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.FileStream")
    and result = oc.getArgumentForName("path")
  }

  // constructor to FileInfo can take tainted file name and subsequently be used to open file stream
  Expr fileInfoConstructorArgument(ObjectCreation oc) {
    oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.FileInfo")
    and result = oc.getArgumentForName("fileName")
  }
  // extracting just file name, not the full path
  Expr fileNameExtraction(MethodCall mc) {
    mc.getTarget().hasQualifiedName("System.IO.Path", "GetFileName")
    and result = mc.getAnArgument()
  }

  // Checks the string for relative path, or checks the destination folder for whitelisted/target path, etc.
  Expr stringCheck(MethodCall mc) {
    (mc.getTarget().hasQualifiedName("System.String", "StartsWith") or
     mc.getTarget().hasQualifiedName("System.String", "Substring"))
    and result = mc.getQualifier()
  }

  // Taint tracking configuration for ZipSlip
  class ZipSlipTaintTrackingConfiguration extends TaintTracking::Configuration {
    ZipSlipTaintTrackingConfiguration() {
      this = "ZipSlipTaintTracking"
    }

    override predicate isSource(DataFlow::Node source) {
      exists(PropertyAccess pa |
      source.asExpr() = archiveFullName(pa))
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(MethodCall mc |
      sink.asExpr() = compressionExtractToFileArgument(mc) or
      sink.asExpr() = fileOpenArgument(mc))
      or
      exists(ObjectCreation oc |
      sink.asExpr() = streamConstructorArgument(oc) or
      sink.asExpr() = fileInfoConstructorArgument(oc))
    }

    override predicate isSanitizer(DataFlow::Node node) {
      exists(MethodCall mc |
      node.asExpr() = fileNameExtraction(mc) or
      node.asExpr() = stringCheck(mc))
    }
  }
}