/**
 * Provides an extension point for for modeling sensitive data, such as secrets, certificates, or passwords.
 * Sensitive data can be interesting to use as data-flow sources in security queries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
// Need to import since frameworks can extend `RemoteFlowSource::Range`
private import semmle.python.Frameworks
private import semmle.python.Concepts
private import semmle.python.security.SensitiveData as OldSensitiveData

/**
 * A data flow source of sensitive data, such as secrets, certificates, or passwords.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SensitiveDataSource::Range` instead.
 */
class SensitiveDataSource extends DataFlow::Node {
  SensitiveDataSource::Range range;

  SensitiveDataSource() { this = range }

  /**
   * INTERNAL: Do not use.
   *
   * This will be rewritten to have better types soon, and therefore should only be used internally until then.
   *
   * Gets the classification of the sensitive data.
   */
  string getClassification() { result = range.getClassification() }
}

/** Provides a class for modeling new sources of sensitive data, such as secrets, certificates, or passwords. */
module SensitiveDataSource {
  /**
   * A data flow source of sensitive data, such as secrets, certificates, or passwords.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SensitiveDataSource` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * INTERNAL: Do not use.
     *
     * This will be rewritten to have better types soon, and therefore should only be used internally until then.
     *
     * Gets the classification of the sensitive data.
     */
    abstract string getClassification();
  }
}

private class PortOfOldModeling extends SensitiveDataSource::Range {
  OldSensitiveData::SensitiveData::Source oldSensitiveSource;

  PortOfOldModeling() { this.asCfgNode() = oldSensitiveSource }

  override string getClassification() {
    exists(OldSensitiveData::SensitiveData classification |
      oldSensitiveSource.isSourceOf(classification)
    |
      classification = "sensitive.data." + result
    )
  }
}
