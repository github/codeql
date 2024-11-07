/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Frameworks
private import semmle.python.security.internal.EncryptionKeySizes
private import codeql.threatmodels.ThreatModels

/**
 * A data flow source, for a specific threat-model.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `ThreatModelSource::Range` instead.
 */
class ThreatModelSource extends DataFlow::Node instanceof ThreatModelSource::Range {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   *
   * See
   * - https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst
   * - https://github.com/github/codeql/blob/main/shared/threat-models/ext/threat-model-grouping.model.yml
   */
  string getThreatModel() { result = super.getThreatModel() }

  /** Gets a string that describes the type of this threat-model source. */
  string getSourceType() { result = super.getSourceType() }
}

/** Provides a class for modeling new sources for specific threat-models. */
module ThreatModelSource {
  /**
   * A data flow source, for a specific threat-model.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `ThreatModelSource` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets a string that represents the source kind with respect to threat modeling.
     *
     * See
     * - https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst
     * - https://github.com/github/codeql/blob/main/shared/threat-models/ext/threat-model-grouping.model.yml
     */
    abstract string getThreatModel();

    /** Gets a string that describes the type of this threat-model source. */
    abstract string getSourceType();
  }
}

/**
 * A data flow source that is enabled in the current threat model configuration.
 */
class ActiveThreatModelSource extends ThreatModelSource {
  ActiveThreatModelSource() {
    exists(string kind |
      currentThreatModel(kind) and
      this.getThreatModel() = kind
    )
  }
}

/**
 * A data-flow node that executes an operating system command,
 * for instance by spawning a new process.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SystemCommandExecution::Range` instead.
 */
class SystemCommandExecution extends DataFlow::Node instanceof SystemCommandExecution::Range {
  /** Holds if a shell interprets `arg`. */
  predicate isShellInterpreted(DataFlow::Node arg) { super.isShellInterpreted(arg) }

  /** Gets the argument that specifies the command to be executed. */
  DataFlow::Node getCommand() { result = super.getCommand() }
}

/** Provides a class for modeling new system-command execution APIs. */
module SystemCommandExecution {
  /**
   * A data-flow node that executes an operating system command,
   * for instance by spawning a new process.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SystemCommandExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the command to be executed. */
    abstract DataFlow::Node getCommand();

    /** Holds if a shell interprets `arg`. */
    predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }
}

/**
 * A data flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemAccess::Range` instead.
 */
class FileSystemAccess extends DataFlow::Node instanceof FileSystemAccess::Range {
  /** Gets an argument to this file system access that is interpreted as a path. */
  DataFlow::Node getAPathArgument() { result = super.getAPathArgument() }
}

/** Provides a class for modeling new file system access APIs. */
module FileSystemAccess {
  /**
   * A data-flow node that performs a file system access, including reading and writing data,
   * creating and deleting files and folders, checking and updating permissions, and so on.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemAccess` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an argument to this file system access that is interpreted as a path. */
    abstract DataFlow::Node getAPathArgument();
  }
}

/**
 * A data flow node that writes data to the file system access.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemWriteAccess::Range` instead.
 */
class FileSystemWriteAccess extends FileSystemAccess instanceof FileSystemWriteAccess::Range {
  /**
   * Gets a node that represents data to be written to the file system (possibly with
   * some transformation happening before it is written, like JSON encoding).
   */
  DataFlow::Node getADataNode() { result = super.getADataNode() }
}

/** Provides a class for modeling new file system writes. */
module FileSystemWriteAccess {
  /**
   * A data flow node that writes data to the file system access.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemWriteAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data to be written to the file system (possibly with
     * some transformation happening before it is written, like JSON encoding).
     */
    abstract DataFlow::Node getADataNode();
  }
}

/** Provides classes for modeling path-related APIs. */
module Path {
  /**
   * A data-flow node that performs path normalization. This is often needed in order
   * to safely access paths.
   */
  class PathNormalization extends DataFlow::Node instanceof PathNormalization::Range {
    /** Gets an argument to this path normalization that is interpreted as a path. */
    DataFlow::Node getPathArg() { result = super.getPathArg() }
  }

  /** Provides a class for modeling new path normalization APIs. */
  module PathNormalization {
    /**
     * A data-flow node that performs path normalization. This is often needed in order
     * to safely access paths.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets an argument to this path normalization that is interpreted as a path. */
      abstract DataFlow::Node getPathArg();
    }
  }

  /** A data-flow node that checks that a path is safe to access. */
  class SafeAccessCheck extends DataFlow::ExprNode {
    SafeAccessCheck() { this = DataFlow::BarrierGuard<safeAccessCheck/3>::getABarrierNode() }
  }

  private predicate safeAccessCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
    g.(SafeAccessCheck::Range).checks(node, branch)
  }

  /** Provides a class for modeling new path safety checks. */
  module SafeAccessCheck {
    /** A data-flow node that checks that a path is safe to access. */
    abstract class Range extends DataFlow::GuardNode {
      /** Holds if this guard validates `node` upon evaluating to `branch`. */
      abstract predicate checks(ControlFlowNode node, boolean branch);
    }
  }
}

/**
 * A data-flow node that decodes data from a binary or textual format. This
 * is intended to include deserialization, unmarshalling, decoding, unpickling,
 * decompressing, decrypting, parsing etc.
 *
 * A decoding (automatically) preserves taint from input to output. However, it can
 * also be a problem in itself, for example if it allows code execution or could result
 * in denial-of-service.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Decoding::Range` instead.
 */
class Decoding extends DataFlow::Node instanceof Decoding::Range {
  /** Holds if this call may execute code embedded in its input. */
  predicate mayExecuteInput() { super.mayExecuteInput() }

  /** Gets an input that is decoded by this function. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the decoded data produced by this function. */
  DataFlow::Node getOutput() { result = super.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = super.getFormat() }
}

/** Provides a class for modeling new decoding mechanisms. */
module Decoding {
  /**
   * A data-flow node that decodes data from a binary or textual format. This
   * is intended to include deserialization, unmarshalling, decoding, unpickling,
   * decompressing, decrypting, parsing etc.
   *
   * A decoding (automatically) preserves taint from input to output. However, it can
   * also be a problem in itself, for example if it allows code execution or could result
   * in denial-of-service.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Decoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Holds if this call may execute code embedded in its input. */
    abstract predicate mayExecuteInput();

    /** Gets an input that is decoded by this function. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the decoded data produced by this function. */
    abstract DataFlow::Node getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}

private class DecodingAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    exists(Decoding decoding |
      nodeFrom = decoding.getAnInput() and
      nodeTo = decoding.getOutput() and
      model = "Decoding-" + decoding.getFormat()
    )
  }
}

/**
 * A data-flow node that encodes data to a binary or textual format. This
 * is intended to include serialization, marshalling, encoding, pickling,
 * compressing, encrypting, etc.
 *
 * An encoding (automatically) preserves taint from input to output.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Encoding::Range` instead.
 */
class Encoding extends DataFlow::Node instanceof Encoding::Range {
  /** Gets an input that is encoded by this function. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the encoded data produced by this function. */
  DataFlow::Node getOutput() { result = super.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = super.getFormat() }
}

/** Provides a class for modeling new encoding mechanisms. */
module Encoding {
  /**
   * A data-flow node that encodes data to a binary or textual format. This
   * is intended to include serialization, marshalling, encoding, pickling,
   * compressing, encrypting, etc.
   *
   * An encoding (automatically) preserves taint from input to output.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Encoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that is encoded by this function. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the encoded data produced by this function. */
    abstract DataFlow::Node getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}

private class EncodingAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Encoding encoding |
      nodeFrom = encoding.getAnInput() and
      nodeTo = encoding.getOutput()
    )
  }
}

/**
 * A data-flow node that logs data.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Logging::Range` instead.
 */
class Logging extends DataFlow::Node instanceof Logging::Range {
  /** Gets an input that is logged. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }
}

/** Provides a class for modeling new logging mechanisms. */
module Logging {
  /**
   * A data-flow node that logs data.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Logging` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that is logged. */
    abstract DataFlow::Node getAnInput();
  }
}

/**
 * A data-flow node that dynamically executes Python code.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CodeExecution::Range` instead.
 */
class CodeExecution extends DataFlow::Node instanceof CodeExecution::Range {
  /** Gets the argument that specifies the code to be executed. */
  DataFlow::Node getCode() { result = super.getCode() }
}

/** Provides a class for modeling new dynamic code execution APIs. */
module CodeExecution {
  /**
   * A data-flow node that dynamically executes Python code.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CodeExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the code to be executed. */
    abstract DataFlow::Node getCode();
  }
}

/**
 * A data-flow node that constructs an SQL statement.
 *
 * Often, it is worthy of an alert if an SQL statement is constructed such that
 * executing it would be a security risk.
 *
 * If it is important that the SQL statement is indeed executed, then use `SqlExecution`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlConstruction::Range` instead.
 */
class SqlConstruction extends DataFlow::Node instanceof SqlConstruction::Range {
  /** Gets the argument that specifies the SQL statements to be constructed. */
  DataFlow::Node getSql() { result = super.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlConstruction {
  /**
   * A data-flow node that constructs an SQL statement.
   *
   * Often, it is worthy of an alert if an SQL statement is constructed such that
   * executing it would be a security risk.
   *
   * If it is important that the SQL statement is indeed executed, then use `SqlExecution`.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SqlConstruction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the SQL statements to be constructed. */
    abstract DataFlow::Node getSql();
  }
}

/**
 * A data-flow node that executes SQL statements.
 *
 * If the context of interest is such that merely constructing an SQL statement
 * would be valuable to report, then consider using `SqlConstruction`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlExecution::Range` instead.
 */
class SqlExecution extends DataFlow::Node instanceof SqlExecution::Range {
  /** Gets the argument that specifies the SQL statements to be executed. */
  DataFlow::Node getSql() { result = super.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlExecution {
  /**
   * A data-flow node that executes SQL statements.
   *
   * If the context of interest is such that merely constructing an SQL statement
   * would be valuable to report, then consider using `SqlConstruction`.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SqlExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the SQL statements to be executed. */
    abstract DataFlow::Node getSql();
  }
}

/** Provides a class for modeling NoSQL execution APIs. */
module NoSqlExecution {
  /**
   * A data-flow node that executes NoSQL queries.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `NoSqlExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the NoSQL query to be executed. */
    abstract DataFlow::Node getQuery();

    /** Holds if this query will unpack/interpret a dictionary */
    abstract predicate interpretsDict();

    /** Holds if this query can be dangerous when run on a user-controlled string */
    abstract predicate vulnerableToStrings();
  }
}

/**
 * A data-flow node that executes NoSQL queries.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `NoSqlExecution::Range` instead.
 */
class NoSqlExecution extends DataFlow::Node instanceof NoSqlExecution::Range {
  /** Gets the argument that specifies the NoSQL query to be executed. */
  DataFlow::Node getQuery() { result = super.getQuery() }

  /** Holds if this query will unpack/interpret a dictionary */
  predicate interpretsDict() { super.interpretsDict() }

  /** Holds if this query can be dangerous when run on a user-controlled string */
  predicate vulnerableToStrings() { super.vulnerableToStrings() }
}

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

/**
 * A data-flow node that collects functions sanitizing NoSQL queries.
 *
 * Extend this class to model new APIs. If you want to refine existing API models,
 * extend `NoSQLSanitizer::Range` instead.
 */
class NoSqlSanitizer extends DataFlow::Node instanceof NoSqlSanitizer::Range {
  /** Gets the argument that specifies the NoSql query to be sanitized. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }
}

/**
 * A data-flow node that executes a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexExecution::Range` instead.
 */
class RegexExecution extends DataFlow::Node instanceof RegexExecution::Range {
  /** Gets the data flow node for the regex being executed by this node. */
  DataFlow::Node getRegex() { result = super.getRegex() }

  /** Gets a dataflow node for the string to be searched or matched against. */
  DataFlow::Node getString() { result = super.getString() }

  /**
   * Gets the name of this regex execution, typically the name of an executing method.
   * This is used for nice alert messages and should include the module if possible.
   */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling new regular-expression execution APIs. */
module RegexExecution {
  /**
   * A data-flow node that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the data flow node for the regex being executed by this node. */
    abstract DataFlow::Node getRegex();

    /** Gets a dataflow node for the string to be searched or matched against. */
    abstract DataFlow::Node getString();

    /**
     * Gets the name of this regex execution, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    abstract string getName();
  }
}

/**
 * A node where a string is interpreted as a regular expression,
 * for instance an argument to `re.compile`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegExpInterpretation::Range` instead.
 */
class RegExpInterpretation extends DataFlow::Node instanceof RegExpInterpretation::Range { }

/** Provides a class for modeling regular expression interpretations. */
module RegExpInterpretation {
  /**
   * A node where a string is interpreted as a regular expression,
   * for instance an argument to `re.compile`.
   */
  abstract class Range extends DataFlow::Node { }
}

/** Provides classes for modeling XML-related APIs. */
module XML {
  /**
   * A data-flow node that constructs an XPath expression.
   *
   * Often, it is worthy of an alert if an XPath expression is constructed such that
   * executing it would be a security risk.
   *
   * If it is important that the XPath expression is indeed executed, then use `XPathExecution`.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `XPathConstruction::Range` instead.
   */
  class XPathConstruction extends DataFlow::Node instanceof XPathConstruction::Range {
    /** Gets the argument that specifies the XPath expressions to be constructed. */
    DataFlow::Node getXPath() { result = super.getXPath() }

    /**
     * Gets the name of this XPath expression construction, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    string getName() { result = super.getName() }
  }

  /** Provides a class for modeling new XPath construction APIs. */
  module XPathConstruction {
    /**
     * A data-flow node that constructs an XPath expression.
     *
     * Often, it is worthy of an alert if an XPath expression is constructed such that
     * executing it would be a security risk.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XPathConstruction` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the argument that specifies the XPath expressions to be constructed. */
      abstract DataFlow::Node getXPath();

      /**
       * Gets the name of this XPath expression construction, typically the name of an executing method.
       * This is used for nice alert messages and should include the module if possible.
       */
      abstract string getName();
    }
  }

  /**
   * A data-flow node that executes a xpath expression.
   *
   * If the context of interest is such that merely constructing an XPath expression
   * would be valuable to report, then consider using `XPathConstruction`.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `XPathExecution::Range` instead.
   */
  class XPathExecution extends DataFlow::Node instanceof XPathExecution::Range {
    /** Gets the data flow node for the XPath expression being executed by this node. */
    DataFlow::Node getXPath() { result = super.getXPath() }

    /**
     * Gets the name of this XPath expression execution, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    string getName() { result = super.getName() }
  }

  /** Provides classes for modeling new regular-expression execution APIs. */
  module XPathExecution {
    /**
     * A data-flow node that executes a XPath expression.
     *
     * If the context of interest is such that merely constructing an XPath expression
     * would be valuable to report, then consider using `XPathConstruction`.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XPathExecution` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the data flow node for the XPath expression being executed by this node. */
      abstract DataFlow::Node getXPath();

      /**
       * Gets the name of this xpath expression execution, typically the name of an executing method.
       * This is used for nice alert messages and should include the module if possible.
       */
      abstract string getName();
    }
  }

  /**
   * A kind of XML vulnerability.
   *
   * See overview of kinds at https://pypi.org/project/defusedxml/#python-xml-libraries
   *
   * See PoC at `python/PoCs/XmlParsing/PoC.py` for some tests of vulnerable XML parsing.
   */
  class XmlParsingVulnerabilityKind extends string {
    XmlParsingVulnerabilityKind() { this in ["XML bomb", "XXE", "DTD retrieval"] }

    /**
     * Holds for XML bomb vulnerability kind, such as 'Billion Laughs' and 'Quadratic
     * Blowup'.
     *
     * While a parser could technically be vulnerable to one and not the other, from our
     * point of view the interesting part is that it IS vulnerable to these types of
     * attacks, and not so much which one specifically works. In practice I haven't seen
     * a parser that is vulnerable to one and not the other.
     */
    predicate isXmlBomb() { this = "XML bomb" }

    /** Holds for XXE vulnerability kind. */
    predicate isXxe() { this = "XXE" }

    /** Holds for DTD retrieval vulnerability kind. */
    predicate isDtdRetrieval() { this = "DTD retrieval" }
  }

  /**
   * A data-flow node that parses XML.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `XmlParsing` instead.
   */
  class XmlParsing extends Decoding instanceof XmlParsing::Range {
    /**
     * Holds if this XML parsing is vulnerable to `kind`.
     */
    predicate vulnerableTo(XmlParsingVulnerabilityKind kind) { super.vulnerableTo(kind) }
  }

  /** Provides classes for modeling XML parsing APIs. */
  module XmlParsing {
    /**
     * A data-flow node that parses XML.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XmlParsing` instead.
     */
    abstract class Range extends Decoding::Range {
      /**
       * Holds if this XML parsing is vulnerable to `kind`.
       */
      abstract predicate vulnerableTo(XmlParsingVulnerabilityKind kind);

      override string getFormat() { result = "XML" }
    }
  }
}

/** Provides classes for modeling LDAP-related APIs. */
module Ldap {
  /**
   * A data-flow node that executes an LDAP query.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `LDAPQuery::Range` instead.
   */
  class LdapExecution extends DataFlow::Node instanceof LdapExecution::Range {
    /** Gets the argument containing the filter string. */
    DataFlow::Node getFilter() { result = super.getFilter() }

    /** Gets the argument containing the base DN. */
    DataFlow::Node getBaseDn() { result = super.getBaseDn() }
  }

  /** Provides classes for modeling new LDAP query execution-related APIs. */
  module LdapExecution {
    /**
     * A data-flow node that executes an LDAP query.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `LDAPQuery` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the argument containing the filter string. */
      abstract DataFlow::Node getFilter();

      /** Gets the argument containing the base DN. */
      abstract DataFlow::Node getBaseDn();
    }
  }
}

/**
 * A data-flow node that escapes meta-characters, which could be used to prevent
 * injection attacks.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Escaping::Range` instead.
 */
class Escaping extends DataFlow::Node instanceof Escaping::Range {
  Escaping() {
    // escapes that don't have _both_ input/output defined are not valid
    exists(super.getAnInput()) and
    exists(super.getOutput())
  }

  /** Gets an input that will be escaped. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the escaped data. */
  DataFlow::Node getOutput() { result = super.getOutput() }

  /**
   * Gets the context that this function escapes for, such as `html`, or `url`.
   */
  string getKind() { result = super.getKind() }
}

/** Provides a class for modeling new escaping APIs. */
module Escaping {
  /**
   * A data-flow node that escapes meta-characters, which could be used to prevent
   * injection attacks.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Escaping` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that will be escaped. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the escaped data. */
    abstract DataFlow::Node getOutput();

    /**
     * Gets the context that this function escapes for.
     *
     * While kinds are represented as strings, this should not be relied upon. Use the
     * predicates in  the `Escaping` module, such as `getHtmlKind`.
     */
    abstract string getKind();
  }

  /** Gets the escape-kind for escaping a string so it can safely be included in HTML. */
  string getHtmlKind() { result = "html" }

  /** Gets the escape-kind for escaping a string so it can safely be included in XML. */
  string getXmlKind() { result = "xml" }

  /** Gets the escape-kind for escaping a string so it can safely be included in a regular expression. */
  string getRegexKind() { result = "regex" }

  /**
   * Gets the escape-kind for escaping a string so it can safely be used as a
   * distinguished name (DN) in an LDAP search.
   */
  string getLdapDnKind() { result = "ldap_dn" }

  /**
   * Gets the escape-kind for escaping a string so it can safely be used as a
   * filter in an LDAP search.
   */
  string getLdapFilterKind() { result = "ldap_filter" }
  // TODO: If adding an XML kind, update the modeling of the `MarkupSafe` PyPI package.
  //
  // Technically it claims to escape for both HTML and XML, but for now we don't have
  // anything that relies on XML escaping, so I'm going to defer deciding whether they
  // should be the same kind, or whether they deserve to be treated differently.
}

/**
 * An escape of a string so it can be safely included in
 * the body of an HTML element, for example, replacing `{}` in
 * `<p>{}</p>`.
 */
class HtmlEscaping extends Escaping {
  HtmlEscaping() { super.getKind() = Escaping::getHtmlKind() }
}

/**
 * An escape of a string so it can be safely included in
 * the body of an XML element, for example, replacing `&` and `<>` in
 * `<foo>&xxe;<foo>`.
 */
class XmlEscaping extends Escaping {
  XmlEscaping() { super.getKind() = Escaping::getXmlKind() }
}

/**
 * An escape of a string so it can be safely included in
 * the body of a regex.
 */
class RegexEscaping extends Escaping {
  RegexEscaping() { super.getKind() = Escaping::getRegexKind() }
}

/**
 * An escape of a string so it can be safely used as a distinguished name (DN)
 * in an LDAP search.
 */
class LdapDnEscaping extends Escaping {
  LdapDnEscaping() { super.getKind() = Escaping::getLdapDnKind() }
}

/**
 * An escape of a string so it can be safely used as a filter in an LDAP search.
 */
class LdapFilterEscaping extends Escaping {
  LdapFilterEscaping() { super.getKind() = Escaping::getLdapFilterKind() }
}

/**
 * A data-flow node that constructs a template in a templating engine.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TemplateConstruction::Range` instead.
 */
class TemplateConstruction extends DataFlow::Node instanceof TemplateConstruction::Range {
  /** Gets the argument that specifies the template source. */
  DataFlow::Node getSourceArg() { result = super.getSourceArg() }
}

/** Provides classes for modeling template construction APIs. */
module TemplateConstruction {
  /**
   * A data-flow node that constructs a template in a templating engine.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `TemplateConstruction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the template source. */
    abstract DataFlow::Node getSourceArg();
  }
}

/** Provides classes for modeling HTTP-related APIs. */
module Http {
  /** Gets an HTTP verb, in upper case */
  string httpVerb() { result in ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"] }

  /** Gets an HTTP verb, in lower case */
  string httpVerbLower() { result = httpVerb().toLowerCase() }

  /** Provides classes for modeling HTTP servers. */
  module Server {
    /**
     * A data-flow node that sets up a route on a server.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RouteSetup::Range` instead.
     */
    class RouteSetup extends DataFlow::Node instanceof RouteSetup::Range {
      /** Gets the URL pattern for this route, if it can be statically determined. */
      string getUrlPattern() { result = super.getUrlPattern() }

      /**
       * Gets a function that will handle incoming requests for this route, if any.
       *
       * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Function`.
       */
      Function getARequestHandler() { result = super.getARequestHandler() }

      /**
       * Gets a parameter that will receive parts of the url when handling incoming
       * requests for this route, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = super.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = super.getFramework() }
    }

    /** Provides a class for modeling new HTTP routing APIs. */
    module RouteSetup {
      /**
       * A data-flow node that sets up a route on a server.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RouteSetup` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the argument used to set the URL pattern. */
        abstract DataFlow::Node getUrlPatternArg();

        /** Gets the URL pattern for this route, if it can be statically determined. */
        string getUrlPattern() {
          exists(StringLiteral str |
            this.getUrlPatternArg().getALocalSource() = DataFlow::exprNode(str) and
            result = str.getText()
          )
        }

        /**
         * Gets a function that will handle incoming requests for this route, if any.
         *
         * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Function`.
         */
        abstract Function getARequestHandler();

        /**
         * Gets a parameter that will receive parts of the url when handling incoming
         * requests for this route, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this route setup. */
        abstract string getFramework();
      }
    }

    /**
     * A function that will handle incoming HTTP requests.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RequestHandler::Range` instead.
     */
    class RequestHandler extends Function instanceof RequestHandler::Range {
      /**
       * Gets a parameter that could receive parts of the url when handling incoming
       * requests, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = super.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = super.getFramework() }
    }

    /** Provides a class for modeling new HTTP request handlers. */
    module RequestHandler {
      /**
       * A function that will handle incoming HTTP requests.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RequestHandler` instead.
       *
       * Only extend this class if you can't provide a `RouteSetup`, since we handle that case automatically.
       */
      abstract class Range extends Function {
        /**
         * Gets a parameter that could receive parts of the url when handling incoming
         * requests, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this request handler. */
        abstract string getFramework();
      }
    }

    private class RequestHandlerFromRouteSetup extends RequestHandler::Range {
      RouteSetup rs;

      RequestHandlerFromRouteSetup() { this = rs.getARequestHandler() }

      override Parameter getARoutedParameter() {
        result = rs.getARoutedParameter() and
        result in [
            this.getArg(_), this.getArgByName(_), this.getVararg().(Parameter),
            this.getKwarg().(Parameter)
          ]
      }

      override string getFramework() { result = rs.getFramework() }
    }

    /** A parameter that will receive parts of the url when handling an incoming request. */
    private class RoutedParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
      RequestHandler handler;

      RoutedParameter() { this.getParameter() = handler.getARoutedParameter() }

      override string getSourceType() { result = handler.getFramework() + " RoutedParameter" }
    }

    /**
     * A data-flow node that creates a HTTP response on a server.
     *
     * Note: we don't require that this response must be sent to a client (a kind of
     * "if a tree falls in a forest and nobody hears it" situation).
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HttpResponse::Range` instead.
     */
    class HttpResponse extends DataFlow::Node instanceof HttpResponse::Range {
      /** Gets the data-flow node that specifies the body of this HTTP response. */
      DataFlow::Node getBody() { result = super.getBody() }

      /** Gets the mimetype of this HTTP response, if it can be statically determined. */
      string getMimetype() { result = super.getMimetype() }
    }

    /** Provides a class for modeling new HTTP response APIs. */
    module HttpResponse {
      /**
       * A data-flow node that creates a HTTP response on a server.
       *
       * Note: we don't require that this response must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the data-flow node that specifies the body of this HTTP response. */
        abstract DataFlow::Node getBody();

        /** Gets the data-flow node that specifies the content-type/mimetype of this HTTP response, if any. */
        abstract DataFlow::Node getMimetypeOrContentTypeArg();

        /** Gets the default mimetype that should be used if `getMimetypeOrContentTypeArg` has no results. */
        abstract string getMimetypeDefault();

        /** Gets the mimetype of this HTTP response, if it can be statically determined. */
        string getMimetype() {
          exists(StringLiteral str |
            this.getMimetypeOrContentTypeArg().getALocalSource() = DataFlow::exprNode(str) and
            result = str.getText().splitAt(";", 0)
          )
          or
          not exists(this.getMimetypeOrContentTypeArg()) and
          result = this.getMimetypeDefault()
        }
      }
    }

    /**
     * A data-flow node that creates a HTTP redirect response on a server.
     *
     * Note: we don't require that this redirect must be sent to a client (a kind of
     * "if a tree falls in a forest and nobody hears it" situation).
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HttpRedirectResponse::Range` instead.
     */
    class HttpRedirectResponse extends HttpResponse instanceof HttpRedirectResponse::Range {
      /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
      DataFlow::Node getRedirectLocation() { result = super.getRedirectLocation() }
    }

    /** Provides a class for modeling new HTTP redirect response APIs. */
    module HttpRedirectResponse {
      /**
       * A data-flow node that creates a HTTP redirect response on a server.
       *
       * Note: we don't require that this redirect must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends Http::Server::HttpResponse::Range {
        /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
        abstract DataFlow::Node getRedirectLocation();
      }
    }

    /**
     * A data-flow node that sets a header in an HTTP response.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `ResponseHeaderWrite::Range` instead.
     */
    class ResponseHeaderWrite extends DataFlow::Node instanceof ResponseHeaderWrite::Range {
      /**
       * Gets the argument containing the header name.
       */
      DataFlow::Node getNameArg() { result = super.getNameArg() }

      /**
       * Gets the argument containing the header value.
       */
      DataFlow::Node getValueArg() { result = super.getValueArg() }

      /**
       * Holds if newlines are accepted in the header name argument.
       */
      predicate nameAllowsNewline() { super.nameAllowsNewline() }

      /**
       * Holds if newlines are accepted in the header value argument.
       */
      predicate valueAllowsNewline() { super.valueAllowsNewline() }
    }

    /** Provides a class for modeling header writes on HTTP responses. */
    module ResponseHeaderWrite {
      /**
       *A data-flow node that sets a header in an HTTP response.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `ResponseHeaderWrite` instead.
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

        /**
         * Holds if newlines are accepted in the header name argument.
         */
        abstract predicate nameAllowsNewline();

        /**
         * Holds if newlines are accepted in the header value argument.
         */
        abstract predicate valueAllowsNewline();
      }
    }

    /**
     * A data-flow node that sets multiple headers in an HTTP response using a dict or a list of tuples.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `ResponseHeaderBulkWrite::Range` instead.
     */
    class ResponseHeaderBulkWrite extends DataFlow::Node instanceof ResponseHeaderBulkWrite::Range {
      /**
       * Gets the argument containing the headers dictionary.
       */
      DataFlow::Node getBulkArg() { result = super.getBulkArg() }

      /**
       * Holds if newlines are accepted in the header name argument.
       */
      predicate nameAllowsNewline() { super.nameAllowsNewline() }

      /**
       * Holds if newlines are accepted in the header value argument.
       */
      predicate valueAllowsNewline() { super.valueAllowsNewline() }
    }

    /** Provides a class for modeling bulk header writes on HTTP responses. */
    module ResponseHeaderBulkWrite {
      /**
       * A data-flow node that sets multiple headers in an HTTP response using a dict.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `ResponseHeaderBulkWrite` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets the argument containing the headers dictionary.
         */
        abstract DataFlow::Node getBulkArg();

        /**
         * Holds if newlines are accepted in the header name argument.
         */
        abstract predicate nameAllowsNewline();

        /**
         * Holds if newlines are accepted in the header value argument.
         */
        abstract predicate valueAllowsNewline();
      }
    }

    /** A key-value pair in a literal for a bulk header update, considered as a single header update. */
    private class HeaderBulkWriteDictLiteral extends Http::Server::ResponseHeaderWrite::Range instanceof Http::Server::ResponseHeaderBulkWrite
    {
      KeyValuePair item;

      HeaderBulkWriteDictLiteral() {
        exists(Dict dict | DataFlow::localFlow(DataFlow::exprNode(dict), super.getBulkArg()) |
          item = dict.getAnItem()
        )
      }

      override DataFlow::Node getNameArg() { result.asExpr() = item.getKey() }

      override DataFlow::Node getValueArg() { result.asExpr() = item.getValue() }

      override predicate nameAllowsNewline() {
        Http::Server::ResponseHeaderBulkWrite.super.nameAllowsNewline()
      }

      override predicate valueAllowsNewline() {
        Http::Server::ResponseHeaderBulkWrite.super.valueAllowsNewline()
      }
    }

    /** A tuple in a list for a bulk header update, considered as a single header update. */
    private class HeaderBulkWriteListLiteral extends Http::Server::ResponseHeaderWrite::Range instanceof Http::Server::ResponseHeaderBulkWrite
    {
      Tuple item;

      HeaderBulkWriteListLiteral() {
        exists(List list | DataFlow::localFlow(DataFlow::exprNode(list), super.getBulkArg()) |
          item = list.getAnElt()
        )
      }

      override DataFlow::Node getNameArg() { result.asExpr() = item.getElt(0) }

      override DataFlow::Node getValueArg() { result.asExpr() = item.getElt(1) }

      override predicate nameAllowsNewline() {
        Http::Server::ResponseHeaderBulkWrite.super.nameAllowsNewline()
      }

      override predicate valueAllowsNewline() {
        Http::Server::ResponseHeaderBulkWrite.super.valueAllowsNewline()
      }
    }

    /**
     * A data-flow node that sets a cookie in an HTTP response.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HTTP::CookieWrite::Range` instead.
     */
    class CookieWrite extends DataFlow::Node instanceof CookieWrite::Range {
      /**
       * Gets the argument, if any, specifying the raw cookie header.
       */
      DataFlow::Node getHeaderArg() { result = super.getHeaderArg() }

      /**
       * Gets the argument, if any, specifying the cookie name.
       */
      DataFlow::Node getNameArg() { result = super.getNameArg() }

      /**
       * Gets the argument, if any, specifying the cookie value.
       */
      DataFlow::Node getValueArg() { result = super.getValueArg() }

      /**
       * Holds if the `Secure` flag of the cookie is known to have a value of `b`.
       */
      predicate hasSecureFlag(boolean b) { super.hasSecureFlag(b) }

      /**
       * Holds if the `HttpOnly` flag of the cookie is known to have a value of `b`.
       */
      predicate hasHttpOnlyFlag(boolean b) { super.hasHttpOnlyFlag(b) }

      /**
       * Holds if the `SameSite` attribute of the cookie is known to have a value of `v`.
       */
      predicate hasSameSiteAttribute(CookieWrite::SameSiteValue v) { super.hasSameSiteAttribute(v) }
    }

    /**
     * A dataflow call node to a method that sets a cookie in an http response,
     * and has common keyword arguments `secure`, `httponly`, and `samesite` to set the attributes of the cookie.
     *
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
     */
    abstract class SetCookieCall extends CookieWrite::Range, DataFlow::CallCfgNode {
      override predicate hasSecureFlag(boolean b) {
        super.hasSecureFlag(b)
        or
        exists(DataFlow::Node arg, BooleanLiteral bool | arg = this.getArgByName("secure") |
          DataFlow::localFlow(DataFlow::exprNode(bool), arg) and
          b = bool.booleanValue()
        )
        or
        not exists(this.getArgByName("secure")) and
        not exists(this.getKwargs()) and
        b = false
      }

      override predicate hasHttpOnlyFlag(boolean b) {
        super.hasHttpOnlyFlag(b)
        or
        exists(DataFlow::Node arg, BooleanLiteral bool | arg = this.getArgByName("httponly") |
          DataFlow::localFlow(DataFlow::exprNode(bool), arg) and
          b = bool.booleanValue()
        )
        or
        not exists(this.getArgByName("httponly")) and
        not exists(this.getKwargs()) and
        b = false
      }

      override predicate hasSameSiteAttribute(CookieWrite::SameSiteValue v) {
        super.hasSameSiteAttribute(v)
        or
        exists(DataFlow::Node arg, StringLiteral str | arg = this.getArgByName("samesite") |
          DataFlow::localFlow(DataFlow::exprNode(str), arg) and
          (
            str.getText().toLowerCase() = "strict" and
            v instanceof CookieWrite::SameSiteStrict
            or
            str.getText().toLowerCase() = "lax" and
            v instanceof CookieWrite::SameSiteLax
            or
            str.getText().toLowerCase() = "none" and
            v instanceof CookieWrite::SameSiteNone
          )
        )
        or
        not exists(this.getArgByName("samesite")) and
        not exists(this.getKwargs()) and
        v instanceof CookieWrite::SameSiteLax // Lax is the default
      }
    }

    /** Provides a class for modeling new cookie writes on HTTP responses. */
    module CookieWrite {
      /**
       * A data-flow node that sets a cookie in an HTTP response.
       *
       * Note: we don't require that this redirect must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets the argument, if any, specifying the raw cookie header.
         */
        abstract DataFlow::Node getHeaderArg();

        /**
         * Gets the argument, if any, specifying the cookie name.
         */
        abstract DataFlow::Node getNameArg();

        /**
         * Gets the argument, if any, specifying the cookie value.
         */
        abstract DataFlow::Node getValueArg();

        /**
         * Holds if the `Secure` flag of the cookie is known to have a value of `b`.
         */
        predicate hasSecureFlag(boolean b) {
          exists(StringLiteral sl |
            // `sl` is likely a substring of the header
            TaintTracking::localTaint(DataFlow::exprNode(sl), this.getHeaderArg()) and
            sl.getText().regexpMatch("(?i).*;\\s*secure(;.*|\\s*)") and
            b = true
            or
            // `sl` is the entire header
            DataFlow::localFlow(DataFlow::exprNode(sl), this.getHeaderArg()) and
            not sl.getText().regexpMatch("(?i).*;\\s*secure(;.*|\\s*)") and
            b = false
          )
        }

        /**
         * Holds if the `HttpOnly` flag of the cookie is known to have a value of `b`.
         */
        predicate hasHttpOnlyFlag(boolean b) {
          exists(StringLiteral sl |
            // `sl` is likely a substring of the header
            TaintTracking::localTaint(DataFlow::exprNode(sl), this.getHeaderArg()) and
            sl.getText().regexpMatch("(?i).*;\\s*httponly(;.*|\\s*)") and
            b = true
            or
            // `sl` is the entire header
            DataFlow::localFlow(DataFlow::exprNode(sl), this.getHeaderArg()) and
            not sl.getText().regexpMatch("(?i).*;\\s*httponly(;.*|\\s*)") and
            b = false
          )
        }

        /**
         * Holds if the `SameSite` flag of the cookie is known to have a value of `v`.
         */
        predicate hasSameSiteAttribute(SameSiteValue v) {
          exists(StringLiteral sl |
            // `sl` is likely a substring of the header
            TaintTracking::localTaint(DataFlow::exprNode(sl), this.getHeaderArg()) and
            (
              sl.getText().regexpMatch("(?i).*;\\s*samesite=strict(;.*|\\s*)") and
              v instanceof SameSiteStrict
              or
              sl.getText().regexpMatch("(?i).*;\\s*samesite=lax(;.*|\\s*)") and
              v instanceof SameSiteLax
              or
              sl.getText().regexpMatch("(?i).*;\\s*samesite=none(;.*|\\s*)") and
              v instanceof SameSiteNone
            )
            or
            // `sl` is the entire header
            DataFlow::localFlow(DataFlow::exprNode(sl), this.getHeaderArg()) and
            not sl.getText().regexpMatch("(?i).*;\\s*samesite=(strict|lax|none)(;.*|\\s*)") and
            v instanceof SameSiteLax // Lax is the default
          )
        }
      }

      private newtype TSameSiteValue =
        TSameSiteStrict() or
        TSameSiteLax() or
        TSameSiteNone()

      /** A possible value for the SameSite attribute of a cookie. */
      class SameSiteValue extends TSameSiteValue {
        /** Gets a string representation of this value. */
        string toString() { none() }
      }

      /** A `Strict` value of the `SameSite` attribute. */
      class SameSiteStrict extends SameSiteValue, TSameSiteStrict {
        override string toString() { result = "Strict" }
      }

      /** A `Lax` value of the `SameSite` attribute. */
      class SameSiteLax extends SameSiteValue, TSameSiteLax {
        override string toString() { result = "Lax" }
      }

      /** A `None` value of the `SameSite` attribute. */
      class SameSiteNone extends SameSiteValue, TSameSiteNone {
        override string toString() { result = "None" }
      }
    }

    /** A write to a `Set-Cookie` header that sets a cookie directly. */
    private class CookieHeaderWrite extends CookieWrite::Range instanceof Http::Server::ResponseHeaderWrite
    {
      CookieHeaderWrite() {
        exists(StringLiteral str |
          str.getText().toLowerCase() = "set-cookie" and
          DataFlow::exprNode(str)
              .(DataFlow::LocalSourceNode)
              .flowsTo(this.(Http::Server::ResponseHeaderWrite).getNameArg())
        )
      }

      override DataFlow::Node getNameArg() { none() }

      override DataFlow::Node getHeaderArg() {
        result = this.(Http::Server::ResponseHeaderWrite).getValueArg()
      }

      override DataFlow::Node getValueArg() { none() }
    }

    /**
     * A data-flow node that enables or disables CORS
     * in a global manner.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `CorsMiddleware::Range` instead.
     */
    class CorsMiddleware extends DataFlow::Node instanceof CorsMiddleware::Range {
      /**
       * Gets the string corresponding to the middleware
       */
      string getMiddlewareName() { result = super.getMiddlewareName() }

      /**
       * Gets the dataflow node corresponding to the allowed CORS origins
       */
      DataFlow::Node getOrigins() { result = super.getOrigins() }

      /**
       * Gets the boolean value corresponding to if CORS credentials is enabled
       * (`true`) or disabled (`false`) by this node.
       */
      DataFlow::Node getCredentialsAllowed() { result = super.getCredentialsAllowed() }
    }

    /** Provides a class for modeling new CORS middleware APIs. */
    module CorsMiddleware {
      /**
       * A data-flow node that enables or disables Cross-site request forgery protection
       * in a global manner.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `CorsMiddleware` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets the name corresponding to the middleware
         */
        abstract string getMiddlewareName();

        /**
         * Gets the strings corresponding to the origins allowed by the cors policy
         */
        abstract DataFlow::Node getOrigins();

        /**
         * Gets the boolean value corresponding to if CORS credentials is enabled
         * (`true`) or disabled (`false`) by this node.
         */
        abstract DataFlow::Node getCredentialsAllowed();
      }
    }

    /**
     * A data-flow node that enables or disables Cross-site request forgery protection
     * in a global manner.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `CsrfProtectionSetting::Range` instead.
     */
    class CsrfProtectionSetting extends DataFlow::Node instanceof CsrfProtectionSetting::Range {
      /**
       * Gets the boolean value corresponding to if CSRF protection is enabled
       * (`true`) or disabled (`false`) by this node.
       */
      boolean getVerificationSetting() { result = super.getVerificationSetting() }
    }

    /** Provides a class for modeling new CSRF protection setting APIs. */
    module CsrfProtectionSetting {
      /**
       * A data-flow node that enables or disables Cross-site request forgery protection
       * in a global manner.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `CsrfProtectionSetting` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets the boolean value corresponding to if CSRF protection is enabled
         * (`true`) or disabled (`false`) by this node.
         */
        abstract boolean getVerificationSetting();
      }
    }

    /**
     * A data-flow node that enables or disables Cross-site request forgery protection
     * for a specific part of an application.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `CsrfLocalProtectionSetting::Range` instead.
     */
    class CsrfLocalProtectionSetting extends DataFlow::Node instanceof CsrfLocalProtectionSetting::Range
    {
      /**
       * Gets a request handler whose CSRF protection is changed.
       */
      Function getRequestHandler() { result = super.getRequestHandler() }

      /** Holds if CSRF protection is enabled by this setting */
      predicate csrfEnabled() { super.csrfEnabled() }
    }

    /** Provides a class for modeling new CSRF protection setting APIs. */
    module CsrfLocalProtectionSetting {
      /**
       * A data-flow node that enables or disables Cross-site request forgery protection
       * for a specific part of an application.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `CsrfLocalProtectionSetting` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets a request handler whose CSRF protection is changed.
         */
        abstract Function getRequestHandler();

        /** Holds if CSRF protection is enabled by this setting */
        abstract predicate csrfEnabled();
      }
    }
  }

  import semmle.python.internal.ConceptsShared::Http::Client as Client
  // TODO: investigate whether we should treat responses to client requests as
  // remote-flow-sources in general.
}

/**
 * Provides models for cryptographic things.
 *
 * Note: The `CryptographicAlgorithm` class currently doesn't take weak keys into
 * consideration for the `isWeak` member predicate. So RSA is always considered
 * secure, although using a low number of bits will actually make it insecure. We plan
 * to improve our libraries in the future to more precisely capture this aspect.
 */
module Cryptography {
  /** Provides models for public-key cryptography, also called asymmetric cryptography. */
  module PublicKey {
    /**
     * A data-flow node that generates a new key-pair for use with public-key cryptography.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `KeyGeneration::Range` instead.
     */
    class KeyGeneration extends DataFlow::Node instanceof KeyGeneration::Range {
      /** Gets the name of the cryptographic algorithm (for example `"RSA"` or `"AES"`). */
      string getName() { result = super.getName() }

      /** Gets the argument that specifies the size of the key in bits, if available. */
      DataFlow::Node getKeySizeArg() { result = super.getKeySizeArg() }

      /**
       * Gets the size of the key generated (in bits), as well as the `origin` that
       * explains how we obtained this specific key size.
       */
      int getKeySizeWithOrigin(DataFlow::Node origin) {
        result = super.getKeySizeWithOrigin(origin)
      }

      /** Gets the minimum key size (in bits) for this algorithm to be considered secure. */
      int minimumSecureKeySize() { result = super.minimumSecureKeySize() }
    }

    /** Provides classes for modeling new key-pair generation APIs. */
    module KeyGeneration {
      /** Gets a back-reference to the keysize argument `arg` that was used to generate a new key-pair. */
      private DataFlow::TypeTrackingNode keysizeBacktracker(
        DataFlow::TypeBackTracker t, DataFlow::Node arg
      ) {
        t.start() and
        arg = any(KeyGeneration::Range r).getKeySizeArg() and
        result = arg.getALocalSource()
        or
        exists(DataFlow::TypeBackTracker t2 | result = keysizeBacktracker(t2, arg).backtrack(t2, t))
      }

      /** Gets a back-reference to the keysize argument `arg` that was used to generate a new key-pair. */
      DataFlow::LocalSourceNode keysizeBacktracker(DataFlow::Node arg) {
        result = keysizeBacktracker(DataFlow::TypeBackTracker::end(), arg)
      }

      /**
       * A data-flow node that generates a new key-pair for use with public-key cryptography.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `KeyGeneration` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the name of the cryptographic algorithm (for example `"RSA"`). */
        abstract string getName();

        /** Gets the argument that specifies the size of the key in bits, if available. */
        abstract DataFlow::Node getKeySizeArg();

        /**
         * Gets the size of the key generated (in bits), as well as the `origin` that
         * explains how we obtained this specific key size.
         */
        int getKeySizeWithOrigin(DataFlow::Node origin) {
          origin = keysizeBacktracker(this.getKeySizeArg()) and
          result = origin.asExpr().(IntegerLiteral).getValue()
        }

        /** Gets the minimum key size (in bits) for this algorithm to be considered secure. */
        abstract int minimumSecureKeySize();
      }

      /** A data-flow node that generates a new RSA key-pair. */
      abstract class RsaRange extends Range {
        final override string getName() { result = "RSA" }

        final override int minimumSecureKeySize() { result = minSecureKeySizeRsa() }
      }

      /** A data-flow node that generates a new DSA key-pair. */
      abstract class DsaRange extends Range {
        final override string getName() { result = "DSA" }

        final override int minimumSecureKeySize() { result = minSecureKeySizeDsa() }
      }

      /** A data-flow node that generates a new ECC key-pair. */
      abstract class EccRange extends Range {
        final override string getName() { result = "ECC" }

        final override int minimumSecureKeySize() { result = minSecureKeySizeEcc() }
      }
    }
  }

  import semmle.python.internal.ConceptsShared::Cryptography
}
