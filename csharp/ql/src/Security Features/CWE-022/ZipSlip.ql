/**
 * @name Potential ZipSlip vulnerability 
 * @description When extracting files from an archive, don't add archive item's path to the target file system path. Archive path can be relative and can lead to 
 * file system access outside of the expected file system target path, leading to malicious config changes and remote code execution via lay-and-wait technique 
 * @kind problem
 * @id cs/zipslip
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import csharp

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


from ZipSlipTaintTrackingConfiguration zipTaintTracking, DataFlow::Node source, DataFlow::Node sink
where zipTaintTracking.hasFlow(source, sink)
select sink, "Make sure to sanitize relative archive item path before creating path for file extraction if the source of $@ is untrusted", source, "zip archive"
