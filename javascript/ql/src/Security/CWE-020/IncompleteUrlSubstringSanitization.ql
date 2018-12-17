/**
 * @name Incomplete URL substring sanitization
 * @description Security checks on the substrings of an unparsed URL are often vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-url-substring-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

from DataFlow::MethodCallNode call, string name, DataFlow::Node substring, string target
where
      (name = "indexOf" or name = "lastIndexOf" or name = "includes" or name = "startsWith" or name = "endsWith") and
      call.getMethodName() = name and
      substring = call.getArgument(0) and
      substring.mayHaveStringValue(target) and
      (
        // target contains a domain on a common TLD, and perhaps some other URL components
        target.regexpMatch("(?i)([a-z]*:?//)?\\.?([a-z0-9-]+\\.)+(" + RegExpPatterns::commonTLD() + ")(:[0-9]+)?/?") or
        // target is a HTTP URL to a domain on any TLD
        target.regexpMatch("(?i)https?://([a-z0-9-]+\\.)+([a-z]+)(:[0-9]+)?/?")
      ) and
      // whitelist
      not (
        (name = "indexOf" or name = "lastIndexOf") and
        (
          // arithmetic on the indexOf-result
          any(ArithmeticExpr e).getAnOperand().getUnderlyingValue() = call.asExpr()
          or
          // non-trivial position check on the indexOf-result
          exists(EqualityTest test, Expr n |
            test.hasOperands(call.asExpr(), n) |
            not n.getIntValue() = [-1..0]
          )
        )
        or
        // the leading dot in a subdomain sequence makes the suffix-check safe (if it is performed on the host of the url)
        name = "endsWith" and
        target.regexpMatch("(?i)\\.([a-z0-9-]+)(\\.[a-z0-9-]+)+")
        or
        // the trailing slash makes the prefix-check safe
        (
          name = "startsWith"
          or
          name = "indexOf" and
          exists(EqualityTest test, Expr n |
            test.hasOperands(call.asExpr(), n) and
            n.getIntValue() = 0
          )
        ) and
        target.regexpMatch(".*/")
      )
select call, "'$@' may be at an arbitrary position in the sanitized URL.", substring, target
