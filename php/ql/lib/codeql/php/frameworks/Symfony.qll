/**
 * Provides classes for modeling Symfony framework patterns.
 *
 * This module covers common Symfony patterns:
 * - Request object method calls
 * - Doctrine ORM queries
 * - Twig template rendering
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Symfony request parameter bag access (e.g., $request->query, $request->request).
 */
class SymfonyRequestBag extends MethodCall {
  SymfonyRequestBag() {
    exists(Variable v | v = this.getObject() | v.getName() in ["request", "req"]) and
    this.getMethodName() in ["query", "request", "headers", "cookies", "attributes", "files", "server"]
  }
}

/**
 * A Symfony request parameter access (e.g., $request->query->get('id')).
 */
class SymfonyRequestParameterAccess extends MethodCall {
  SymfonyRequestParameterAccess() {
    this.getMethodName() in ["get", "getBoolean", "getInt", "getAlpha", "getAlnum", "getDigits", "all", "keys", "has"]
  }

  /** Gets the parameter name as a string, if it's a literal. */
  string getParameterName() { result = this.getArgument(0).(StringLiteral).getValue() }
}

/**
 * A Doctrine query builder method call.
 */
class DoctrineQueryBuilderCall extends MethodCall {
  DoctrineQueryBuilderCall() {
    this.getMethodName() in [
      "select", "addSelect", "delete", "update", "set",
      "from", "innerJoin", "leftJoin", "rightJoin", "join",
      "where", "andWhere", "orWhere", "expr",
      "orderBy", "addOrderBy", "groupBy", "addGroupBy", "having", "andHaving",
      "setParameter", "setParameters", "setFirstResult", "setMaxResults",
      "getQuery", "getDQL", "getSingleResult", "getResult", "getArrayResult"
    ]
  }
}

/**
 * A Doctrine entity manager method call.
 */
class DoctrineEntityManagerCall extends MethodCall {
  DoctrineEntityManagerCall() {
    exists(Variable v | v = this.getObject() | v.getName() in ["em", "entityManager", "manager"]) and
    this.getMethodName() in [
      "find", "persist", "remove", "flush", "clear", "merge", "refresh",
      "createQuery", "createQueryBuilder", "getRepository",
      "beginTransaction", "commit", "rollback"
    ]
  }
}

/**
 * A Doctrine raw DQL query.
 */
class DoctrineRawQuery extends MethodCall {
  DoctrineRawQuery() {
    this.getMethodName() = "createQuery"
  }

  /** Gets the DQL string argument. */
  TS::PHP::AstNode getDqlArgument() { result = this.getArgument(0) }
}

/**
 * A Twig template rendering call.
 */
class TwigRenderCall extends MethodCall {
  TwigRenderCall() {
    this.getMethodName() in ["render", "renderView", "display"]
  }

  /** Gets the template name argument. */
  TS::PHP::AstNode getTemplateArgument() { result = this.getArgument(0) }

  /** Gets the data/context argument, if present. */
  TS::PHP::AstNode getDataArgument() { result = this.getArgument(1) }
}

/**
 * A Symfony form method call.
 */
class SymfonyFormCall extends MethodCall {
  SymfonyFormCall() {
    this.getMethodName() in [
      "createForm", "createFormBuilder", "handleRequest", "isSubmitted", "isValid",
      "getData", "get", "add"
    ]
  }
}

/**
 * A Symfony security check.
 */
class SymfonySecurityCheck extends MethodCall {
  SymfonySecurityCheck() {
    this.getMethodName() in [
      "isGranted", "denyAccessUnlessGranted", "getUser", "isAuthenticated"
    ]
  }
}

/**
 * A Symfony response helper.
 */
class SymfonyResponseCall extends MethodCall {
  SymfonyResponseCall() {
    this.getMethodName() in [
      "json", "redirect", "redirectToRoute", "file", "stream"
    ]
  }
}

/**
 * A Symfony route annotation pattern (detected via method naming).
 */
class SymfonyControllerAction extends MethodCall {
  SymfonyControllerAction() {
    // Actions typically end with "Action" in Symfony 3.x or are in Controller classes
    this.getMethodName().regexpMatch(".*Action")
  }
}

/**
 * A Symfony validator call.
 */
class SymfonyValidatorCall extends MethodCall {
  SymfonyValidatorCall() {
    this.getMethodName() in ["validate", "validateValue", "validatePropertyValue"]
  }
}

/**
 * A Symfony cache call.
 */
class SymfonyCacheCall extends MethodCall {
  SymfonyCacheCall() {
    this.getMethodName() in ["get", "getItem", "save", "delete", "hasItem", "deleteItem"]
  }
}

/**
 * A Symfony event dispatcher call.
 */
class SymfonyEventDispatcherCall extends MethodCall {
  SymfonyEventDispatcherCall() {
    this.getMethodName() in ["dispatch", "addListener", "addSubscriber", "removeListener"]
  }
}

/**
 * A Symfony logger call (PSR-3 style).
 */
class SymfonyLoggerCall extends MethodCall {
  SymfonyLoggerCall() {
    this.getMethodName() in [
      "emergency", "alert", "critical", "error", "warning", "notice", "info", "debug", "log"
    ]
  }
}
