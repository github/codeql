import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.django.Shared
private import semmle.python.web.Http

/** INTERNAL class used for tracking a django response object. */
deprecated private class DjangoResponseKind extends TaintKind {
  DjangoResponseKind() { this = "django.response.HttpResponse" }
}

/** INTERNAL taint-source used for tracking a django response object. */
deprecated private class DjangoResponseSource extends TaintSource {
  DjangoResponseSource() { exists(DjangoContentResponseClass cls | cls.getACall() = this) }

  override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoResponseKind }

  override string toString() { result = "django.http.response.HttpResponse" }
}

/** A write to a django response, which is vulnerable to external data (xss) */
deprecated class DjangoResponseWrite extends HttpResponseTaintSink {
  DjangoResponseWrite() {
    exists(AttrNode meth, CallNode call |
      call.getFunction() = meth and
      any(DjangoResponseKind response).taints(meth.getObject("write")) and
      this = call.getArg(0)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "django.Response.write(...)" }
}

/**
 * An argument to initialization of a django response.
 */
deprecated class DjangoResponseContent extends HttpResponseTaintSink {
  DjangoContentResponseClass cls;
  CallNode call;

  DjangoResponseContent() {
    call = cls.getACall() and
    this = cls.getContentArg(call)
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "django.Response(...)" }
}

/**
 * An argument to initialization of a django response, which is vulnerable to external data (XSS).
 */
deprecated class DjangoResponseContentXSSVulnerable extends DjangoResponseContent {
  override DjangoXSSVulnerableResponseClass cls;

  DjangoResponseContentXSSVulnerable() {
    not exists(cls.getContentTypeArg(call))
    or
    exists(StringValue s |
      cls.getContentTypeArg(call).pointsTo(s) and
      s.getText().matches("text/html%")
    )
  }
}

deprecated class DjangoCookieSet extends CookieSet, CallNode {
  DjangoCookieSet() {
    any(DjangoResponseKind r).taints(this.getFunction().(AttrNode).getObject("set_cookie"))
  }

  override string toString() { result = CallNode.super.toString() }

  override ControlFlowNode getKey() { result = this.getArg(0) }

  override ControlFlowNode getValue() { result = this.getArg(1) }
}
