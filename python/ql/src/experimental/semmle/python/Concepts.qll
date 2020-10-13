/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import python
private import experimental.dataflow.DataFlow
private import experimental.semmle.python.Frameworks

/**
 * A data-flow node that executes an operating system command,
 * for instance by spawning a new process.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SystemCommandExecution::Range` instead.
 */
class SystemCommandExecution extends DataFlow::Node {
  SystemCommandExecution::Range self;

  SystemCommandExecution() { this = self }

  /** Gets the argument that specifies the command to be executed. */
  DataFlow::Node getCommand() { result = self.getCommand() }
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
  }
}

/**
 * A function that decodes data from a binary or textual format.
 * Doing so should normally preserve taint, but it can also be a problem
 * in itself, e.g. if it performs deserialization in a potentially unsafe way.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `UnmarshalingFunction::Range` instead.
 */
class UnmarshalingFunction extends DataFlow::Node {
  UnmarshalingFunction::Range self;

  UnmarshalingFunction() { this = self }

  /** Holds if this call is unsafe, e.g. if it may execute arbitrary code. */
  predicate unsafe() { self.unsafe() }

  /** Gets an input that is decoded by this function. */
  DataFlow::Node getAnInput() { result = self.getAnInput() }

  /** Gets the output that contains the decoded data produced by this function. */
  DataFlow::Node getOutput() { result = self.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = self.getFormat() }
}

/** Provides a class for modeling new unmarshaling/decoding/deserialization functions. */
module UnmarshalingFunction {
  /**
   * A function that decodes data from a binary or textual format.
   * Doing so should normally preserve taint, but it can oalso be a problem
   * in itself, e.g. if it performs deserialization in a potentially unsafe way.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `UnmarshalingFunction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Holds if this call is unsafe, e.g. if it may execute arbitrary code. */
    abstract predicate unsafe();

    /** Gets an input that is decoded by this function. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the decoded data produced by this function. */
    abstract DataFlow::Node getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}
