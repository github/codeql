/**
 * Provides classes for reasoning about rate limiting.
 *
 * We model two main concepts:
 *
 *   1. expensive route handlers, which should be rate-limited;
 *   2. rate-limited route handler expressions, that set up a route handler in such a way
 *      that it is rate-limited.
 *
 * The query then looks for expensive route handlers that are not rate-limited.
 *
 * Both concepts are modeled as abstract classes (`ExpensiveRouteHandler` and
 * `RateLimitedRouteHandlerExpr`, respectively) with a few default subclasses capturing
 * common use cases. They can be customized by adding more subclasses.
 *
 * For `ExpensiveRouteHandler`, the default subclasses recognize route handlers performing
 * expensive actions, again modeled as an abstract class `ExpensiveAction`. By default,
 * file system access, operating system command execution, and database access are considered
 * expensive; other kinds of expensive actions can be modeled by adding more subclasses.
 *
 * For `RateLimitedRouteHandlerExpr`, the default subclasses model popular npm packages;
 * other means of rate-limiting can be supported by adding more subclasses.
 */

import javascript
private import semmle.javascript.frameworks.ConnectExpressShared::ConnectExpressShared

// main concepts
/**
 * A route handler that should be rate-limited.
 */
abstract class ExpensiveRouteHandler extends DataFlow::Node {
  /**
   * Holds if `explanation` is a string explaining why this route handler should be rate-limited.
   *
   * The explanation may contain a `$@` placeholder, which is replaced by `reference` labeled
   * with `referenceLabel`. If `explanation` does not contain a placeholder, `reference` and
   * `referenceLabel` are ignored and should be bound to dummy values.
   */
  abstract predicate explain(string explanation, DataFlow::Node reference, string referenceLabel);
}

/**
 * DEPRECATED. Use `RateLimitingMiddleware` instead.
 *
 * A route handler expression that is guarded by a rate limiter.
 */
deprecated class RateLimitedRouteHandlerExpr extends Express::RouteHandlerExpr {
  RateLimitedRouteHandlerExpr() {
    Routing::getNode(this.flow()).isGuardedBy(any(RateLimitingMiddleware m))
  }
}

// default implementations
/**
 * A route handler that performs an expensive action, and hence should be rate-limited.
 */
class RouteHandlerPerformingExpensiveAction extends ExpensiveRouteHandler, DataFlow::ValueNode {
  ExpensiveAction action;

  RouteHandlerPerformingExpensiveAction() { astNode = action.getContainer() }

  override predicate explain(string explanation, DataFlow::Node reference, string referenceLabel) {
    explanation = "performs $@" and
    reference = action and
    referenceLabel = action.describe()
  }
}

/**
 * A data flow node that corresponds to a resource-intensive action being taken.
 */
abstract class ExpensiveAction extends DataFlow::Node {
  /**
   * Gets a description of this expensive action for use in an alert message.
   *
   * The description is prepended with "performs" in the context of the alert message.
   */
  abstract string describe();
}

/** A call to an authorization function, considered as an expensive action. */
class AuthorizationCallAsExpensiveAction extends ExpensiveAction {
  AuthorizationCallAsExpensiveAction() { this instanceof AuthorizationCall }

  override string describe() { result = "authorization" }
}

/** A file system access, considered as an expensive action. */
class FileSystemAccessAsExpensiveAction extends ExpensiveAction {
  FileSystemAccessAsExpensiveAction() { this instanceof FileSystemAccess }

  override string describe() { result = "a file system access" }
}

/** A system command execution, considered as an expensive action. */
class SystemCommandExecutionAsExpensiveAction extends ExpensiveAction {
  SystemCommandExecutionAsExpensiveAction() { this instanceof SystemCommandExecution }

  override string describe() { result = "a system command" }
}

/** A database access, considered as an expensive action. */
class DatabaseAccessAsExpensiveAction extends ExpensiveAction {
  DatabaseAccessAsExpensiveAction() { this instanceof DatabaseAccess }

  override string describe() { result = "a database access" }
}

/**
 * DEPRECATED. Use the `Routing::Node` API instead.
 *
 * A route handler expression that is rate-limited by a rate-limiting middleware.
 */
deprecated class RouteHandlerExpressionWithRateLimiter extends Expr {
  RouteHandlerExpressionWithRateLimiter() {
    Routing::getNode(this.flow()).isGuardedBy(any(RateLimitingMiddleware m))
  }
}

/**
 * DEPRECATED. Use `RateLimitingMiddleware` instead.
 *
 * A middleware that acts as a rate limiter.
 */
deprecated class RateLimiter extends Express::RouteHandlerExpr {
  RateLimiter() { any(RateLimitingMiddleware m).ref().flowsToExpr(this) }
}

/**
 * The creation of a middleware function that acts as a rate limiter.
 */
abstract class RateLimitingMiddleware extends DataFlow::SourceNode {
  /** Gets a data flow node referring to this middleware. */
  private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
    t.start() and
    result = this
    or
    DataFlow::functionOneWayForwardingStep(this.ref(t.continue()).getALocalUse(), result)
    or
    exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
  }

  /** Gets a data flow node referring to this middleware. */
  DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }

  /** Gets a routing node corresponding to this middleware function. */
  Routing::Node getRoutingNode() { result = Routing::getNode(this) }
}

/**
 * A rate limiter constructed using the `express-rate-limit` package.
 */
class ExpressRateLimit extends RateLimitingMiddleware {
  ExpressRateLimit() {
    this = API::moduleImport("express-rate-limit").getReturn().getAnImmediateUse()
  }
}

/**
 * A rate limiter constructed using the `express-brute` package.
 */
class BruteForceRateLimit extends RateLimitingMiddleware {
  BruteForceRateLimit() {
    this = API::moduleImport("express-brute").getInstance().getMember("prevent").getAnImmediateUse()
  }
}

/**
 * A rate limiter constructed using the `express-limiter` package.
 *
 * Note that the `express-limiter` package is unusual in that it may optionally install itself as a middleware.
 * That aspect is handled by the Express core model.
 */
class RouteHandlerLimitedByExpressLimiter extends RateLimitingMiddleware {
  RouteHandlerLimitedByExpressLimiter() {
    this = API::moduleImport("express-limiter").getReturn().getReturn().getAnImmediateUse()
  }

  override Routing::Node getRoutingNode() {
    result = super.getRoutingNode()
    or
    // express-limiter can perform its own route setup
    result = Routing::getRouteSetupNode(this)
  }
}

/**
 * A rate-handler function implemented using one of the rate-limiting classes provided
 * by the `rate-limiter-flexible` package.
 *
 * We look for route handlers that invoke the `consume` method of one of the `RateLimiter*`
 * classes from the `rate-limiter-flexible` package on a property of their request parameter,
 * like the `rateLimiterMiddleware` function in this example:
 *
 * ```
 * import { RateLimiterRedis } from 'rate-limiter-flexible';
 * const rateLimiter = new RateLimiterRedis(...);
 * function rateLimiterMiddleware(req, res, next) {
 *   rateLimiter.consume(req.ip).then(next).catch(res.status(429).send('rate limited'));
 * }
 * ```
 */
class RateLimiterFlexibleRateLimiter extends DataFlow::FunctionNode {
  RateLimiterFlexibleRateLimiter() {
    exists(
      string rateLimiterClassName, API::Node rateLimiterClass, API::Node rateLimiterConsume,
      DataFlow::ParameterNode request
    |
      rateLimiterClassName.matches("RateLimiter%") and
      rateLimiterClass = API::moduleImport("rate-limiter-flexible").getMember(rateLimiterClassName) and
      rateLimiterConsume = rateLimiterClass.getInstance().getMember("consume") and
      request.getParameter() = getRouteHandlerParameter(this.getFunction(), "request") and
      request.getAPropertyRead().flowsTo(rateLimiterConsume.getAParameter().getARhs())
    )
  }
}

/**
 * A route-handler expression that is rate-limited by the `rate-limiter-flexible` package.
 */
class RouteHandlerLimitedByRateLimiterFlexible extends RateLimitingMiddleware {
  RouteHandlerLimitedByRateLimiterFlexible() { this instanceof RateLimiterFlexibleRateLimiter }
}

private class FastifyRateLimiter extends RateLimitingMiddleware {
  FastifyRateLimiter() { this = DataFlow::moduleImport("fastify-rate-limit") }
}
