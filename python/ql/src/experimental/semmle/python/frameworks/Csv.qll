/**
 * Provides classes modeling security-relevant aspects of the `csv` PyPI package.
 * See https://docs.python.org/3/library/csv.html
 */

private import python
private import semmle.python.ApiGraphs
private import experimental.semmle.python.Concepts

/**
 * Provides models for the `csv` PyPI package.
 *
 * See
 * - https://docs.python.org/3/library/csv.html
 */
private module Csv {
  private module Writer {
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `csv.writer` or `csv.DictWriter`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
      ClassInstantiation() {
        this = API::moduleImport("csv").getMember(["writer", "DictWriter"]).getACall()
      }
    }

    /** Gets a reference to an `csv.writer` or `csv.DictWriter` instance. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an `csv.writer` or `csv.DictWriter` instance. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * See:
     * - https://docs.python.org/3/library/csv.html#csvwriter.writerow
     * - https://docs.python.org/3/library/csv.html#csvwriter.writerows
     */
    private class CsvWriteCall extends CsvWriter::Range, DataFlow::CallCfgNode {
      string methodName;

      CsvWriteCall() {
        methodName in ["writerow", "writerows"] and
        this.(DataFlow::MethodCallNode).calls(Writer::instance(), methodName)
      }

      override DataFlow::Node getAnInput() {
        result = this.getArg(0)
        or
        methodName = "writerow" and
        result = this.getArgByName("row")
        or
        methodName = "writerows" and
        result = this.getArgByName("rows")
      }
    }

    /**
     * See: https://docs.python.org/3/library/csv.html#csv.DictWriter
     */
    private class DictWriterInstance extends CsvWriter::Range, DataFlow::CallCfgNode {
      DictWriterInstance() { this = API::moduleImport("csv").getMember("DictWriter").getACall() }

      override DataFlow::Node getAnInput() {
        result in [this.getArg(1), this.getArgByName("fieldnames")]
      }
    }
  }
}
