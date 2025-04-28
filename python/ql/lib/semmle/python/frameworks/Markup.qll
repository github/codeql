/**
 * Provides classes modeling security-relevant aspects of the hypothetical `markup` PyPI package
 * (imported as `markup`)
 *
 * This models parsing functions that may process untrusted input.
 */

 private import python
 private import semmle.python.dataflow.new.DataFlow
 private import semmle.python.Concepts
 private import semmle.python.ApiGraphs
 
 private module Markup {
   /**
    * A call to any of the parsing functions in `markup` (`parse`, `parse_document`,
    * `unsafe_parse`, `unsafe_parse_document`, `safe_parse`, `safe_parse_document`)
    *
    * These functions may be unsafe if they parse untrusted markup content.
    */
   private class MarkupParseCall extends Decoding::Range, DataFlow::CallCfgNode {
     override CallNode node;
     string func_name;
 
     MarkupParseCall() {
       func_name in [
           "parse", "parse_document", "unsafe_parse", "unsafe_parse_document",
           "safe_parse", "safe_parse_document", "div", "page"
         ] and
       this = API::moduleImport("markup").getMember(func_name).getACall()
     }
 
     /**
      * Determine whether this function call may unsafely execute input data.
      *
      * `unsafe_parse`, `unsafe_parse_document`, and `parse`, `parse_document` without secure settings
      * are considered unsafe.
      */
     override predicate mayExecuteInput() {
       func_name in ["unsafe_parse", "unsafe_parse_document"]
       or
       func_name in ["parse", "parse_document"] and
       // If no safe mode argument is set, assume unsafe
       not exists(DataFlow::Node mode_arg |
         mode_arg in [this.getArg(1), this.getArgByName("mode")] |
           mode_arg =
             API::moduleImport("markup")
                 .getMember(["SafeMode", "StrictMode"])
                 .getAValueReachableFromSource()
       )
     }
 
     override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("input")] }
 
     override DataFlow::Node getOutput() { result = this }
 
     override string getFormat() { result = "Markup" }
   }
 }
