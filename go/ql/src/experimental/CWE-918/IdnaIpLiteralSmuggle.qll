/**
 * Stateful taint-tracking configuration for UTS-46 IDNA digit-fold
 * IP-literal smuggling in Go.
 *
 * Background
 * ----------
 * `golang.org/x/net/idna` applies UTS-46 NFKC mapping inside
 * `(*Profile).ToASCII`, which folds 100 non-ASCII Unicode digit codepoints
 * to their ASCII equivalents. The 100 codepoints span 8 families: Latin-1
 * superscripts, mathematical superscripts and subscripts, circled digits,
 * fullwidth digits, mathematical bold and sans-serif and double-struck
 * and monospace digits, and segmented digits. A caller that runs
 * `net.ParseIP` BEFORE `idna.ToASCII` will reject non-ASCII inputs as
 * non-IP, pass them to the IDNA library, and then receive a valid ASCII
 * IPv4 literal back as the "domain name" output. The post-IDNA result
 * silently bypasses any downstream IP-literal guard because the caller
 * never re-checks. Scope is IPv4 only. IPv6 colons are rejected by IDNA
 * rune-validation before UTS-46 mapping runs, so no IPv6 smuggle path
 * exists.
 *
 * Modeling
 * --------
 * Single-state tracking is structurally insufficient because a pre-IDNA
 * `net.ParseIP` barrier must NOT block flow that transitions through the
 * IDNA call. The configuration uses `TaintTracking::GlobalWithState` with
 * two flow states:
 *
 *   - `TPreIdna`  : untrusted hostname before IDNA mapping
 *   - `TPostIdna` : mapped output flowing toward a security-relevant sink
 *
 * `(*idna.Profile).ToASCII` (and the package-level `idna.ToASCII`,
 * `Lookup.ToASCII`, `MapForLookup().ToASCII`) is modeled as a
 * state-transition additional flow step that flips
 * `TPreIdna -> TPostIdna`.
 *
 * The barrier is `net.ParseIP`, `net.ParseCIDR`, `netip.ParseAddr`, or
 * `netip.ParsePrefix` consumed in `TPostIdna`. The safe pattern requires
 * trimming trailing dots before re-checking. Without the trim the literal
 * `"0.¹.0.0."` maps to `"0.1.0.0."`, which `net.ParseIP` rejects, so the
 * smuggle survives. The configuration also requires that the post-IDNA
 * value reaching the parser was produced by one of:
 *   (a) a `strings.TrimRight(_, ".")` call. This is the strict form. It
 *       handles multi-trailing-dot variants where UTS-46 mapping produces
 *       multiple trailing ASCII dots from fullwidth U+FF0E or ideographic
 *       U+3002 dot characters composing with ASCII dots.
 *   (b) a `strings.TrimSuffix(_, ".")` call. This accepts the common
 *       single-trailing-dot pattern but is incomplete for the multi-dot
 *       variant. It is included because it matches widely-used
 *       real-world callers.
 *   (c) an explicit `if strings.HasSuffix(out, ".") { out = out[:len(out)-1] }`
 *       slicing pattern.
 *
 * The barrier-strictness choice is documented in the README under
 * "Barrier strictness". Callers that rely on the TrimSuffix form should
 * verify that the multi-dot bypass class is not in their threat model.
 *
 * Sources
 * -------
 * Untrusted hostname inputs surfaced via the active threat model (HTTP request
 * URL host, HTTP request headers, function parameters typed as hostname-like,
 * env-var reads, file-content reads, command-line flag reads).
 *
 * Sinks
 * -----
 *   - `net.JoinHostPort` host argument
 *   - field-write to `(*net/http.Request).URL.Host`
 *   - field-write to `(*crypto/tls.Config).ServerName`
 *   - field-write to `(*net/http.Cookie).Domain`
 *   - HTTP client-request URL sinks (already modeled by `Http::ClientRequest`)
 *   - first argument to `net.Dial`, `net.DialTimeout`, `(*net.Dialer).Dial`,
 *     `(*net.Dialer).DialContext`
 *   - `net.LookupHost(host)` host argument
 *   - `net.LookupIP(host)` host argument
 *   - `(*net.Resolver).LookupHost(ctx, host)` host argument (index 1)
 *   - `(*net.Resolver).LookupIPAddr(ctx, host)` host argument (index 1)
 *
 * DNS-resolver sinks are exploitable because a smuggled IP literal
 * passed to `net.LookupHost` triggers a DNS query for the address-literal
 * form. Some resolvers answer with the IP directly, which is the DNS
 * resolver allowlist bypass risk class.
 *
 * `net.LookupCNAME` is intentionally excluded. Its first argument is a
 * hostname used only as a CNAME chain start, not passed to a connection
 * primitive, so IP-literal smuggling through it has no direct
 * network-access consequence and would produce noise without additional
 * sink chaining. `(*net.Resolver).LookupIP` is excluded for a different
 * reason: it does not exist on `*net.Resolver` (LookupIP is
 * package-level only); the Resolver type exposes LookupIPAddr instead.
 *
 * @id-companion go/idna-ip-literal-smuggle
 */

import go

  /**
   * The two flow states in the IDNA-smuggle taint configuration.
   *
   * `TPreIdna()` is the initial state of every untrusted hostname source.
   * `TPostIdna()` is reached only after a value has flowed through one of the
   * IDNA mapping calls. Sinks are only flagged in `TPostIdna()`.
   */
  newtype TFlowState =
    TPreIdna() or
    TPostIdna()

  /**
   * Holds if `call` is a call to one of the `idna` mapping entry points whose
   * UTS-46 NFKC behavior performs the digit fold. The argument-0 input is
   * regarded as the source of the additional flow step; result-0 is the
   * mapped output.
   *
   * The set covered:
   *   - method `(*golang.org/x/net/idna.Profile).ToASCII` on a profile that
   *     applies UTS-46 mapping (`Lookup`, `Display`, `Registration`, or any
   *     `idna.New(idna.MapForLookup(), ...)`-constructed profile)
   *   - method `(*golang.org/x/net/idna.Profile).ToUnicode` on the same
   *     profiles (the digit-fold pipeline runs in `validateAndMap` before
   *     the encode-as-Punycode-or-not branch, so `ToUnicode` produces the
   *     same digit-folded output as `ToASCII`)
   *
   * The package-level `golang.org/x/net/idna.ToASCII` helper is
   * intentionally NOT covered: it dispatches to `Punycode.process(...)`,
   * which has a nil mapping function and does not run the UTS-46 fold.
   * It has no smuggle surface and is treated as an unrelated identifier.
   */
  predicate idnaMappingCall(DataFlow::CallNode call) {
    call.(DataFlow::MethodCallNode)
        .getTarget()
        .hasQualifiedName("golang.org/x/net/idna", "Profile", ["ToASCII", "ToUnicode"]) and
    // Exclude the Punycode profile: it has nil UTS-46 mapping and so cannot
    // produce the digit-fold smuggle. Detect by the receiver being the
    // package-level `idna.Punycode` value.
    not exists(DataFlow::Node recv |
      recv = call.(DataFlow::MethodCallNode).getReceiver() and
      recv.asExpr().(SelectorExpr).getBase().(Ident).getName() = "idna" and
      recv.asExpr().(SelectorExpr).getSelector().getName() = "Punycode"
    )
  }

  /**
   * Holds if `node` is the input argument to an IDNA mapping call and `result`
   * is the call's primary string return.
   */
  predicate idnaMapInToOut(DataFlow::Node node, DataFlow::Node out) {
    exists(DataFlow::CallNode call |
      idnaMappingCall(call) and
      node = call.getArgument(0) and
      out = call.getResult(0)
    )
  }

  /**
   * Holds if `node` is the value being checked by a post-IDNA IP-literal
   * recheck call. We accept the four canonical Go primitives:
   *   - `net.ParseIP`
   *   - `net.ParseCIDR`
   *   - `net/netip.ParseAddr`
   *   - `net/netip.ParsePrefix`
   */
  predicate ipLiteralRecheckInput(DataFlow::Node node) {
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("net", ["ParseIP", "ParseCIDR"])
      or
      c.getTarget().hasQualifiedName("net/netip", ["ParseAddr", "ParsePrefix"])
    |
      node = c.getArgument(0)
    )
  }

  /**
   * Holds if `result` is the return of a `strings.TrimSuffix(x, ".")` or
   * `strings.TrimRight(x, ".")` call applied to `node`. This is the
   * trailing-dot strip that the safe pattern requires before the post-IDNA
   * IP recheck.
   */
  predicate trailingDotTrim(DataFlow::Node node, DataFlow::Node out) {
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("strings", ["TrimSuffix", "TrimRight"]) and
      c.getArgument(1).getStringValue() = "." and
      node = c.getArgument(0) and
      out = c.getResult(0)
    )
  }

  /**
   * Holds if `result` is produced by a slice-assignment of the form
   * `out = out[:len(out)-1]` applied to `node`. This is the manual slicing
   * variant of the trailing-dot strip (shape (c) in the module docstring).
   *
   * The high bound must be exactly `len(x) - 1` where `x` is the same
   * global-value-number as `node`. The lower bound is unconstrained because
   * the idiomatic form `out[:len(out)-1]` omits it (implicit zero).
   */
  predicate trailingDotSlice(DataFlow::Node node, DataFlow::Node out) {
    exists(SliceExpr se, DataFlow::CallNode lenCall, SubExpr sub |
      se.getHigh() = sub and
      sub.getRightOperand().getIntValue() = 1 and
      sub.getLeftOperand() = lenCall.asExpr() and
      // builtin `len` has no enclosing package (Go pseudo-package "builtin"
      // has no DataFlow representation); guard via callee name and the
      // absence of a package qualifier on the target Function.
      lenCall.getCalleeName() = "len" and
      not exists(lenCall.getTarget().getPackage()) and
      // The slice base, the len argument, and `node` all refer to the
      // same SSA-level value. Match by global-value-number so that any
      // of the three Reads can serve as the bound `node`.
      se.getBase().(Ident).getGlobalValueNumber() =
        node.asExpr().getGlobalValueNumber() and
      lenCall.getArgument(0).asExpr().getGlobalValueNumber() =
        node.asExpr().getGlobalValueNumber() and
      // The trim output is the slice expression itself; data flow
      // propagates from there through any subsequent assignment to the
      // parse input via DataFlow::localFlow.
      DataFlow::exprNode(se) = out
    )
  }

  /**
   * Holds if `node` reaches an IP-literal recheck call AND the value
   * reaching that call was produced by a trailing-dot trim of the
   * original IDNA output.
   *
   * Three shapes are accepted:
   *   (a) `strings.TrimRight(out, ".")` (multi-dot form)
   *   (b) `strings.TrimSuffix(out, ".")` (single-dot form)
   *   (c) `if strings.HasSuffix(out, ".") { out = out[:len(out)-1] }`
   *       (manual slice form)
   *
   * Callers that omit the trim entirely are NOT sanitized by this
   * predicate and remain alertable.
   */
  predicate safePostIdnaRecheck(DataFlow::Node postIdnaSource, DataFlow::Node node) {
    exists(DataFlow::Node trimSource, DataFlow::Node trimmed |
      DataFlow::localFlow(postIdnaSource, trimSource) and
      (trailingDotTrim(trimSource, trimmed) or
       trailingDotSlice(trimSource, trimmed)) and
      DataFlow::localFlow(trimmed, node) and
      ipLiteralRecheckInput(node)
    )
  }

  /**
   * Holds if `sink` is a hostname-consuming security-relevant sink for which
   * smuggled IP literals are exploitable.
   */
  predicate hostnameSink(DataFlow::Node sink) {
    // net.JoinHostPort host argument
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("net", "JoinHostPort") and
      sink = c.getArgument(0)
    )
    or
    // net.Dial, net.DialTimeout, (*net.Dialer).Dial, and .DialContext
    // "address" argument. Address is "host:port"; the whole arg is
    // modeled because upstream taint frequently arrives pre-joined.
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("net", ["Dial", "DialTimeout"]) and
      sink = c.getArgument(1)
    )
    or
    // (*Dialer).Dial(network, address string). Address is at argument
    // index 1. Reference signature: net/dial.go Dial(network, address
    // string).
    exists(DataFlow::MethodCallNode c |
      c.getTarget().hasQualifiedName("net", "Dialer", "Dial") and
      sink = c.getArgument(1)
    )
    or
    // (*Dialer).DialContext(ctx context.Context, network, address string).
    // Address is at index 2. Reference signature: net/dial.go
    // DialContext(ctx, network, address string).
    // The typed-address siblings (DialTCP, DialUDP, DialIP, DialUnix) take
    // *TCPAddr, *UDPAddr, *IPAddr, *UnixAddr (not plain strings) and are
    // intentionally excluded; a smuggled hostname string cannot satisfy
    // those parameter types.
    exists(DataFlow::MethodCallNode c |
      c.getTarget().hasQualifiedName("net", "Dialer", "DialContext") and
      sink = c.getArgument(2)
    )
    or
    // Field-writes to net/http.Request.URL.Host, tls.Config.ServerName,
    // http.Cookie.Domain.
    exists(Write w, Field f |
      (
        f.hasQualifiedName("net/url", "URL", "Host") or
        f.hasQualifiedName("crypto/tls", "Config", "ServerName") or
        f.hasQualifiedName("net/http", "Cookie", "Domain")
      ) and
      w.writesField(_, f, sink)
    )
    or
    // HTTP client-request URL sinks already modeled by the standard library.
    sink = any(Http::ClientRequest r).getUrl()
    or
    // net.LookupHost(host). Package-level DNS resolver; argument 0 is
    // the host.
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("net", "LookupHost") and
      sink = c.getArgument(0)
    )
    or
    // net.LookupIP(host). Package-level DNS resolver; argument 0 is the
    // host.
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("net", "LookupIP") and
      sink = c.getArgument(0)
    )
    or
    // (*net.Resolver).LookupHost(ctx, host). Argument 1 is the host
    // (argument 0 is context.Context).
    exists(DataFlow::MethodCallNode c |
      c.getTarget().hasQualifiedName("net", "Resolver", "LookupHost") and
      sink = c.getArgument(1)
    )
    or
    // (*net.Resolver).LookupIPAddr(ctx, host). Argument 1 is the host
    // (argument 0 is context.Context).
    exists(DataFlow::MethodCallNode c |
      c.getTarget().hasQualifiedName("net", "Resolver", "LookupIPAddr") and
      sink = c.getArgument(1)
    )
  }

  /** Configuration implementing the stateful taint-tracking signature. */
  module Config implements DataFlow::StateConfigSig {
    /** A flow state carried by tainted values in this configuration. */
    class FlowState extends TFlowState {
      /** Gets a human-readable description of this state. */
      string toString() {
        this = TPreIdna() and result = "PreIdna"
        or
        this = TPostIdna() and result = "PostIdna"
      }
    }

    predicate isSource(DataFlow::Node source, FlowState state) {
      source instanceof ActiveThreatModelSource and state = TPreIdna()
    }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      hostnameSink(sink) and state = TPostIdna()
    }

    /**
     * The IDNA mapping is modeled as a state-transition step:
     *   `TPreIdna(arg) -> TPostIdna(result)`
     */
    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      idnaMapInToOut(node1, node2) and
      state1 = TPreIdna() and
      state2 = TPostIdna()
    }

    /**
     * A correct post-IDNA IP-literal recheck (trailing-dot trim FOLLOWED
     * BY `net.ParseIP` or equivalent) is a barrier in `TPostIdna`. The
     * trim source is bound to the post-IDNA-tainted predecessor so that
     * an unrelated TrimRight + ParseIP construct elsewhere in the same
     * scope does not silently sanitize the IDNA-tainted path. A bare
     * `net.ParseIP` without the prior trim is NOT a barrier; the alert
     * remains.
     */
    predicate isBarrier(DataFlow::Node node, FlowState state) {
      state = TPostIdna() and
      exists(DataFlow::Node postIdnaResult, DataFlow::Node parseInput |
        idnaMapInToOut(_, postIdnaResult) and
        DataFlow::localFlow(postIdnaResult, node) and
        safePostIdnaRecheck(postIdnaResult, parseInput)
      )
    }

    predicate observeDiffInformedIncrementalMode() { any() }
  }

/** Tracks taint flow for IDNA digit-fold IP-literal smuggling. */
module Flow = TaintTracking::GlobalWithState<Config>;
