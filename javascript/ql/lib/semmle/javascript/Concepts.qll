/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import javascript

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
