/**
 * @name SSRF host guard does not reject IPv6-transition forms
 * @description An SSRF host guard that rejects private or loopback IPv4 ranges but never
 *              unwraps IPv6-transition forms (IPv4-mapped `::ffff:`, NAT64 `64:ff9b::`,
 *              6to4 `2002::`) can be bypassed by wrapping an internal IPv4 address in a
 *              transition literal, allowing requests to reach internal endpoints.
 * @kind problem
 * @problem.severity warning
 * @id javascript/ssrf-ipv6-transition-incomplete-guard
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 *       external/cwe/cwe-1389
 */

import javascript

/**
 * Holds if `f` imports a dotted-quad-oriented private-IP guard package whose
 * classification is performed on the textual IPv4 form and therefore returns
 * `false` for an internal address wrapped in an IPv6-transition literal.
 */
predicate importsHandRolledIpGuard(File f) {
  exists(DataFlow::SourceNode mod |
    mod.getFile() = f and
    mod = DataFlow::moduleImport(["private-ip", "is-ip", "ip", "ip-range-check"])
  )
}

/**
 * Holds if `f` contains a call to an `isPrivate`-style host classifier, the
 * common name for a hand-rolled SSRF guard.
 */
predicate hasIsPrivateCall(File f) {
  exists(DataFlow::CallNode c |
    c.getFile() = f and
    c.getCalleeName().regexpMatch("(?i)^is_?private(ip|address|host)?$")
  )
  or
  exists(DataFlow::MethodCallNode m |
    m.getFile() = f and
    m.getMethodName().regexpMatch("(?i)^is_?private(ip|address|host)?$")
  )
}

/**
 * Holds if `f` contains a hand-written RFC 1918, loopback or cloud-metadata IPv4
 * literal used as a denylist entry.
 */
predicate hasRfc1918Literal(File f) {
  exists(StringLiteral s |
    s.getFile() = f and
    s.getValue()
        .regexpMatch("(?i).*(127\\.0\\.0\\.1|169\\.254\\.169\\.254|10\\.|192\\.168|172\\.1[6-9]|::1|fc00|fd00|metadata\\.google).*")
  )
}

/** Holds if `f` carries any hand-rolled, dotted-quad-oriented SSRF guard signal. */
predicate hasUnsafeGuardSignal(File f) {
  importsHandRolledIpGuard(f) or
  hasIsPrivateCall(f) or
  hasRfc1918Literal(f)
}

/** Holds if `func` has a name that reads as an SSRF host or URL validator. */
predicate isSsrfValidatorFunction(Function func) {
  func.getName()
      .regexpMatch("(?i).*(validate|check|guard|reject|deny|block|allow|is_?safe|sanitiz)e?_?.*(url|host|ip|address|target|endpoint|webhook|origin).*")
  or
  func.getName()
      .regexpMatch("(?i).*(is_?)?(private|internal|loopback|reserved|external)_?(ip|address|host|url).*")
  or
  func.getName().regexpMatch("(?i).*(ssrf|metadata).*")
}

/**
 * Holds if `f` imports a maturity-hardened, transition-aware address classifier
 * or SSRF-protection library that does unwrap IPv6-transition forms.
 */
predicate importsSafeClassifier(File f) {
  exists(DataFlow::SourceNode mod |
    mod.getFile() = f and
    mod =
      DataFlow::moduleImport([
          "ipaddr.js", "ssrf-req-filter", "request-filtering-agent", "ssrf-agent", "netmask",
          "ip-cidr", "cidr-matcher", "blocked-at"
        ])
  )
}

/**
 * Holds if `f` already performs an explicit IPv6-transition unwrap or
 * canonicalization, so the guard does see the embedded IPv4 address.
 */
predicate hasTransitionUnwrap(File f) {
  exists(StringLiteral s |
    s.getFile() = f and
    (
      s.getValue().matches("%64:ff9b%") or
      s.getValue().matches("%::ffff%") or
      s.getValue().matches("%2002:%") or
      s.getValue().matches("%2001:%")
    )
  )
  or
  exists(Identifier id |
    id.getFile() = f and
    id.getName()
        .regexpMatch("(?i).*(ipv4mapped|v4mapped|mappedipv4|ipv4inipv6|embeddedipv4|unwrap.*ip|toipv4|canonicaliz|isipv4compat).*")
  )
  or
  exists(DataFlow::MethodCallNode m | m.getFile() = f and m.getMethodName() = ["range", "kind"])
}

/** Holds if `f` is treated as safe (transition-aware), suppressing the alert. */
predicate isSafe(File f) { importsSafeClassifier(f) or hasTransitionUnwrap(f) }

from Function guard, File f
where
  guard.getFile() = f and
  isSsrfValidatorFunction(guard) and
  hasUnsafeGuardSignal(f) and
  not isSafe(f) and
  not f.getRelativePath()
      .regexpMatch("(?i).*/(tests?|specs?|examples?|__tests__|e2e|node_modules)/.*")
select guard,
  "This SSRF host guard rejects private IPv4 ranges but never unwraps IPv6-transition forms " +
    "(IPv4-mapped '::ffff:', NAT64 '64:ff9b::', 6to4 '2002::'); an attacker can wrap an internal " +
    "IPv4 address in a transition literal to bypass it and reach internal endpoints."
