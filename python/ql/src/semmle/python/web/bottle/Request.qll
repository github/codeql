import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.web.Http
import semmle.python.web.bottle.General

private Value theBottleRequestObject() { result = theBottleModule().attr("request") }

class BottleRequestKind extends TaintKind {
    BottleRequestKind() { this = "bottle.request" }

    override TaintKind getTaintOfAttribute(string name) {
        name in ["environ", "url_args", "headers"] and
        result.(DictKind).getValue() instanceof UntrustedStringKind
        or
        name in ["path", "url", "fullpath", "query_string", "script_name", "content_type", "remote_addr"] and
        result instanceof UntrustedStringKind
        or
        name in ["cookies", "query", "forms", "params", "GET"] and
        result instanceof BottleFormsDict
        or
        // TODO
        // name = "files" and
        // result instanceof FilesBottleFormsDict
        // or
        // name = "POST" and
        // result instanceof FilesorUntrustedStringKindBottleFormsDict and
        // or
        name = "json" and
        result instanceof ExternalJsonKind
        or
        // TODO: Not sure what TaintKind to use here
        name = "body" and
        none()
        or
        name = "urlparts" and
        result.(ExternalUrlSplitResult).getItem() instanceof UntrustedStringKind
        or
        name in ["auth", "remote_route"] and
        result.(SequenceKind).getItem() instanceof UntrustedStringKind
        or
        // TODO: should be updated to be a FormsDict
        result.(DictKind).getValue() instanceof FileUpload and
        name = "files"
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name in ["get_header", "get_cookie"] and
        result instanceof UntrustedStringKind
        or
        name = "copy" and
        result instanceof BottleRequestKind
    }
}

private class RequestSource extends HttpRequestTaintSource {
    RequestSource() { this.(ControlFlowNode).pointsTo(theBottleRequestObject()) }

    override predicate isSourceOf(TaintKind kind) { kind instanceof BottleRequestKind }
}

class BottleFormsDict extends TaintKind {
    BottleFormsDict() { this = "bottle.FormsDict" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        /* Cannot use `getTaintOfAttribute(name)` as it wouldn't bind `name` */
        exists(string name |
            fromnode = tonode.(AttrNode).getObject(name) and
            result instanceof UntrustedStringKind
        |
            name != "get" and name != "getunicode" and name != "getall"
        )
    }

    override TaintKind getTaintOfMethodResult(string name) {
        (name = "get" or name = "getunicode") and
        result instanceof UntrustedStringKind
        or
        name = "getall" and result.(SequenceKind).getItem() instanceof UntrustedStringKind
    }
}

class FileUpload extends TaintKind {
    FileUpload() { this = "bottle.FileUpload" }

    override TaintKind getTaintOfAttribute(string name) {
        name = "filename" and result instanceof UntrustedStringKind
        or
        name = "raw_filename" and result instanceof UntrustedStringKind
        or
        name = "file" and result instanceof UntrustedFile
    }
}

class UntrustedFile extends TaintKind {
    UntrustedFile() { this = "Untrusted file" }
}

//
//   TO DO.. File uploads -- Should check about file uploads for other frameworks as well.
//  Move UntrustedFile to shared location
//
/** Parameter to a bottle request handler function */
class BottleRequestParameter extends HttpRequestTaintSource {
    BottleRequestParameter() {
        exists(BottleRoute route | route.getANamedArgument() = this.(ControlFlowNode).getNode())
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof UntrustedStringKind }

    override string toString() { result = "bottle handler function argument" }
}
