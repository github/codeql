/** Provides definitions to reason about HTTP cookies. */

import java
private import semmle.code.java.frameworks.Netty
private import semmle.code.java.frameworks.Servlets

/** An expression setting the value of a cookie. */
abstract class SetCookieValue extends Expr { }

private class ServletSetCookieValue extends SetCookieValue {
  ServletSetCookieValue() {
    exists(Call c |
      c.(ClassInstanceExpr).getConstructedType() instanceof TypeCookie and
      this = c.getArgument(1)
      or
      c.(MethodCall).getMethod() instanceof CookieSetValueMethod and
      this = c.getArgument(0)
    )
  }
}

private class NettySetCookieValue extends SetCookieValue {
  NettySetCookieValue() {
    exists(Call c |
      c.(ClassInstanceExpr).getConstructedType() instanceof NettyDefaultCookie and
      this = c.getArgument(1)
      or
      c.(MethodCall).getMethod() instanceof NettySetCookieValueMethod and
      this = c.getArgument(0)
    )
  }
}
