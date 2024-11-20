/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import codeql.rust.dataflow.DataFlow
private import codeql.threatmodels.ThreatModels
private import codeql.rust.Frameworks

/**
 * A data flow source for a specific threat-model.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `ThreatModelSource::Range` instead.
 */
final class ThreatModelSource = ThreatModelSource::Range;

/**
 * Provides a class for modeling new sources for specific threat-models.
 */
module ThreatModelSource {
  /**
   * A data flow source, for a specific threat-model.
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

    /**
     * Gets a string that describes the type of this threat-model source.
     */
    abstract string getSourceType();
  }
}

/**
 * A data flow source that is enabled in the current threat model configuration.
 */
class ActiveThreatModelSource extends ThreatModelSource {
  ActiveThreatModelSource() { currentThreatModel(this.getThreatModel()) }
}

/**
 * A data flow source corresponding to the program's command line arguments or path.
 */
class CommandLineArgsSource extends ThreatModelSource instanceof CommandLineArgsSource::Range { }

module CommandLineArgsSource {
  abstract class Range extends ThreatModelSource::Range {
    override string getThreatModel() { result = "commandargs" }

    override string getSourceType() { result = "CommandLineArgs" }
  }
}

/**
 * A data flow source corresponding to the program's environment.
 */
class EnvironmentSource extends ThreatModelSource instanceof EnvironmentSource::Range { }

module EnvironmentSource {
  abstract class Range extends ThreatModelSource::Range {
    override string getThreatModel() { result = "environment" }

    override string getSourceType() { result = "EnvironmentSource" }
  }
}

/**
 * A data flow source for remote (network) data.
 */
class RemoteSource extends ThreatModelSource instanceof RemoteSource::Range { }

module RemoteSource {
  abstract class Range extends ThreatModelSource::Range {
    override string getThreatModel() { result = "remote" }

    override string getSourceType() { result = "RemoteSource" }
  }
}

/**
 * A data-flow node that constructs a SQL statement.
 *
 * Often, it is worthy of an alert if a SQL statement is constructed such that
 * executing it would be a security risk.
 *
 * If it is important that the SQL statement is executed, use `SqlExecution`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlConstruction::Range` instead.
 */
final class SqlConstruction = SqlConstruction::Range;

/**
 * Provides a class for modeling new SQL execution APIs.
 */
module SqlConstruction {
  /**
   * A data-flow node that constructs a SQL statement.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument that specifies the SQL statements to be constructed.
     */
    abstract DataFlow::Node getSql();
  }
}

/**
 * A data-flow node that executes SQL statements.
 *
 * If the context of interest is such that merely constructing a SQL statement
 * would be valuable to report, consider using `SqlConstruction`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlExecution::Range` instead.
 */
final class SqlExecution = SqlExecution::Range;

/**
 * Provides a class for modeling new SQL execution APIs.
 */
module SqlExecution {
  /**
   * A data-flow node that executes SQL statements.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument that specifies the SQL statements to be executed.
     */
    abstract DataFlow::Node getSql();
  }
}

/**
 * A data-flow node that performs SQL sanitization.
 */
final class SqlSanitization = SqlSanitization::Range;

/**
 * Provides a class for modeling new SQL sanitization APIs.
 */
module SqlSanitization {
  /**
   * A data-flow node that performs SQL sanitization.
   */
  abstract class Range extends DataFlow::Node { }
}
