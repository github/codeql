import python
import semmle.python.security.TaintTracking
import semmle.python.web.Http
import semmle.python.web.flask.General

/** Source of `flask.request`s. */
class FlaskRequestSource extends HttpRequestTaintSource {
    FlaskRequestSource() {
        this.(ControlFlowNode).pointsTo(Value::named("flask.request")) and
        not any(Import i).contains(this.(ControlFlowNode).getNode())
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof FlaskRequestKind }
}

/** TaintKind for `flask.request`. */
class FlaskRequestKind extends TaintKind {
    FlaskRequestKind() { this = "FlaskRequestKind" }

    override TaintKind getTaintOfAttribute(string name) {
        name in ["path", "full_path", "base_url", "url"] and
        result instanceof ExternalStringKind
        or
        name in ["args", "form", "values", "files", "headers", "json"] and
        result instanceof ExternalStringDictKind
        or
        name in ["json"] and
        result instanceof ExternalJsonKind
    }
}
