/** 
 * Provides Taint tracking configuration for reasoning about file access taint flow to http post body 
 */
import javascript
import semmle.javascript.frameworks.HTTP

module FileAccessToHttpDataFlow {
  /**
   * A data flow source for reasoning about file access to http post body flow vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for reasoning about file access to http post body flow vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for reasoning about file access to http post body flow vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about file access to http post body flow vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "FileAccessToHttpDataFlow" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
    
    /** additional taint step that taints an object wrapping a source */
    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      (
          pred = DataFlow::valueNode(_) or
          pred = DataFlow::parameterNode(_) or
          pred instanceof DataFlow::PropRead
      ) and
      exists (DataFlow::PropWrite pwr |
        succ = pwr.getBase() and
        pred = pwr.getRhs()
      )
    }
  }

  /** A source is a file access parameter, as in readFromFile(buffer). */
  private class FileAccessArgumentAsSource extends Source {
    FileAccessArgumentAsSource() {  
      exists(FileSystemReadAccess src |
        this = src.getDataNode().getALocalSource()
      )
    }
  }

  /** Sink is any parameter or argument that evaluates to a parameter ot a function or call that sets Http Body on a request */ 
  private class HttpRequestBodyAsSink extends Sink {
    HttpRequestBodyAsSink () {
      this instanceof HTTP::RequestBody
    }
  }
}