/**
 * Provides classes modeling security-relevant aspects of the `urllib` module, part of
 * the Python standard library.
 *
 * See
 * - https://docs.python.org/2/library/urllib.html
 * - https://docs.python.org/3/library/urllib.html
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.security.dataflow.UrlRedirectCustomizations

/**
 * Provides models for the `urllib` module, part of
 * the Python standard library.
 *
 * See
 * - https://docs.python.org/2/library/urllib.html
 * - https://docs.python.org/3/library/urllib.html
 */
private module Urllib {
  /**
   * Provides models for the `urllib.request` extension library
   *
   * See https://docs.python.org/3.9/library/urllib.request.html
   */
  module Request {
    /**
     * See
     * - https://docs.python.org/3.9/library/urllib.request.html#urllib.request.Request
     */
    private class RequestCall extends Http::Client::Request::Range instanceof DataFlow::CallCfgNode {
      RequestCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("Request").getACall()
      }

      override DataFlow::Node getAUrlPart() {
        result in [super.getArg(0), super.getArgByName("url")]
      }

      override string getFramework() { result = "urllib.request.Request" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // cannot enable/disable certificate validation on this object, only when used
        // with `urlopen`, which is modeled below
        none()
      }
    }

    /**
     * See
     * - https://docs.python.org/3.9/library/urllib.request.html#urllib.request.urlopen
     */
    private class UrlOpenCall extends Http::Client::Request::Range instanceof DataFlow::CallCfgNode {
      UrlOpenCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("urlopen").getACall()
      }

      override DataFlow::Node getAUrlPart() {
        result in [super.getArg(0), super.getArgByName("url")]
      }

      override string getFramework() { result = "urllib.request.urlopen" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // will validate certificate by default, see https://github.com/python/cpython/blob/243ed5439c32e8517aa745bc2ca9774d99c99d0f/Lib/http/client.py#L1420-L1421
        // TODO: Handling of insecure SSLContext passed to context argument
        none()
      }
    }
  }

  /**
   * Provides models for the `urllib.parse` extension library.
   */
  module Parse {
    /**
     * A call to `urllib.parse.urlparse` or `urllib.parse.urlsplit`.
     */
    private DataFlow::CallCfgNode getUrlParseCall() {
      result =
        API::moduleImport("urllib")
            .getMember("parse")
            .getMember(["urlparse", "urlsplit"])
            .getACall()
    }

    /** A URL parser call whose URL argument resolves entirely to string literals. */
    private DataFlow::CallCfgNode getConstantUrlParseCall() {
      result = getUrlParseCall() and
      forex(DataFlow::LocalSourceNode source |
        source = [result.getArg(0), result.getArgByName(["url", "urlstring"])].getALocalSource()
      |
        source.asExpr() instanceof StringLiteral
      )
    }

    /** Holds if `e` is a parsed URL hostname, which is either non-empty or `None`. */
    private predicate isParsedUrlHostname(Expr e) {
      exists(DataFlow::AttrRead read |
        read = DataFlow::exprNode(e) and
        read.getAttributeName() = "hostname" and
        forex(DataFlow::LocalSourceNode source | source = read.getObject().getALocalSource() |
          source = getConstantUrlParseCall()
        )
      )
    }

    /** Holds if `e` itself is known not to be `""`. */
    private predicate sourceExcludesEmptyString(Expr e) {
      e.(StringLiteral).getText() != ""
      or
      isParsedUrlHostname(e)
    }

    /** Holds if every local source of `e` excludes `""`. */
    private predicate excludesEmptyString(Expr e) {
      forex(DataFlow::LocalSourceNode source | source = DataFlow::exprNode(e).getALocalSource() |
        sourceExcludesEmptyString(source.asExpr())
      )
    }

    /** Holds if every local source of `e` is a collection literal, rather than a string. */
    private predicate membershipChecksCollection(Expr e) {
      forex(DataFlow::LocalSourceNode source | source = DataFlow::exprNode(e).getALocalSource() |
        source.asCfgNode() instanceof IterableNode
        or
        source.asCfgNode() instanceof DictNode
      )
    }

    /**
     * Holds if every local source of `e` is an immutable collection literal, or a mutable
     * collection literal used directly in the membership test, whose elements or keys all exclude
     * `""`.
     */
    private predicate membershipExcludesEmptyString(Expr e) {
      forex(DataFlow::LocalSourceNode source | source = DataFlow::exprNode(e).getALocalSource() |
        exists(Expr collection | collection = source.asExpr() |
          (collection instanceof List or collection instanceof Tuple or collection instanceof Set) and
          (collection instanceof Tuple or collection = e) and
          forall(Expr elt |
            elt =
              [
                collection.(List).getAnElt(), collection.(Tuple).getAnElt(),
                collection.(Set).getAnElt()
              ]
          |
            excludesEmptyString(elt)
          )
          or
          collection instanceof Dict and
          collection = e and
          not collection.(Dict).getAnItem() instanceof DictUnpacking and
          forall(Expr key | key = collection.(Dict).getAKey() | excludesEmptyString(key))
        )
      )
    }

    /** Holds if every local source of `e` is `""`. */
    private predicate isEmptyString(Expr e) {
      forex(DataFlow::LocalSourceNode source | source = DataFlow::exprNode(e).getALocalSource() |
        source.asExpr().(StringLiteral).getText() = ""
      )
    }

    /** Holds if comparing against `e` using `op` cannot accept `""`. */
    private predicate comparisonExcludesEmptyString(Cmpop op, Expr e) {
      op.getSymbol() in ["in", "not in"] and membershipExcludesEmptyString(e)
      or
      op.getSymbol() in ["==", "is", "!=", "is not"] and excludesEmptyString(e)
    }

    /** Holds if `read` reads `attribute` from the result of `urlParseCall`. */
    private predicate parsedUrlAttributeRead(
      DataFlow::CallCfgNode urlParseCall, DataFlow::AttrRead read, string attribute
    ) {
      read.getAttributeName() = attribute and
      forex(DataFlow::LocalSourceNode source | source = read.getObject().getALocalSource() |
        source = urlParseCall
      )
    }

    /**
     * Holds if `g` is a falsiness check `not parsed.<attribute>` on a parsed URL `node`.
     */
    private predicate parsedUrlAttributeFalsiness(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch, string attribute
    ) {
      exists(DataFlow::CallCfgNode urlParseCall, DataFlow::AttrRead attributeRead |
        urlParseCall = getUrlParseCall() and
        parsedUrlAttributeRead(urlParseCall, attributeRead, attribute) and
        g = attributeRead.asCfgNode() and
        node = [urlParseCall.getArg(0), urlParseCall.getArgByName(["url", "urlstring"])].asCfgNode() and
        branch = false
      )
    }

    /**
     * Holds if `g` compares `attribute` (`"netloc"` or `"scheme"`) of a parsed URL `node`
     * against `other` using `op`, and the equality or collection membership holds on `branch`.
     */
    private predicate parsedUrlAttributeComparison(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch, string attribute, Cmpop op,
      Expr other
    ) {
      exists(
        DataFlow::CallCfgNode urlParseCall, DataFlow::AttrRead attributeRead, CompareNode cmp,
        ControlFlowNode otherNode
      |
        urlParseCall = getUrlParseCall() and
        parsedUrlAttributeRead(urlParseCall, attributeRead, attribute) and
        node = [urlParseCall.getArg(0), urlParseCall.getArgByName(["url", "urlstring"])].asCfgNode() and
        cmp = g and
        op = unique(Cmpop opp | opp = cmp.getNode().getAnOp()) and
        other = otherNode.getNode()
      |
        op.getSymbol() in ["==", "is"] and
        branch = true and
        (
          cmp.operands(attributeRead.asCfgNode(), op, otherNode) or
          cmp.operands(otherNode, op, attributeRead.asCfgNode())
        )
        or
        op.getSymbol() in ["!=", "is not"] and
        branch = false and
        (
          cmp.operands(attributeRead.asCfgNode(), op, otherNode) or
          cmp.operands(otherNode, op, attributeRead.asCfgNode())
        )
        or
        op.getSymbol() = "in" and
        membershipChecksCollection(other) and
        branch = true and
        cmp.operands(attributeRead.asCfgNode(), op, otherNode)
        or
        op.getSymbol() = "not in" and
        membershipChecksCollection(other) and
        branch = false and
        cmp.operands(attributeRead.asCfgNode(), op, otherNode)
      )
    }

    /** A `netloc` check that does not allow `""` (e.g. `parsed.netloc == request.host`). */
    private predicate nonEmptyNetlocCheck(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch
    ) {
      exists(Cmpop op, Expr other |
        parsedUrlAttributeComparison(g, node, branch, "netloc", op, other) and
        comparisonExcludesEmptyString(op, other)
      )
    }

    /** A `netloc` check that allows `""` (e.g. `not parsed.netloc` or `parsed.netloc in ["", host]`). */
    private predicate possiblyEmptyNetlocCheck(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch
    ) {
      parsedUrlAttributeFalsiness(g, node, branch, "netloc")
      or
      exists(Cmpop op, Expr other |
        parsedUrlAttributeComparison(g, node, branch, "netloc", op, other) and
        not comparisonExcludesEmptyString(op, other)
      )
    }

    /** A `scheme` check that ensures `scheme` is `""`. */
    private predicate emptySchemeCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
      parsedUrlAttributeFalsiness(g, node, branch, "scheme")
      or
      exists(Cmpop op, Expr other |
        parsedUrlAttributeComparison(g, node, branch, "scheme", op, other) and
        op.getSymbol() in ["==", "is", "!=", "is not"] and
        isEmptyString(other)
      )
    }

    /** Holds if every possible callee is `methodName` bound to `object`. */
    private predicate callsOnlyMethod(
      DataFlow::MethodCallNode call, DataFlow::Node object, string methodName
    ) {
      forex(DataFlow::LocalSourceNode source | source = call.getFunction().getALocalSource() |
        source.(DataFlow::AttrRead).getAttributeName() = methodName and
        source.(DataFlow::AttrRead).getObject() = object
      )
    }

    private predicate leadingSlashesCheck(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch
    ) {
      exists(DataFlow::MethodCallNode call, DataFlow::Node url, Expr prefix |
        callsOnlyMethod(call, url, "startswith") and
        (
          prefix = call.getArg(0).asExpr() or
          prefix = call.getArg(0).asExpr().(Tuple).getAnElt()
        ) and
        prefix.(StringLiteral).getText() in ["/", "//", "///"] and
        not exists(call.getArg(1)) and
        not exists(call.getStarArg()) and
        g = call.asCfgNode() and
        node = url.asCfgNode() and
        branch = false
      )
    }

    /** Holds if every local source of `node` is a no-argument `strip` or `lstrip` call. */
    private predicate isStripped(DataFlow::Node node) {
      forex(DataFlow::LocalSourceNode source | source = node.getALocalSource() |
        callsOnlyMethod(source, _, ["strip", "lstrip"]) and
        not exists(source.asExpr().(Call).getAPositionalArg()) and
        not exists(source.asExpr().(Call).getANamedArg())
      )
    }

    /** An `isprintable` check on a stripped URL. */
    private predicate normalizedPrintableCheck(
      DataFlow::GuardNode g, ControlFlowNode node, boolean branch
    ) {
      exists(DataFlow::MethodCallNode call, DataFlow::Node url |
        callsOnlyMethod(call, url, "isprintable") and
        not exists(call.asExpr().(Call).getAPositionalArg()) and
        not exists(call.asExpr().(Call).getANamedArg()) and
        isStripped(url) and
        g = call.asCfgNode() and
        node = url.asCfgNode() and
        branch = true
      )
    }

    /**
     * A check of `urllib.parse.urlparse` or `urllib.parse.urlsplit` considered as a
     * sanitizer-guard for URL redirection.
     *
     * Either `netloc` is restricted to a non-empty host, or `netloc` may be empty
     * and `scheme`, leading slashes (`///`), and browser-ignored characters are also checked.
     */
    private class NetlocCheck extends UrlRedirect::Sanitizer {
      NetlocCheck() {
        this = DataFlow::BarrierGuard<nonEmptyNetlocCheck/3>::getABarrierNode()
        or
        this = DataFlow::BarrierGuard<possiblyEmptyNetlocCheck/3>::getABarrierNode() and
        this = DataFlow::BarrierGuard<emptySchemeCheck/3>::getABarrierNode() and
        // Browsers interpret three or more leading slashes as an authority, unlike `urlparse`.
        this = DataFlow::BarrierGuard<leadingSlashesCheck/3>::getABarrierNode() and
        // Browsers ignore leading whitespace and control characters within URLs.
        this = DataFlow::BarrierGuard<normalizedPrintableCheck/3>::getABarrierNode()
      }

      override predicate sanitizes(UrlRedirect::FlowState state) {
        // Neither parser handles backslashes as browsers do.
        state instanceof UrlRedirect::NoBackslashes
      }
    }
  }
}
