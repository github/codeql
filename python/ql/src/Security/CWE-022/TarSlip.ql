/**
 * @name Arbitrary file write during tarfile extraction
 * @description Extracting files from a malicious tar archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
* @kind path-problem
 * @id py/tarslip
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-022
 */

import python
import semmle.python.security.Paths

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic

/** A TaintKind to represent open tarfile objects. That is, the result of calling `tarfile.open(...)` */
class OpenTarFile extends TaintKind {
    OpenTarFile() {
        this = "tarfile.open"
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "getmember" and result instanceof TarFileInfo
        or
        name = "getmembers" and result.(SequenceKind).getItem() instanceof TarFileInfo
    }

    override ClassValue getType() {
        result = Module::named("tarfile").attr("TarFile")
    }

    override TaintKind getTaintForIteration() {
        result instanceof TarFileInfo
    }

}

/** The source of open tarfile objects. That is, any call to `tarfile.open(...)` */
class TarfileOpen extends TaintSource {

    TarfileOpen() {
        Module::named("tarfile").attr("open").getACall() = this
        and
        /* If argument refers to a string object, then it's a hardcoded path and
         * this tarfile is safe.
         */
        not this.(CallNode).getAnArg().refersTo(any(StringObject str))
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof OpenTarFile
    }

}

class TarFileInfo extends TaintKind {

    TarFileInfo() {
        this = "tarfile.entry"
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "next" and result = this
    }

    override TaintKind getTaintOfAttribute(string name) {
        name = "name" and result instanceof TarFileInfo
    }
}


/* Any call to an extractall method */
class ExtractAllSink extends TaintSink {

    CallNode call;

    ExtractAllSink() {
        this = call.getFunction().(AttrNode).getObject("extractall")
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof OpenTarFile
    }

}

/* Argument to extract method */
class ExtractSink extends TaintSink {

    CallNode call;

    ExtractSink() {
        call.getFunction().(AttrNode).getName() = "extract" and
        this = call.getArg(0)
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof TarFileInfo
    }

}

class TarFileInfoSanitizer extends Sanitizer {

    TarFileInfoSanitizer() {
        this = "TarInfo sanitizer"
    }

    override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
        path_sanitizing_test(test.getTest()) and
        taint instanceof TarFileInfo
    }
}

private predicate path_sanitizing_test(ControlFlowNode test) {
    checks_not_absolute(test) and
    test.getAChild+().getNode().(StrConst).getText() = ".."
}

private predicate checks_not_absolute(ControlFlowNode test) {
    test.getAChild+().(CallNode).getFunction().pointsTo(Module::named("os.path").attr("absfile"))
    or
    test.getAChild+().getNode().(StrConst).getText() = "/"
}


class TarSlipConfiguration extends TaintTracking::Configuration {

    TarSlipConfiguration() { this = "TarSlip configuration" }

    override predicate isSource(TaintTracking::Source source) { source instanceof TarfileOpen }

    override predicate isSink(TaintTracking::Sink sink) { 
        sink instanceof ExtractSink or sink instanceof ExtractAllSink
    }

    override predicate isSanitizer(Sanitizer sanitizer) {
        sanitizer instanceof TarFileInfoSanitizer
    }
}


from TarSlipConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Extraction of tarfile from $@", src.getSource(), "a potentially untrusted source"


