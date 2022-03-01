/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import javascript

/** DEPRECATED: use `CommandExecution::Range` instead. */
deprecated class SystemCommandExecution = CommandExecution::Range;

/**
 * A data flow node that executes an operating system command,
 * for instance by spawning a new process.
 */
class CommandExecution extends DataFlow::Node instanceof CommandExecution::Range {
  /** Gets an argument to this execution that specifies the command or an argument to it. */
  DataFlow::Node getACommandArgument() { result = super.getACommandArgument() }

  /** Holds if a shell interprets `arg`. */
  predicate isShellInterpreted(DataFlow::Node arg) { super.isShellInterpreted(arg) }

  /**
   * Gets an argument to this command execution that specifies the argument list
   * to the command.
   */
  DataFlow::Node getArgumentList() { result = super.getArgumentList() }

  /** Holds if the command execution happens synchronously. */
  predicate isSync() { super.isSync() }

  /**
   * Gets the data-flow node (if it exists) for an options argument.
   */
  DataFlow::Node getOptionsArg() { result = super.getOptionsArg() }
}

/** Provides a class for modeling new operating system command APIs. */
module CommandExecution {
  /**
   * A data flow node that executes an operating system command, for instance by spawning a new
   * process.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CommandExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an argument to this execution that specifies the command or an argument to it. */
    abstract DataFlow::Node getACommandArgument();

    /** Holds if a shell interprets `arg`. */
    predicate isShellInterpreted(DataFlow::Node arg) { none() }

    /**
     * Gets an argument to this command execution that specifies the argument list
     * to the command.
     */
    DataFlow::Node getArgumentList() { none() }

    /** Holds if the command execution happens synchronously. */
    predicate isSync() { none() }

    /**
     * Gets the data-flow node (if it exists) for an options argument.
     */
    DataFlow::Node getOptionsArg() { none() }
  }
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
