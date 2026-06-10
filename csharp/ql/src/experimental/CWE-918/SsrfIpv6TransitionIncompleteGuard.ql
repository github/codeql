/**
 * @name SSRF host guard does not reject IPv6-transition forms
 * @description An SSRF host guard that rejects private or loopback IPv4 ranges but never
 *              unwraps IPv6-transition forms (IPv4-mapped `::ffff:`, NAT64 `64:ff9b::`,
 *              6to4 `2002::`) can be bypassed by wrapping an internal IPv4 address in a
 *              transition literal, allowing requests to reach internal endpoints.
 * @kind problem
 * @problem.severity warning
 * @id cs/ssrf-ipv6-transition-incomplete-guard
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 *       external/cwe/cwe-1389
 */

import csharp

/**
 * Holds if `c` calls an `IPAddress.IsLoopback` or an `IsPrivate`/`IsInternal`-style host
 * classifier whose decision is taken on the dotted-quad IPv4 form, the common shape of a
 * hand-rolled SSRF guard.
 */
predicate hasIsPrivateCall(Callable c) {
  exists(MethodCall mc | mc.getEnclosingCallable() = c |
    mc.getTarget().hasName("IsLoopback") and
    mc.getTarget().getDeclaringType().hasFullyQualifiedName("System.Net", "IPAddress")
    or
    mc.getTarget()
        .getName()
        .regexpMatch("(?i)^is_?(private|internal|loopback|reserved|local|blocked)(ip|address|host)?$")
  )
}

/**
 * Holds if `c` contains a hand-written RFC 1918, loopback or cloud-metadata IPv4 literal
 * used as a denylist entry.
 */
predicate hasRfc1918Literal(Callable c) {
  exists(StringLiteral s | s.getEnclosingCallable() = c |
    s.getValue()
        .regexpMatch("(?i).*(127\\.0\\.0\\.1|169\\.254\\.169\\.254|10\\.|192\\.168|172\\.1[6-9]|::1|fc00|fd00|metadata\\.google).*")
  )
}

/**
 * Holds if `c` performs only the partial IPv4-mapped unwrap that `MapToIPv4` /
 * `IsIPv4MappedToIPv6` provide. These canonicalise the `::ffff:0:0/96` prefix only, leaving
 * NAT64 (`64:ff9b::/96`), 6to4 (`2002::/16`) and IPv4-compatible (`::N.N.N.N`) forms live.
 * `MapToIPv4` is a method; `IsIPv4MappedToIPv6` is a property, so both shapes are covered.
 */
predicate hasPartialMappedUnwrap(Callable c) {
  exists(MethodCall mc | mc.getEnclosingCallable() = c |
    mc.getTarget().getName() = ["MapToIPv4", "MapToIPv6"]
  )
  or
  exists(PropertyAccess pa | pa.getEnclosingCallable() = c |
    pa.getTarget().getName() = "IsIPv4MappedToIPv6"
  )
}

/** Holds if `c` carries any hand-rolled, dotted-quad-oriented SSRF guard signal. */
predicate hasUnsafeGuardSignal(Callable c) {
  hasIsPrivateCall(c) or
  hasRfc1918Literal(c) or
  hasPartialMappedUnwrap(c)
}

/** Holds if `c` has a name that reads as an SSRF host, URL or IP validator. */
predicate isSsrfValidatorCallable(Callable c) {
  c.getName()
      .regexpMatch("(?i).*(validate|check|guard|reject|deny|block|allow|is_?safe|sanitiz)e?_?.*(url|host|ip|address|target|endpoint|webhook|origin).*")
  or
  c.getName()
      .regexpMatch("(?i).*(is_?)?(private|internal|loopback|reserved|external)_?(ip|address|host|url).*")
  or
  c.getName().regexpMatch("(?i).*(ssrf|metadata).*")
}

/**
 * Holds if `c` already performs an explicit IPv6-transition unwrap or canonicalization, so
 * the guard does see the embedded IPv4 address. The presence of a `64:ff9b` / `2002:`
 * literal, or a NAT64 / 6to4 / extract-embedded-IPv4 helper, means every transition family
 * is accounted for rather than the `::ffff:0:0/96` prefix alone.
 */
predicate hasTransitionUnwrap(Callable c) {
  exists(StringLiteral s | s.getEnclosingCallable() = c |
    s.getValue().matches("%64:ff9b%") or
    s.getValue().matches("%2002:%") or
    s.getValue().matches("%::ffff:%")
  )
  or
  exists(MethodCall mc | mc.getEnclosingCallable() = c |
    mc.getTarget()
        .getName()
        .regexpMatch("(?i).*(nat64|6to4|extractembedded|embeddedipv4|ipv4inipv6|transition).*")
  )
}

/** Holds if `c` is treated as safe (transition-aware), suppressing the alert. */
predicate isSafe(Callable c) { hasTransitionUnwrap(c) }

from Callable guard
where
  isSsrfValidatorCallable(guard) and
  hasUnsafeGuardSignal(guard) and
  not isSafe(guard) and
  not guard.getFile()
      .getRelativePath()
      .regexpMatch("(?i).*/(tests?|specs?|examples?|e2e)/.*")
select guard,
  "This SSRF host guard rejects private IPv4 ranges but never unwraps IPv6-transition forms " +
    "(IPv4-mapped '::ffff:', NAT64 '64:ff9b::', 6to4 '2002::'); an attacker can wrap an internal " +
    "IPv4 address in a transition literal to bypass it and reach internal endpoints."
