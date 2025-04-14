/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import javascript
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
   *
   * See
   * - https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst
   * - https://github.com/github/codeql/blob/main/shared/threat-models/ext/threat-model-grouping.model.yml
   */
  string getThreatModel() { result = super.getThreatModel() }

  /** Gets a string that describes the type of this threat-model source. */
  string getSourceType() { result = super.getSourceType() }

  /**
   * Holds if this is a source of data that is specific to the web browser environment.
   */
  predicate isClientSideSource() { super.isClientSideSource() }
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

    /**
     * Holds if this is a source of data that is specific to the web browser environment.
     */
    predicate isClientSideSource() { this.getThreatModel() = "view-component-input" }
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
 * A data flow node that executes an operating system command,
 * for instance by spawning a new process.
 */
abstract class SystemCommandExecution extends DataFlow::Node {
  /** Gets an argument to this execution that specifies the command. */
  abstract DataFlow::Node getACommandArgument();

  /** Holds if a shell interprets `arg`. */
  predicate isShellInterpreted(DataFlow::Node arg) { none() }

  /**
   * Gets an argument to this command execution that specifies the argument list
   * to the command.
   */
  DataFlow::Node getArgumentList() { none() }

  /** Holds if the command execution happens synchronously. */
  abstract predicate isSync();

  /**
   * Gets the data-flow node (if it exists) for an options argument.
   */
  abstract DataFlow::Node getOptionsArg();
}

/**
 * A data flow node that performs a file system access (read, write, copy, permissions, stats, etc).
 */
abstract class FileSystemAccess extends DataFlow::Node {
  /** Gets an argument to this file system access that is interpreted as a path. */
  abstract DataFlow::Node getAPathArgument();

  /**
   * Gets an argument to this file system access that is interpreted as a root folder
   * in which the path arguments are constrained.
   *
   * In other words, if a root argument is provided, the underlying file access does its own
   * sanitization to prevent the path arguments from traversing outside the root folder.
   */
  DataFlow::Node getRootPathArgument() { none() }

  /**
   * Holds if this file system access will reject paths containing upward navigation
   * segments (`../`).
   *
   * `argument` should refer to the relevant path argument or root path argument.
   */
  predicate isUpwardNavigationRejected(DataFlow::Node argument) { none() }
}

/**
 * A data flow node that reads data from the file system.
 */
abstract class FileSystemReadAccess extends FileSystemAccess {
  /** Gets a node that represents data from the file system. */
  abstract DataFlow::Node getADataNode();
}

/**
 * A FileSystemReadAccess seen as a ThreatModelSource.
 */
private class FileSystemReadAccessAsThreatModelSource extends ThreatModelSource::Range {
  FileSystemReadAccessAsThreatModelSource() {
    this = any(FileSystemReadAccess access).getADataNode()
  }

  override string getThreatModel() { result = "file" }

  override string getSourceType() { result = "FileSystemReadAccess" }
}

/**
 * A data flow node that writes data to the file system.
 */
abstract class FileSystemWriteAccess extends FileSystemAccess {
  /** Gets a node that represents data to be written to the file system. */
  abstract DataFlow::Node getADataNode();
}

/**
 * A data flow node that contains a file name or an array of file names from the local file system.
 */
abstract class FileNameSource extends DataFlow::Node { }

/**
 * A data flow node that performs a database access.
 */
abstract class DatabaseAccess extends DataFlow::Node {
  /** Gets an argument to this database access that is interpreted as a query. */
  abstract DataFlow::Node getAQueryArgument();

  /** Gets a node to which a result of the access may flow. */
  DataFlow::Node getAResult() {
    none() // Overridden in subclass
  }
}

/**
 * A DatabaseAccess seen as a ThreatModelSource.
 */
private class DatabaseAccessAsThreatModelSource extends ThreatModelSource::Range {
  DatabaseAccessAsThreatModelSource() { this = any(DatabaseAccess access).getAResult() }

  override string getThreatModel() { result = "database" }

  override string getSourceType() { result = "DatabaseAccess" }
}

/**
 * A data flow node that reads persistent data.
 */
abstract class PersistentReadAccess extends DataFlow::Node {
  /**
   * Gets a corresponding persistent write, if any.
   */
  abstract PersistentWriteAccess getAWrite();
}

/**
 * A data flow node that writes persistent data.
 */
abstract class PersistentWriteAccess extends DataFlow::Node {
  /**
   * Gets the data flow node corresponding to the written value.
   */
  abstract DataFlow::Node getValue();
}

/**
 * Provides models for cryptographic things.
 */
module Cryptography {
  private import semmle.javascript.internal.ConceptsShared::Cryptography as SC

  /**
   * A data-flow node that is an application of a cryptographic algorithm. For example,
   * encryption, decryption, signature-validation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `CryptographicOperation::Range` instead.
   */
  class CryptographicOperation extends SC::CryptographicOperation instanceof CryptographicOperation::Range
  { }

  class EncryptionAlgorithm = SC::EncryptionAlgorithm;

  class HashingAlgorithm = SC::HashingAlgorithm;

  class PasswordHashingAlgorithm = SC::PasswordHashingAlgorithm;

  module CryptographicOperation = SC::CryptographicOperation;

  class BlockMode = SC::BlockMode;

  class CryptographicAlgorithm = SC::CryptographicAlgorithm;
}
