/**
 * Provides support for rate limiter queries.
 */
import python

/**
 * By assumption, any name that looks roughly like "ratelimiter" should be
 * assumed to be a name of a rate limiter.
 */
bindingset[s]
predicate isRateLimiterName(string s) {
  s.toLowerCase().regexpMatch("rate_?limit(s|er|ed)?|(rate_?)?limit(s|er|ed)")
}

/**
 * A function which acts as a rate limiter.
 */
abstract class RateLimiter extends Function { }

/**
 * A function which directly has a rate limiter name.
 */
class FunctionRateLimiter extends RateLimiter {
  FunctionRateLimiter() {
    isRateLimiterName(this.getName())
  }
}

/**
 * A class which has a rate limiter name.
 */
class RateLimiterClass extends Class {
  RateLimiterClass() {
    isRateLimiterName(this.getName())
  }
}

/**
 * A method called `wrap` on a rate limiter class.
 */
class WrapMethodRateLimiter extends RateLimiter {
  WrapMethodRateLimiter() {
    this.getName() = "wrap" and
    exists(RateLimiterClass rlc | this = rlc.getAMethod())
  }
}

/**
 * A method called `reduce` on a rate limiter class.
 */
class ReduceMethodRateLimiter extends RateLimiter {
  ReduceMethodRateLimiter() {
    this.getName() = "reduce" and
    exists(RateLimiterClass rlc | this = rlc.getAMethod())
  }
}

/**
 * A decorator which makes use of a rate limiter function.
 */
abstract class LimitingDecorator extends Expr { }

/**
 * A limiting decorator that is just a name, such as `@limit`.
 */
class NameLimitingDecorator extends LimitingDecorator, Name {
  NameLimitingDecorator() {
    exists(CallableValue fv |
        this.getAFlowNode().pointsTo(fv) and
        fv.getScope() instanceof RateLimiter
    )
  }
}

/**
 * A limiting decorator that is an attribute access, such as `@limiter.limit`.
 */
class AttributeLimitingDecorator extends LimitingDecorator, Attribute {
  AttributeLimitingDecorator() {
    exists(CallableValue fv |
        this.getAFlowNode().pointsTo(fv) and
        fv.getScope() instanceof RateLimiter
    )
  }
}

/**
 * A limiting decorator that is a call, such as `@limit(10)`.
 */
class CallLimitingDecorator extends LimitingDecorator, Call {
  CallLimitingDecorator() {
    exists(FunctionObject fo |
        this.getFunc().getAFlowNode().refersTo(fo) and
        fo.getFunction() instanceof RateLimiter
    )
  }
}

/**
 * A route handler that is expensive to run.
 */
abstract class ExpensiveRouteHandler extends Function {
  /**
   * A reason for why this route handler is expensive. Should be in the form of
   * a present tense verb phrase, and should be able to follow the sentential
   * subject "This route handler". For instance, "calls factorial on 100" is
   * a good value for the explanation, because one can write "This route handler
   * calls factorial on 100". On the other hand, "factorial of 100" is not,
   * because "This route handler factorial of 100" is ungrammatical.
   */
  abstract string getExplanation();
}

/**
 * A route handler that has a rate limiting decorator.
 */
class RateLimitedRouteHandler extends Function {
    RateLimitedRouteHandler() {
        exists(LimitingDecorator ld | this.getADecorator() = ld)
    }
}