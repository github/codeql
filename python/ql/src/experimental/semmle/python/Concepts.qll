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

/** Provides classes for modeling copying file related APIs. */
module CopyFile {
  /**
   * A data flow node for copying file.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CopyFile` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the path.
     */
    abstract DataFlow::Node getAPathArgument();

    /**
     * Gets fsrc argument.
     */
    abstract DataFlow::Node getfsrcArgument();
  }
}

/**
 * A data flow node for copying file.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CopyFile::Range` instead.
 */
class CopyFile extends DataFlow::Node {
  CopyFile::Range range;

  CopyFile() { this = range }

  DataFlow::Node getAPathArgument() { result = range.getAPathArgument() }

  DataFlow::Node getfsrcArgument() { result = range.getfsrcArgument() }
}

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

/**
 * Since there is both XML module in normal and experimental Concepts,
 * we have to rename the experimental module as this.
 */
module ExperimentalXML {
  /**
   * A kind of XML vulnerability.
   *
   * See https://pypi.org/project/defusedxml/#python-xml-libraries
   */
  class XMLVulnerabilityKind extends string {
    XMLVulnerabilityKind() {
      this in ["Billion Laughs", "Quadratic Blowup", "XXE", "DTD retrieval"]
    }

    /** Holds for Billion Laughs vulnerability kind. */
    predicate isBillionLaughs() { this = "Billion Laughs" }

    /** Holds for Quadratic Blowup vulnerability kind. */
    predicate isQuadraticBlowup() { this = "Quadratic Blowup" }

    /** Holds for XXE vulnerability kind. */
    predicate isXxe() { this = "XXE" }

    /** Holds for DTD retrieval vulnerability kind. */
    predicate isDtdRetrieval() { this = "DTD retrieval" }
  }

  /**
   * A data-flow node that parses XML.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `XMLParsing` instead.
   */
  class XMLParsing extends DataFlow::Node instanceof XMLParsing::Range {
    /**
     * Gets the argument containing the content to parse.
     */
    DataFlow::Node getAnInput() { result = super.getAnInput() }

    /**
     * Holds if this XML parsing is vulnerable to `kind`.
     */
    predicate vulnerableTo(XMLVulnerabilityKind kind) { super.vulnerableTo(kind) }
  }

  /** Provides classes for modeling XML parsing APIs. */
  module XMLParsing {
    /**
     * A data-flow node that parses XML.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XMLParsing` instead.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the argument containing the content to parse.
       */
      abstract DataFlow::Node getAnInput();

      /**
       * Holds if this XML parsing is vulnerable to `kind`.
       */
      abstract predicate vulnerableTo(XMLVulnerabilityKind kind);
    }
  }
}

/** Provides classes for modeling LDAP query execution-related APIs. */
module LdapQuery {
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

/** DEPRECATED: Alias for LdapQuery */
deprecated module LDAPQuery = LdapQuery;

/**
 * A data-flow node that collect methods executing a LDAP query.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPQuery::Range` instead.
 */
class LdapQuery extends DataFlow::Node {
  LdapQuery::Range range;

  LdapQuery() { this = range }

  /**
   * Gets the argument containing the executed expression.
   */
  DataFlow::Node getQuery() { result = range.getQuery() }
}

/** DEPRECATED: Alias for LdapQuery */
deprecated class LDAPQuery = LdapQuery;

/** Provides classes for modeling LDAP components escape-related APIs. */
module LdapEscape {
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

/** DEPRECATED: Alias for LdapEscape */
deprecated module LDAPEscape = LdapEscape;

/**
 * A data-flow node that collects functions escaping LDAP components.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPEscape::Range` instead.
 */
class LdapEscape extends DataFlow::Node {
  LdapEscape::Range range;

  LdapEscape() { this = range }

  /**
   * Gets the argument containing the escaped expression.
   */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** DEPRECATED: Alias for LdapEscape */
deprecated class LDAPEscape = LdapEscape;

/** Provides classes for modeling LDAP bind-related APIs. */
module LdapBind {
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

/** DEPRECATED: Alias for LdapBind */
deprecated module LDAPBind = LdapBind;

/**
 * A data-flow node that collects methods binding a LDAP connection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPBind::Range` instead.
 */
class LdapBind extends DataFlow::Node {
  LdapBind::Range range;

  LdapBind() { this = range }

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

/** DEPRECATED: Alias for LdapBind */
deprecated class LDAPBind = LdapBind;

/** Provides classes for modeling SQL sanitization libraries. */
module SqlEscape {
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

/** DEPRECATED: Alias for SqlEscape */
deprecated module SQLEscape = SqlEscape;

/**
 * A data-flow node that collects functions escaping SQL statements.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SQLEscape::Range` instead.
 */
class SqlEscape extends DataFlow::Node {
  SqlEscape::Range range;

  SqlEscape() { this = range }

  /**
   * Gets the argument containing the raw SQL statement.
   */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** DEPRECATED: Alias for SqlEscape */
deprecated class SQLEscape = SqlEscape;

/** Provides a class for modeling NoSql execution APIs. */
module NoSqlQuery {
  /**
   * A data-flow node that executes NoSQL queries.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `NoSQLQuery` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the NoSql query to be executed. */
    abstract DataFlow::Node getQuery();
  }
}

/** DEPRECATED: Alias for NoSqlQuery */
deprecated module NoSQLQuery = NoSqlQuery;

/**
 * A data-flow node that executes NoSQL queries.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `NoSQLQuery::Range` instead.
 */
class NoSqlQuery extends DataFlow::Node {
  NoSqlQuery::Range range;

  NoSqlQuery() { this = range }

  /** Gets the argument that specifies the NoSql query to be executed. */
  DataFlow::Node getQuery() { result = range.getQuery() }
}

/** DEPRECATED: Alias for NoSqlQuery */
deprecated class NoSQLQuery = NoSqlQuery;

/** Provides classes for modeling NoSql sanitization-related APIs. */
module NoSqlSanitizer {
  /**
   * A data-flow node that collects functions sanitizing NoSQL queries.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `NoSQLSanitizer` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the NoSql query to be sanitized. */
    abstract DataFlow::Node getAnInput();
  }
}

/** DEPRECATED: Alias for NoSqlSanitizer */
deprecated module NoSQLSanitizer = NoSqlSanitizer;

/**
 * A data-flow node that collects functions sanitizing NoSQL queries.
 *
 * Extend this class to model new APIs. If you want to refine existing API models,
 * extend `NoSQLSanitizer::Range` instead.
 */
class NoSqlSanitizer extends DataFlow::Node {
  NoSqlSanitizer::Range range;

  NoSqlSanitizer() { this = range }

  /** Gets the argument that specifies the NoSql query to be sanitized. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** DEPRECATED: Alias for NoSqlSanitizer */
deprecated class NoSQLSanitizer = NoSqlSanitizer;

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
module JwtEncoding {
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

/** DEPRECATED: Alias for JwtEncoding */
deprecated module JWTEncoding = JwtEncoding;

/**
 * A data-flow node that collects methods encoding a JWT token.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `JWTEncoding::Range` instead.
 */
class JwtEncoding extends DataFlow::Node instanceof JwtEncoding::Range {
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

/** DEPRECATED: Alias for JwtEncoding */
deprecated class JWTEncoding = JwtEncoding;

/** Provides classes for modeling JWT decoding-related APIs. */
module JwtDecoding {
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

/** DEPRECATED: Alias for JwtDecoding */
deprecated module JWTDecoding = JwtDecoding;

/**
 * A data-flow node that collects methods encoding a JWT token.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `JWTDecoding::Range` instead.
 */
class JwtDecoding extends DataFlow::Node instanceof JwtDecoding::Range {
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

/** DEPRECATED: Alias for JwtDecoding */
deprecated class JWTDecoding = JwtDecoding;
