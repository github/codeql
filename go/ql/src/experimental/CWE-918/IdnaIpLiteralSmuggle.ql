/**
 * @name IDNA digit-fold IP-literal smuggling via UTS-46 NFKC mapping
 * @description An untrusted hostname flows through
 *              `(*golang.org/x/net/idna.Profile).ToASCII` or `.ToUnicode`
 *              on a digit-folding profile (which folds 100 non-ASCII
 *              Unicode digit codepoints to ASCII via UTS-46 NFKC) and
 *              reaches a security-relevant hostname sink without a
 *              post-IDNA IP-literal recheck. A caller that omits the
 *              recheck (or only runs `net.ParseIP` BEFORE the mapping
 *              call) will accept a smuggled IPv4 literal such as
 *              `"0.¹.0.0"` (which maps to `"0.1.0.0"`). Scope is IPv4
 *              only because IPv6 colons are rejected by IDNA
 *              rune-validation before UTS-46 mapping runs.
 * @id go/idna-ip-literal-smuggle
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 *       external/cwe/cwe-020
 * @requires codeql/go-all >= 0.6.0
 */

import go
import IdnaIpLiteralSmuggle
import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Untrusted hostname from $@ flows through a `golang.org/x/net/idna` mapping call (which performs UTS-46 NFKC digit folding) and reaches this hostname sink without a post-IDNA `net.ParseIP` (or `netip.ParseAddr`) recheck on the trailing-dot-stripped value.",
  source.getNode(), "this user-controlled value"
