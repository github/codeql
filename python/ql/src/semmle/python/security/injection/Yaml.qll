/** Provides class and predicates to track external data that
 * may represent malicious yaml-encoded objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 *
 */

import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted


private ModuleObject yamlModule() {
    result.getName() = "yaml"
}


private FunctionObject yamlLoad() {
    result = yamlModule().getAttribute("load")
}

/** `yaml.load(untrusted)` vulnerability. */
class YamlLoadNode extends TaintSink {

    override string toString() { result = "yaml.load vulnerability" }

    YamlLoadNode() {
        exists(CallNode call |
            yamlLoad().getACall() = call and
            call.getAnArg() = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof ExternalStringKind
    }

}
