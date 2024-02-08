/**
 * Provides a taint tracking configuration for reasoning about unsafe zip extraction.
 */

 import csharp
 private import semmle.code.csharp.controlflow.Guards
 private import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph
 
 private abstract class AbstractSanitizerMethod extends Method { }
 
 class MethodSystemStringStartsWith extends AbstractSanitizerMethod {
   MethodSystemStringStartsWith() { this.getQualifiedName() = "System.String.StartsWith" }
 }
 
 private abstract class UnsanitizedPathCombiner extends Expr { }
 
 class PathCombinerViaMethodCall extends UnsanitizedPathCombiner {
   PathCombinerViaMethodCall() {
     this.(MethodCall).getTarget().hasQualifiedName("System.IO.Path", "Combine")
   }
 }
 
 class PathCombinerViaStringInterpolation extends UnsanitizedPathCombiner {
   PathCombinerViaStringInterpolation() { exists(InterpolatedStringExpr e | this = e) }
 }
 
 class PathCombinerViaStringConcatenation extends UnsanitizedPathCombiner {
   PathCombinerViaStringConcatenation() { exists(AddExpr e | this = e) }
 }
 
 class MethodCallGetFullPath extends MethodCall {
   MethodCallGetFullPath() { this.getTarget().hasQualifiedName("System.IO.Path", "GetFullPath") }
 }
 
 /**
  * A taint tracking module for GetFullPath to String.StartsWith.
  */
 module GetFullPathToQualifierTT = TaintTracking::Global<GetFullPathToQualifierTaintTrackingConfiguration>;
 
 private module GetFullPathToQualifierTaintTrackingConfiguration implements DataFlow::ConfigSig {
   predicate isSource(DataFlow::Node node) {
     exists(MethodCallGetFullPath mcGetFullPath | node = DataFlow::exprNode(mcGetFullPath))
   }
   predicate isSink(DataFlow::Node node) {
     exists(MethodCall mc |
       mc.getTarget() instanceof MethodSystemStringStartsWith and
       node.asExpr() = mc.getQualifier()
     )
   }
 }
 
 /**
  * DEPRECATED: Use `ZipSlip` instead.
  *
  * A taint tracking configuration for Zip Slip.
  */
 deprecated class TaintTrackingConfiguration extends TaintTracking::Configuration {
   TaintTrackingConfiguration() { this = "ZipSlipTaintTracking" }
 
   override predicate isSource(DataFlow::Node source) { source instanceof Source }
 
   override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
 
   override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
 }
 
 /**
  * A taint tracking configuration for Zip Slip.
  */
 private module ZipSlipConfig implements DataFlow::ConfigSig {
   predicate isSource(DataFlow::Node source) { source instanceof Source }
 
   predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
 
   predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
 }
 
 /**
  * A taint tracking module for Zip Slip.
  */
 module ZipSlip = TaintTracking::Global<ZipSlipConfig>;
 
 /** An access to the `FullName` property of a `ZipArchiveEntry`. */
 class ArchiveFullNameSource extends Source {
   ArchiveFullNameSource() {
     exists(PropertyAccess pa | this.asExpr() = pa |
       pa.getTarget().getDeclaringType().hasQualifiedName("System.IO.Compression", "ZipArchiveEntry") and
       pa.getTarget().getName() = "FullName"
     )
   }
 }
 
 
 /**
  * A taint tracking module for String combining to GetFullPath.
  */
 module PathCombinerToGetFullPathTT = TaintTracking::Global<PathCombinerToGetFullPathTaintTrackingConfiguration>;
 
 /**
  * PathCombinerToGetFullPathTaintTrackingConfiguration - A Taint Tracking configuration that tracks
  * a File path combining expression (Such as string concatenation, Path.Combine, or string interpolation),
  * to a Path.GetFullPath method call's argument.
  * 
  * We need this because we need to find a safe sequence of operations wherein
  *  - An absolute path is created (uncanonicalized)
  *  - The Path is canonicalized
  * 
  * If the operations are in the opposite order, the resultant may still contain path traversal characters,
  * as you cannot fully resolve a relative path. So we must ascertain that they are conducted in this sequence.
  */
 private module PathCombinerToGetFullPathTaintTrackingConfiguration implements DataFlow::ConfigSig {
   /**
    * We are looking for the result of some Path combining operation (String concat, Path.Combine, etc.)
    */
   predicate isSource(DataFlow::Node node) {
     exists(UnsanitizedPathCombiner pathCombiner | node = DataFlow::exprNode(pathCombiner))
   }
 
   /**
    * Find the first (and only) argument of Path.GetFullPath, so we make sure that our expression
    * first goes through some path combining function, and then is canonicalized.
    */
   predicate isSink(DataFlow::Node node) {
     exists(MethodCallGetFullPath mcGetFullPath |
       node = DataFlow::exprNode(mcGetFullPath.getArgument(0))
     )
   }
 }
 
 /** Predicate to check for a safe sequence of events
  * Path.Combine THEN Path.GetFullPath is applied (with possibly arbitrary mutations)
  */
 private predicate safeCombineGetFullPathSequence(MethodCallGetFullPath mcGetFullPath, Expr q) {
   exists(UnsanitizedPathCombiner source |
     PathCombinerToGetFullPathTT::flow(DataFlow::exprNode(source), DataFlow::exprNode(mcGetFullPath.getArgument(0)))
   ) and
   GetFullPathToQualifierTT::flow(DataFlow::exprNode(mcGetFullPath), DataFlow::exprNode(q))
 }
 
 /**
 * The set of /valid/ Guards of RootSanitizerMethodCall.
 *
 *    IN CONJUNCTION with BOTH
 *      Path.Combine
 *      AND Path.GetFullPath
 *    OR
 *      There is a direct flow from Path.GetFullPath to qualifier of RootSanitizerMethodCall.
 *
 *    It is not simply enough for the qualifier of String.StartsWith
 *    to pass through Path.Combine without also passing through GetFullPath AFTER.
 */
 class RootSanitizerMethodCall extends SanitizerMethodCall {
   RootSanitizerMethodCall() {
     exists(MethodSystemStringStartsWith sm | this.getTarget() = sm) and
     exists(Expr q, AbstractValue v |
       this.getQualifier() = q and
       v.(AbstractValues::BooleanValue).getValue() = true and
       exists(MethodCallGetFullPath mcGetFullPath | safeCombineGetFullPathSequence(mcGetFullPath, q))
     )
   }
 
   override Expr getFilePathArgument() { result = this.getQualifier() }
 }
 
 /**
 * The set of Guards of RootSanitizerMethodCall that are used IN CONJUNCTION with
 *      Path.GetFullPath - it is not simply enough for the qualifier of String.StartsWith
 *      to pass through Path.Combine without also passing through GetFullPath.
 */
 class ZipSlipGuard extends Guard {
   ZipSlipGuard() { this instanceof SanitizerMethodCall }
 
   Expr getFilePathArgument() { result = this.(SanitizerMethodCall).getFilePathArgument() }
 }
 
 private abstract class SanitizerMethodCall extends MethodCall {
   SanitizerMethodCall() { this instanceof MethodCall }
 
   abstract Expr getFilePathArgument();
 }
 
 /**
  * A taint tracking module for Zip Slip Guard.
  */
 module SanitizedGuardTT = TaintTracking::Global<SanitizedGuardTaintTrackingConfiguration>;
 
 /**
  * SanitizedGuardTaintTrackingConfiguration - A Taint Tracking configuration class to trace
  * parameters of a function to calls to RootSanitizerMethodCall (String.StartsWith).
  * 
  * For example, the following function:
  *  void exampleFn(String somePath){
  *    somePath = Path.GetFullPath(somePath);
  *    ...
  *    if(somePath.startsWith("aaaaa"))
  *      ...
  *    ...
  *  }
  */
 private module SanitizedGuardTaintTrackingConfiguration implements DataFlow::ConfigSig {
   predicate isSource(DataFlow::Node source) {
     source instanceof DataFlow::ParameterNode
   }
 
   predicate isSink(DataFlow::Node sink) {
     exists(RootSanitizerMethodCall smc |
       smc.getAnArgument() = sink.asExpr() or
       smc.getQualifier() = sink.asExpr()
     )
   }
 }
 
 /**
  * An AbstractWrapperSanitizerMethod is a Method that
  *  is a suitable sanitizer for a ZipSlip path that may not have been canonicalized prior.
  *
  * If the return value of this Method correctly validates if a file path is in a valid location,
  * or is a restricted subset of that validation, then any use of this Method is as valid as the Root
  * sanitizer (Path.StartsWith).
  */
 private abstract class AbstractWrapperSanitizerMethod extends AbstractSanitizerMethod {
   
   Parameter paramFilename;
 
   AbstractWrapperSanitizerMethod() {
     this.getReturnType() instanceof BoolType and
     this.getAParameter() = paramFilename
   }
 
   Parameter paramFilePath() { result = paramFilename }
 }
 
 /**
 * A DirectWrapperSantizierMethod is a Method where
 *      The function can /only/ returns true when passes through the RootSanitizerGuard
 *
 *     bool wrapperFn(a,b){
 *       if(guard(a,b))
 *         return true
 *       ....
 *       return false
 *     }
 *
 *     bool wrapperFn(a,b){
 *       ...
 *       return guard(a,b)
 *     }
 */
 class DirectWrapperSantizierMethod extends AbstractWrapperSanitizerMethod {
 
   /**
    * To be declared a Wrapper, a function must:
    * - Be a predicate (return a boolean)
    * - Accept and use a parameter which represents a File path
    * - Contain a call to another sanitizer
    * - And can only return true if the sanitizer also returns true.
    */
   DirectWrapperSantizierMethod() {
     // For every return statement in this Method,
     forex(ReturnStmt ret | ret.getEnclosingCallable() = this |
       // The function returns false (Fails the Guard)
       ret.getExpr().(BoolLiteral).getBoolValue() = false
       or
       // It passes the guard, contraining the function argument to the Guard argument.
       exists(ZipSlipGuard g, DataFlow::Node source, DataFlow::Node sink |
         g.getEnclosingCallable() = this and
         source = DataFlow::parameterNode(paramFilename) and
         sink = DataFlow::exprNode(g.getFilePathArgument()) and
         SanitizedGuardTT::flow(source, sink) and
         (
           exists(AbstractValues::BooleanValue bv |
             // If there exists a control block that guards against misuse
             bv.getValue() = true and
             g.controlsNode(ret.getAControlFlowNode(), bv)
           )
           or
           // Or if the function returns the resultant of the guard call
           DataFlow::localFlow(DataFlow::exprNode(g), DataFlow::exprNode(ret.getExpr()))
         )
       )
     )
   }
 }
 
 /**
  * An IndirectOverloadedWrapperSanitizerMethod is a Method in which simply wraps /another/ wrapper.class
  *
  * Usually this will look like the following stanza:
  * boolean someWrapper(string s){
  *  return someWrapper(s, true);
  * }
  */
 class IndirectOverloadedWrapperSantizierMethod extends AbstractWrapperSanitizerMethod {
 
   /**
    * To be declared a Wrapper, a function must:
    * - Be a predicate (return a boolean)
    * - Accept and use a parameter which represents a File path (via delegation)
    * - Contain a call to another sanitizer (via delegation)
    * - And can only return true if the delegate sanitizer also returns true.
    */
   IndirectOverloadedWrapperSantizierMethod() {
     // For every return statement in our Method,
     forex(ReturnStmt ret | ret.getEnclosingCallable() = this |
       // The Return statement returns false OR
       ret.getExpr().(BoolLiteral).getBoolValue() = false
       or
       // The Method returns the result of calling another known-good sanitizer, connecting
       // the parameters of this function to the sanitizer MethodCall.
       exists(ZipSlipGuard g |
         // If the parameter flows directly to SanitizerMethodCall, and the resultant is returned
         DataFlow::localFlow(DataFlow::parameterNode(paramFilename),
           DataFlow::exprNode(g.getFilePathArgument())) and
         DataFlow::localFlow(DataFlow::exprNode(g), DataFlow::exprNode(ret.getExpr()))
       )
     )
   }
 }
 
 /**
  * A Wrapped Sanitizer Method call (some function that is equally or more restrictive than our root sanitizer)
  * 
  * bool wrapperMethod(string path){
  *  return realSanitizer(path);
  * }
  */
 class WrapperSanitizerMethodCall extends SanitizerMethodCall {
   
   AbstractWrapperSanitizerMethod wrapperMethod;
 
   WrapperSanitizerMethodCall() {
     exists(AbstractWrapperSanitizerMethod sm |
       this.getTarget() = sm and
       wrapperMethod = sm
     )
   }
 
   override Expr getFilePathArgument() {
     result = this.getArgument(wrapperMethod.paramFilePath().getIndex())
   }
 }
 
 private predicate wrapperCheckGuard(Guard g, Expr e, AbstractValue v) {
   // A given wrapper method call, with the filePathArgument as a sink, that returns 'true'
   g instanceof WrapperSanitizerMethodCall and
   g.(WrapperSanitizerMethodCall).getFilePathArgument() = e and
   v.(AbstractValues::BooleanValue).getValue() = true
 }
 
 /**
  * A sanitizer for unsafe zip extraction.
  */
 private abstract class Sanitizer extends DataFlow::ExprNode { }
 
 class WrapperCheckSanitizer extends Sanitizer {
   // A Wrapped RootSanitizer that is an explicit subset of RootSanitizer
   WrapperCheckSanitizer() { this = DataFlow::BarrierGuard<wrapperCheckGuard/3>::getABarrierNode() }
 }
 
 /**
  * A data flow source for unsafe zip extraction.
  */
 private abstract class Source extends DataFlow::Node { }
 
 /**
  * Access to the `FullName` property of the archive item
  */
 class ArchiveEntryFullName extends Source {
   ArchiveEntryFullName() {
     exists(PropertyAccess pa |
       pa.getTarget().hasQualifiedName("System.IO.Compression.ZipArchiveEntry", "FullName") and
       this = DataFlow::exprNode(pa)
     )
   }
 }
 
 /**
  * A data flow sink for unsafe zip extraction.
  */
 private abstract class Sink extends DataFlow::Node { }
 
 /** 
  * Argument to extract to file extension method
  */
 class SinkCompressionExtractToFileArgument extends Sink {
   SinkCompressionExtractToFileArgument() {
     exists(MethodCall mc |
       mc.getTarget().hasQualifiedName("System.IO.Compression.ZipFileExtensions", "ExtractToFile") and
       this.asExpr() = mc.getArgumentForName("destinationFileName")
     )
   }
 }
 
 /**
  * File Stream created from tainted file name through File.Open/File.Create
  */
 class SinkFileOpenArgument extends Sink {
   SinkFileOpenArgument() {
     exists(MethodCall mc |
       (
         mc.getTarget().hasQualifiedName("System.IO.File", "Open") or
         mc.getTarget().hasQualifiedName("System.IO.File", "OpenWrite") or
         mc.getTarget().hasQualifiedName("System.IO.File", "Create")
       ) and
       this.asExpr() = mc.getArgumentForName("path")
     )
   }
 }
 
 /**
  * File Stream created from tainted file name passed directly to the constructor
  */
 class SinkStreamConstructorArgument extends Sink {
   SinkStreamConstructorArgument() {
     exists(ObjectCreation oc |
       oc.getTarget().getDeclaringType().hasQualifiedName("System.IO", "FileStream") and
       this.asExpr() = oc.getArgumentForName("path")
     )
   }
 }
 
 
 /**
  * Constructor to FileInfo can take tainted file name and subsequently be used to open file stream
  */
 class SinkFileInfoConstructorArgument extends Sink {
   SinkFileInfoConstructorArgument() {
     exists(ObjectCreation oc |
       oc.getTarget().getDeclaringType().hasQualifiedName("System.IO", "FileInfo") and
       this.asExpr() = oc.getArgumentForName("fileName")
     )
   }
 }
 
 /**
  * Extracting just file name from a ZipEntry, not the full path
  */
 class FileNameExtrationSanitizer extends Sanitizer {
   FileNameExtrationSanitizer() {
     exists(MethodCall mc |
       mc.getTarget().hasQualifiedName("System.IO.Path", "GetFileName") and
       this = DataFlow::exprNode(mc.getAnArgument())
     )
   }
 }
 
 /**
  * Checks the string for relative path,
  * or checks the destination folder for whitelisted/target path, etc
  */
 class StringCheckSanitizer extends Sanitizer {
   StringCheckSanitizer() {
     exists(MethodCall mc |
       (
         mc instanceof RootSanitizerMethodCall or
         mc.getTarget().hasQualifiedName("System.String", "Substring")
       ) and
       this = DataFlow::exprNode(mc.getQualifier())
     )
   }
 }
 
 final class ZipSlipTaintTrackingConfiguration extends TaintTracking::Configuration {
   ZipSlipTaintTrackingConfiguration() { this = "ZipSlipTaintTrackingConfiguration" }
 
   override predicate isSource(DataFlow::Node node) { node instanceof Source }
 
   override predicate isSink(DataFlow::Node node) { node instanceof Sink }
 
   override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
     super.isAdditionalTaintStep(pred, succ)
     or
     exists(MethodCall mc | succ.asExpr() = mc and pred.asExpr() = mc.getAnArgument())
   }
 
   override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
 }
 
