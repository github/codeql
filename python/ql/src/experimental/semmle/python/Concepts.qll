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

/** Provides classes for modeling Regular Expression-related APIs. */
module RegexExecution {
  /**
   * A data-flow node that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the executed expression.
     */
    abstract DataFlow::Node getRegexNode();

    /**
     * Gets the library used to execute the regular expression.
     */
    abstract string getRegexModule();
  }
}

/**
 * A data-flow node that executes a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexExecution::Range` instead.
 */
class RegexExecution extends DataFlow::Node {
  RegexExecution::Range range;

  RegexExecution() { this = range }

  DataFlow::Node getRegexNode() { result = range.getRegexNode() }

  string getRegexModule() { result = range.getRegexModule() }
}

/** Provides classes for modeling Regular Expression escape-related APIs. */
module RegexEscape {
  /**
   * A data-flow node that escapes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexEscape` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the escaped expression.
     */
    abstract DataFlow::Node getRegexNode();
  }
}

/**
 * A data-flow node that escapes a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexEscape::Range` instead.
 */
class RegexEscape extends DataFlow::Node {
  RegexEscape::Range range;

  RegexEscape() { this = range }

  DataFlow::Node getRegexNode() { result = range.getRegexNode() }
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
     * Gets the algorithm Node used in the encoding.
     */
    abstract DataFlow::Node getAlgorithm();

    /**
     * Tries to get the algorithm used in the encoding.
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
class JWTEncoding extends DataFlow::Node {
  JWTEncoding::Range range;

  JWTEncoding() { this = range }

  /**
   * Gets the argument containing the payload.
   */
  DataFlow::Node getPayload() { result = range.getPayload() }

  /**
   * Gets the argument containing the encoding key.
   */
  DataFlow::Node getKey() { result = range.getKey() }

  /**
   * Gets the algorithm Node used in the encoding.
   */
  DataFlow::Node getAlgorithm() { result = range.getAlgorithm() }

  /**
   * Tries to get the algorithm used in the encoding.
   */
  string getAlgorithmString() { result = range.getAlgorithmString() }
}

/** Provides classes for modeling JWT decoding-related APIs. */
module JWTDecoding {
  /**
   * A data-flow node that collects functions escaping regular expressions.
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
     * Gets the algorithm Node used in the encoding.
     */
    abstract DataFlow::Node getAlgorithm();

    /**
     * Tries to get the algorithm used in the encoding.
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
class JWTDecoding extends DataFlow::Node {
  JWTDecoding::Range range;

  JWTDecoding() { this = range }

  /**
   * Gets the argument containing the payload.
   */
  DataFlow::Node getPayload() { result = range.getPayload() }

  /**
   * Gets the argument containing the encoding key.
   */
  DataFlow::Node getKey() { result = range.getKey() }

  /**
   * Gets the algorithm Node used in the encoding.
   */
  DataFlow::Node getAlgorithm() { result = range.getAlgorithm() }

  /**
   * Tries to get the algorithm used in the encoding.
   */
  string getAlgorithmString() { result = range.getAlgorithmString() }

  /**
   * Gets the options Node used in the encoding.
   */
  DataFlow::Node getOptions() { result = range.getOptions() }

  /**
   * Checks if the signature gets verified while decoding.
   */
  predicate verifiesSignature() { range.verifiesSignature() }
}
