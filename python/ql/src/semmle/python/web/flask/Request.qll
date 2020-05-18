import python
import semmle.python.security.TaintTracking
import semmle.python.web.Http
import semmle.python.web.flask.General
import semmle.python.libraries.Werkzeug

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
        name in [
            "path",
            "full_path",
            "base_url",
            "url",
            "access_control_request_method",
            "content_encoding",
            "content_md5",
            "content_type",
            "data",
            "method",
            "mimetype",
            "origin",
            "query_string",
            "referrer",
            "remote_addr",
            "remote_user",
            "user_agent"
        ] and
        result instanceof ExternalStringKind
        or
        name in [
            "environ",
            "cookies",
            "mimetype_params",
            "view_args"
        ] and
        result instanceof ExternalStringDictKind
        or
        name in [
            "json"
        ] and
        result instanceof ExternalJsonKind
        or
        name = "access_route" and
        result.(SequenceKind).getItem() instanceof ExternalStringKind
        or
        name in ["accept_charsets", "accept_encodings", "accept_languages", "accept_mimetypes"] and
        result instanceof Werkzeug::AcceptKind
        or
        name in ["access_control_request_headers", "pragma"] and
        result.(Werkzeug::HeaderSetKind).getItem() instanceof ExternalStringKind
        or
        name in ["args", "values", "form"] and
        result.(Werkzeug::MultiDictKind).getValue() instanceof ExternalStringKind
        or
        name = "authorization" and
        result instanceof Werkzeug::AuthorizationKind
        or
        name = "cache_control" and
        result instanceof Werkzeug::RequestCacheControlKind
        or
        name = "files" and
        result.(Werkzeug::MultiDictKind).getValue() instanceof Werkzeug::FileStorageKind
        or
        name = "headers" and
        result instanceof Werkzeug::HeadersKind
        or
        name in ["stream", "input_stream"] and
        result instanceof ExternalFileObject
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "get_data" and
        result instanceof ExternalStringKind
        or
        name = "get_json" and
        result instanceof ExternalJsonKind
    }
}
