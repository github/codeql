/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import javascript

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
