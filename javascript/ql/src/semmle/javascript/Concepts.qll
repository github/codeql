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

  /**
   * Gets an argument to this command execution that specifies the argument list
   * to the command.
   */
  DataFlow::Node getArgumentList() { none() }
}

/**
 * A data flow node that performs a file system access.
 */
abstract class FileSystemAccess extends DataFlow::Node {
  /** Gets an argument to this file system access that is interpreted as a path. */
  abstract DataFlow::Node getAPathArgument();
}

/**
 * A data flow node that contains a file name or an array of file names from the local file system.
 */
abstract class FileNameSource extends DataFlow::Node {

}

/**
 * A data flow node that performs a database access.
 */
abstract class DatabaseAccess extends DataFlow::Node {
  /** Gets an argument to this database access that is interpreted as a query. */
  abstract DataFlow::Node getAQueryArgument();
}
