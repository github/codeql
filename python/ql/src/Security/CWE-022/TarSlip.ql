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

/** A TaintKind to represent open tarfile objects. That is, the result of calling `tarfile.open(...)` */
class OpenTarFile extends TaintKind {
    OpenTarFile() {
        this = "tarfile.open"
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

/* Any call to an extract method */
class ExtractionSink extends TaintSink {

    CallNode call;

    ExtractionSink() {
        this = call.getFunction().(AttrNode).getObject(extract())
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof OpenTarFile
    }

}

private string extract() {
    result = "extract" or result = "extractall"
}


//evil = [e for e in members if os.path.relpath(e).startswith(('/', '..'))]

class TarSlipConfiguration extends TaintTracking::Configuration {

    TarSlipConfiguration() { this = "TarSlip configuration" }

    override predicate isSource(TaintTracking::Source source) { source instanceof TarfileOpen }

    override predicate isSink(TaintTracking::Sink sink) { sink instanceof ExtractionSink }

}


from TarSlipConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Extraction of tarfile from $@", src.getSource(), "a potentially untrusted source"


