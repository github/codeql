import python

import semmle.python.security.TaintTracking
import semmle.python.web.Http
import semmle.python.web.flask.General

private Value theFlaskRequestObject() {
    result = Value::named("flask.request")

}

/** Holds if `attr` is an access of attribute `name` of the flask request object */
private predicate flask_request_attr(AttrNode attr, string name) {
    attr.isLoad() and
    attr.getObject(name).pointsTo(theFlaskRequestObject())
}

/** Source of external data from a flask request */
class FlaskRequestData extends HttpRequestTaintSource {

    FlaskRequestData() {
        not this instanceof FlaskRequestArgs and
        exists(string name |
            flask_request_attr(this, name) |
            name = "path" or name = "full_path" or
            name = "base_url" or name = "url"
        )
    }

    override predicate isSourceOf(TaintKind kind) { 
        kind instanceof ExternalStringKind
    }

    override string toString() {
        result = "flask.request"
    }

}

/** Source of dictionary whose values are externally controlled */
class FlaskRequestArgs extends HttpRequestTaintSource {

    FlaskRequestArgs() {
        exists(string attr |
            flask_request_attr(this, attr) |
            attr = "args" or attr = "form" or
            attr = "values" or attr = "files" or
            attr = "headers" or attr = "json"
        )
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof ExternalStringDictKind
    }

    override string toString() {
        result = "flask.request.args"
    }

}


/** Source of dictionary whose values are externally controlled */
class FlaskRequestJson extends TaintSource {

    FlaskRequestJson() {
        flask_request_attr(this, "json")
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof ExternalJsonKind
    }

    override string toString() {
        result = "flask.request.json"
    }

}

