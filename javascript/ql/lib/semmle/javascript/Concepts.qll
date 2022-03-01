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
 * A data flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemAccess::Range` instead.
 */
class FileSystemAccess extends DataFlow::Node instanceof FileSystemAccess::Range {
  /** Gets an argument to this file system access that is interpreted as a path. */
  DataFlow::Node getAPathArgument() { result = super.getAPathArgument() }

  /**
   * Gets an argument to this file system access that is interpreted as a root folder
   * in which the path arguments are constrained.
   *
   * In other words, if a root argument is provided, the underlying file access does its own
   * sanitization to prevent the path arguments from traversing outside the root folder.
   */
  DataFlow::Node getRootPathArgument() { result = super.getRootPathArgument() }

  /**
   * Holds if this file system access will reject paths containing upward navigation
   * segments (`../`).
   *
   * `argument` should refer to the relevant path argument or root path argument.
   */
  predicate isUpwardNavigationRejected(DataFlow::Node argument) {
    super.isUpwardNavigationRejected(argument)
  }
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
}

/**
 * A data flow node that reads data from the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemReadAccess::Range` instead.
 */
class FileSystemReadAccess extends FileSystemAccess instanceof FileSystemReadAccess::Range {
  /**
   * Gets a node that represents data read from the file system access.
   */
  DataFlow::Node getADataNode() { result = FileSystemReadAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system reads. */
module FileSystemReadAccess {
  /**
   * A data flow node that reads data from the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemReadAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data read from the file system.
     */
    abstract DataFlow::Node getADataNode();
  }
}

/**
 * A data flow node that writes data to the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemWriteAccess::Range` instead.
 */
class FileSystemWriteAccess extends FileSystemAccess instanceof FileSystemWriteAccess::Range {
  /** Gets a node that represents data to be written to the file system. */
  DataFlow::Node getADataNode() { result = FileSystemWriteAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system writes. */
module FileSystemWriteAccess {
  /**
   * A data flow node that writes data to the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemWriteAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data written to the file system by this access.
     */
    abstract DataFlow::Node getADataNode();
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
