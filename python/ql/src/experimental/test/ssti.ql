/**
 * @name Server-Side Template Injection. 
 * @description Server-side template injection occurs when user-controlled input is embedded into a server-side template, allowing users to inject template directives.
 * @kind ssti
 */

import python
import semmle.python.security.Paths
import semmle.python.web.HttpRequest
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted


class StringEvaluationNode extends TaintSink {
    override string toString() { result = "ssti in Jinja2" }
    StringEvaluationNode() {
        exists(Call call ,Name name | call.getFunc() = name and name.getId() = "render_template_string")
    }
    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}


class CodeInjectionConfiguration extends TaintTracking::Configuration {
    CodeInjectionConfiguration() { this = "Code injection configuration" }

    override predicate isSource(TaintTracking::Source source) {
        source instanceof HttpRequestTaintSource
    }

    override predicate isSink(TaintTracking::Sink sink) { sink instanceof StringEvaluationNode }
}

from CodeInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ flows to here and is interpreted as code.", src.getSource(),
    "A user-provided value"
