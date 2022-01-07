/**
 * This version resides in the experimental area and provides a space for
 * external contributors to place new concepts, keeping to our preferred
 * structure while remaining in the experimental area.
 *
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import experimental.semmle.python.Frameworks

/** Provides classes for modeling log related APIs. */
module LogOutput {
  /**
   * A data flow node for log output.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LogOutput` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Get the parameter value of the log output function.
     */
    abstract DataFlow::Node getAnInput();
  }
}

/**
 * A data flow node for log output.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LogOutput::Range` instead.
 */
class LogOutput extends DataFlow::Node {
  LogOutput::Range range;

  LogOutput() { this = range }

  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** Provides classes for modeling LDAP query execution-related APIs. */
module LDAPQuery {
  /**
   * A data-flow node that collects methods executing a LDAP query.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPQuery` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the executed expression.
     */
    abstract DataFlow::Node getQuery();
  }
}

/**
 * A data-flow node that collect methods executing a LDAP query.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPQuery::Range` instead.
 */
class LDAPQuery extends DataFlow::Node {
  LDAPQuery::Range range;

  LDAPQuery() { this = range }

  /**
   * Gets the argument containing the executed expression.
   */
  DataFlow::Node getQuery() { result = range.getQuery() }
}

/** Provides classes for modeling LDAP components escape-related APIs. */
module LDAPEscape {
  /**
   * A data-flow node that collects functions escaping LDAP components.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPEscape` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the escaped expression.
     */
    abstract DataFlow::Node getAnInput();
  }
}

/**
 * A data-flow node that collects functions escaping LDAP components.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPEscape::Range` instead.
 */
class LDAPEscape extends DataFlow::Node {
  LDAPEscape::Range range;

  LDAPEscape() { this = range }

  /**
   * Gets the argument containing the escaped expression.
   */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** Provides classes for modeling LDAP bind-related APIs. */
module LDAPBind {
  /**
   * A data-flow node that collects methods binding a LDAP connection.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPBind` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the binding host.
     */
    abstract DataFlow::Node getHost();

    /**
     * Gets the argument containing the binding expression.
     */
    abstract DataFlow::Node getPassword();

    /**
     * Holds if the binding process use SSL.
     */
    abstract predicate useSSL();
  }
}

/**
 * A data-flow node that collects methods binding a LDAP connection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPBind::Range` instead.
 */
class LDAPBind extends DataFlow::Node {
  LDAPBind::Range range;

  LDAPBind() { this = range }

  /**
   * Gets the argument containing the binding host.
   */
  DataFlow::Node getHost() { result = range.getHost() }

  /**
   * Gets the argument containing the binding expression.
   */
  DataFlow::Node getPassword() { result = range.getPassword() }

  /**
   * Holds if the binding process use SSL.
   */
  predicate useSSL() { range.useSSL() }
}

/** Provides classes for modeling SQL sanitization libraries. */
module SQLEscape {
  /**
   * A data-flow node that collects functions that escape SQL statements.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SQLEscape` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the raw SQL statement.
     */
    abstract DataFlow::Node getAnInput();
  }
}

/**
 * A data-flow node that collects functions escaping SQL statements.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SQLEscape::Range` instead.
 */
class SQLEscape extends DataFlow::Node {
  SQLEscape::Range range;

  SQLEscape() { this = range }

  /**
   * Gets the argument containing the raw SQL statement.
   */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** Provides a class for modeling NoSQL execution APIs. */
module NoSQLQuery {
  /**
   * A data-flow node that executes NoSQL queries.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `NoSQLQuery` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the NoSQL query to be executed. */
    abstract DataFlow::Node getQuery();
  }
}

/**
 * A data-flow node that executes NoSQL queries.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `NoSQLQuery::Range` instead.
 */
class NoSQLQuery extends DataFlow::Node {
  NoSQLQuery::Range range;

  NoSQLQuery() { this = range }

  /** Gets the argument that specifies the NoSQL query to be executed. */
  DataFlow::Node getQuery() { result = range.getQuery() }
}

/** Provides classes for modeling NoSQL sanitization-related APIs. */
module NoSQLSanitizer {
  /**
   * A data-flow node that collects functions sanitizing NoSQL queries.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `NoSQLSanitizer` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the NoSQL query to be sanitized. */
    abstract DataFlow::Node getAnInput();
  }
}

/**
 * A data-flow node that collects functions sanitizing NoSQL queries.
 *
 * Extend this class to model new APIs. If you want to refine existing API models,
 * extend `NoSQLSanitizer::Range` instead.
 */
class NoSQLSanitizer extends DataFlow::Node {
  NoSQLSanitizer::Range range;

  NoSQLSanitizer() { this = range }

  /** Gets the argument that specifies the NoSQL query to be sanitized. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** Provides classes for modeling HTTP Header APIs. */
module HeaderDeclaration {
  /**
   * A data-flow node that collects functions setting HTTP Headers.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `HeaderDeclaration` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the header name.
     */
    abstract DataFlow::Node getNameArg();

    /**
     * Gets the argument containing the header value.
     */
    abstract DataFlow::Node getValueArg();
  }
}

/**
 * A data-flow node that collects functions setting HTTP Headers.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `HeaderDeclaration::Range` instead.
 */
class HeaderDeclaration extends DataFlow::Node {
  HeaderDeclaration::Range range;

  HeaderDeclaration() { this = range }

  /**
   * Gets the argument containing the header name.
   */
  DataFlow::Node getNameArg() { result = range.getNameArg() }

  /**
   * Gets the argument containing the header value.
   */
  DataFlow::Node getValueArg() { result = range.getValueArg() }
}

/** Provides classes for modeling JWT encoding-related APIs. */
module JWTEncoding {
  /**
   * A data-flow node that collects methods encoding a JWT token.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `JWTEncoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the encoding payload.
     */
    abstract DataFlow::Node getPayload();

    /**
     * Gets the argument containing the encoding key.
     */
    abstract DataFlow::Node getKey();

    /**
     * Gets the argument for the algorithm used in the encoding.
     */
    abstract DataFlow::Node getAlgorithm();

    /**
     * Gets a string representation of the algorithm used in the encoding.
     */
    abstract string getAlgorithmString();
  }
}

/**
 * A data-flow node that collects methods encoding a JWT token.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `JWTEncoding::Range` instead.
 */
class JWTEncoding extends DataFlow::Node instanceof JWTEncoding::Range {
  /**
   * Gets the argument containing the payload.
   */
  DataFlow::Node getPayload() { result = super.getPayload() }

  /**
   * Gets the argument containing the encoding key.
   */
  DataFlow::Node getKey() { result = super.getKey() }

  /**
   * Gets the argument for the algorithm used in the encoding.
   */
  DataFlow::Node getAlgorithm() { result = super.getAlgorithm() }

  /**
   * Gets a string representation of the algorithm used in the encoding.
   */
  string getAlgorithmString() { result = super.getAlgorithmString() }
}

/** Provides classes for modeling JWT decoding-related APIs. */
module JWTDecoding {
  /**
   * A data-flow node that collects methods decoding a JWT token.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `JWTDecoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the encoding payload.
     */
    abstract DataFlow::Node getPayload();

    /**
     * Gets the argument containing the encoding key.
     */
    abstract DataFlow::Node getKey();

    /**
     * Gets the argument for the algorithm used in the encoding.
     */
    abstract DataFlow::Node getAlgorithm();

    /**
     * Gets a string representation of the algorithm used in the encoding.
     */
    abstract string getAlgorithmString();

    /**
     * Gets the options Node used in the encoding.
     */
    abstract DataFlow::Node getOptions();

    /**
     * Checks if the signature gets verified while decoding.
     */
    abstract predicate verifiesSignature();
  }
}

/**
 * A data-flow node that collects methods encoding a JWT token.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `JWTDecoding::Range` instead.
 */
class JWTDecoding extends DataFlow::Node instanceof JWTDecoding::Range {
  /**
   * Gets the argument containing the payload.
   */
  DataFlow::Node getPayload() { result = super.getPayload() }

  /**
   * Gets the argument containing the encoding key.
   */
  DataFlow::Node getKey() { result = super.getKey() }

  /**
   * Gets the argument for the algorithm used in the encoding.
   */
  DataFlow::Node getAlgorithm() { result = super.getAlgorithm() }

  /**
   * Gets a string representation of the algorithm used in the encoding.
   */
  string getAlgorithmString() { result = super.getAlgorithmString() }

  /**
   * Gets the options Node used in the encoding.
   */
  DataFlow::Node getOptions() { result = super.getOptions() }

  /**
   * Checks if the signature gets verified while decoding.
   */
  predicate verifiesSignature() { super.verifiesSignature() }
}
