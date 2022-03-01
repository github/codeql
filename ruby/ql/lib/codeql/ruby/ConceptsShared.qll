/**
 * Provides Concepts which are shared across languages. See `Concepts.qll` for details.
 */

private import ConceptsImports

/** DEPRECATED: use `FileAccess::Range` instead. */
deprecated class FileSystemAccess = FileAccess::Range;

/**
 * A data flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileAccess::Range` instead.
 */
class FileAccess extends DataFlow::Node instanceof FileAccess::Range {
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
module FileAccess {
  /**
   * A data-flow node that performs a file system access, including reading and writing data,
   * creating and deleting files and folders, checking and updating permissions, and so on.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileAccess` instead.
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

/** DEPRECATED: use `FileReadAccess::Range` instead. */
deprecated class FileSystemReadAccess = FileReadAccess::Range;

/**
 * A data flow node that reads data from the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileReadAccess::Range` instead.
 */
class FileReadAccess extends FileAccess instanceof FileReadAccess::Range {
  /**
   * Gets a node that represents data read from the file system access.
   */
  DataFlow::Node getADataNode() { result = FileReadAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system reads. */
module FileReadAccess {
  /**
   * A data flow node that reads data from the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileReadAccess` instead.
   */
  abstract class Range extends FileAccess::Range {
    /**
     * Gets a node that represents data read from the file system.
     */
    abstract DataFlow::Node getADataNode();
  }
}

/** DEPRECATED: use `FileWriteAccess::Range` instead. */
deprecated class FileSystemWriteAccess = FileWriteAccess::Range;

/**
 * A data flow node that writes data to the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileWriteAccess::Range` instead.
 */
class FileWriteAccess extends FileAccess instanceof FileWriteAccess::Range {
  /**
   * Gets a node that represents data written to the file system by this access.
   */
  DataFlow::Node getADataNode() { result = FileWriteAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system writes. */
module FileWriteAccess {
  /**
   * A data flow node that writes data to the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileWriteAccess` instead.
   */
  abstract class Range extends FileAccess::Range {
    /**
     * Gets a node that represents data written to the file system by this access.
     */
    abstract DataFlow::Node getADataNode();
  }
}
