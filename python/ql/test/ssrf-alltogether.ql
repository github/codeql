/**
 * @name Server-side request forgery (ROUND 2)
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity TODO
 * @precision TODO
 * @id py/ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import python
import semmle.python.security.Paths
import semmle.python.web.HttpRequest // incoming server request
import semmle.python.web.ClientHttpRequest // outgoing client request
import semmle.python.regex
import semmle.python.security.strings.Untrusted

import Expressions.Formatting.AdvancedFormatting


// Won't work properly for HTTPConnection. Maybe we need a QL stdlib extension to
// differentiate between "sinks WholeUrl" and "sinks HostName" and "sinks Path+Query"

string text_before_format_insertion(AdvancedFormatString fmt, int arg_index) {
    exists(int fmt_start, int before_start |
        arg_index = fmt.getFieldNumber(fmt_start, _) and
        (
        any(int fmt_before | fmt_before = arg_index - 1) = fmt.getFieldNumber(_, before_start)
        or
        not any(int fmt_before | fmt_before = arg_index - 1) = fmt.getFieldNumber(_, _) and
        before_start = 0
        ) and
        result = fmt.getText().substring(before_start, fmt_start)

    )
}

/**
 * Holds if `insert` is inserted as a path component in a URL by `op`
 */
predicate inserted_as_path(ControlFlowNode op, ControlFlowNode insert) {
    not inserted_as_query(op, insert) and
    (
        exists(BinaryExprNode add | add = op and add.getOp() instanceof Add
        |
            // TODO: Use same trick with (://|/) to not require a dot

            // shouldn't match just `http://`, so we require a dot to be present
            rightmost_string_before_in_concat(add).getText().matches("%.%/%") and
            add.getRight() = insert
        )
        or
        exists(AdvancedFormattingCall call, int arg_index, string text_before |
            op.(CallNode).getNode() = call
        |
            call.getArg(arg_index).getAFlowNode() = insert and
            text_before = text_before_format_insertion(call.getAFormat(), arg_index) and

            // a `/` exists in the string before `insert` is inserted, and is not part of ://
            // TODO: write proper tests, currently just a winging of things :P
            exists(string match |
                match = text_before.regexpFind("(://|/)", _, _) and
                not match = "://"
                // in this specific instance, `not match = "://"` and `match != "://"` should be the same?
            )
            // this could be written as !=, but I found this to be cleaner in expressing my intention
            //
            // a = b [one element in a matches an element in b]
            // not a = b [no element in a matches any element in b]
            // a != b [one element in a does not match an element in b]
        )
    )
}

StringValue rightmost_string_before_in_concat(BinaryExprNode add) {
    add.getOp() instanceof Add and
    (
        result = add.getLeft().pointsTo()
        or
        exists(BinaryExprNode chain |
            chain.getOp() instanceof Add and
            add.getLeft() = chain and
            result = chain.getRight().pointsTo()
        )
    )
}

/**
 * Holds if `insert` is inserted as a query component in a URL by `op`
 */
predicate inserted_as_query(ControlFlowNode op, ControlFlowNode insert) {
    exists(BinaryExprNode add | add = op and add.getOp() instanceof Add
    |
        rightmost_string_before_in_concat(add).getText().matches("%?%") and
        add.getRight() = insert
    )
    or
    exists(AdvancedFormattingCall call, int arg_index, string text_before |
        op.(CallNode).getNode() = call
    |
        call.getArg(arg_index).getAFlowNode() = insert and
        // a `/` exists in the string before `insert` is inserted, and is not part of ://
        text_before = text_before_format_insertion(call.getAFormat(), arg_index) and
        text_before.matches("%?%")
    )
}

abstract class SSRFString extends ExternalStringKind {
    bindingset[this]
    SSRFString() { any() }
}

/** A taint for a whole URL where an attacker could control anything about it (domain + path) */
class AnyUntrusted extends SSRFString {
    AnyUntrusted() { this = "AnyUntrusted" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        result = super.getTaintForFlowStep(fromnode, tonode) and
        not inserted_as_path(tonode, fromnode) and
        not inserted_as_query(tonode, fromnode)
    }
}

/** A taint for a whole URL (or part of it) where an attacker could control the path part */
class PathUntrusted extends SSRFString {
    PathUntrusted() { this = "PathUntrusted" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        result = super.getTaintForFlowStep(fromnode, tonode) and
        not inserted_as_query(tonode, fromnode)
    }
}

abstract class SSRFSink extends TaintTracking::Sink { }

class WholeUrlSink extends SSRFSink {
    WholeUrlSink() {
        this = any(RequestsHttpRequest r).getAUrlPart()
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof AnyUntrusted
        or
        kind instanceof PathUntrusted
    }
}

class HTTPConnectionSink extends SSRFSink {

    HTTPConnectionSink() {
        this = any(HttpConnectionHttpRequest r).getAUrlPart()
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof UntrustedStringKind
    }
}

class SSRFConfiguration extends TaintTracking::Configuration {
    SSRFConfiguration() { this = "SSRFConfiguration" }

    override predicate isSource(TaintTracking::Source source) {
        source instanceof HttpRequestTaintSource
    }

    override predicate isSink(TaintTracking::Sink sink) {
        sink instanceof WholeUrlSink
        or
        sink instanceof HTTPConnectionSink
    }

    // bindingset[src, dest, srckind, destkind]
    // override predicate isBarrierEdge(
    //     DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind
    // ) {
    //     destkind instanceof UntrustedStringKind
    // }
}


from SSRFConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Server-side request forgery vulnerability due to $@.",
    src.getSource(), "a user-provided value"

// ROUND 2
