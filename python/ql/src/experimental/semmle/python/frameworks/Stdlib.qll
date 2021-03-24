/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts

/** Provides models for the Python standard library. */
private module Stdlib {
  // ---------------------------------------------------------------------------
  // re
  // ---------------------------------------------------------------------------
  private module Re {

    /** Gets a reference to the `re` module. */
    private DataFlow::Node re(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importNode("re")
      or
      exists(DataFlow::TypeTracker t2 | result = re(t2).track(t2, t))
    }

    /** Gets a reference to the `re` module. */
    DataFlow::Node re() { result = re(DataFlow::TypeTracker::end()) }

    /**
     * Gets a reference to the attribute `attr_name` of the `re` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node re_attr(DataFlow::TypeTracker t, string attr_name) {
      attr_name in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn", "compile"] and
      (
        t.start() and
        result = DataFlow::importNode("re" + "." + attr_name)
        or
        t.startInAttr(attr_name) and
        result = re()
      )
      or
      // Due to bad performance when using normal setup with `re_attr(t2, attr_name).track(t2, t)`
      // we have inlined that code and forced a join
      exists(DataFlow::TypeTracker t2 |
        exists(DataFlow::StepSummary summary |
          re_attr_first_join(t2, attr_name, result, summary) and
          t = t2.append(summary)
        )
      )
    }

    pragma[nomagic]
    private predicate re_attr_first_join(
      DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(re_attr(t2, attr_name), res, summary)
    }

    /**
     * Gets a reference to the attribute `attr_name` of the `re` module.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node re_attr(string attr_name) {
      result = re_attr(DataFlow::TypeTracker::end(), attr_name)
    }

    /**
     * Gets a reference to any `attr_name` of the `re` module that immediately executes an expression.
     * WARNING: Only holds for a few predefined attributes.
     */
    private DataFlow::Node re_exec_attr() {
      exists(string attr_name |
        attr_name in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn"] and
        result = re_attr(DataFlow::TypeTracker::end(), attr_name)
      )
    }

    /**
     * A call to `re.match`
     * See https://docs.python.org/3/library/re.html#re.match
     */
    private class ReMatchCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReMatchCall() { node.getFunction() = re_attr("match").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.fullmatch`
     * See https://docs.python.org/3/library/re.html#re.fullmatch
     */
    private class ReFullMatchCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReFullMatchCall() { node.getFunction() = re_attr("fullmatch").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.search`
     * See https://docs.python.org/3/library/re.html#re.search
     */
    private class ReSearchCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReSearchCall() { node.getFunction() = re_attr("search").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.split`
     * See https://docs.python.org/3/library/re.html#re.split
     */
    private class ReSplitCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReSplitCall() { node.getFunction() = re_attr("split").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.findall`
     * See https://docs.python.org/3/library/re.html#re.findall
     */
    private class ReFindAllCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReFindAllCall() { node.getFunction() = re_attr("findall").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.finditer`
     * See https://docs.python.org/3/library/re.html#re.finditer
     */
    private class ReFindIterCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReFindIterCall() { node.getFunction() = re_attr("finditer").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.sub`
     * See https://docs.python.org/3/library/re.html#re.sub
     */
    private class ReSubCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReSubCall() { node.getFunction() = re_attr("sub").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.subn`
     * See https://docs.python.org/3/library/re.html#re.subn
     */
    private class ReSubNCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReSubNCall() { node.getFunction() = re_attr("subn").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { result = node.getNode().getFunc().(Attribute) }
    }

    /**
     * A call to `re.compile`
     * See https://docs.python.org/3/library/re.html#re.match
     */
    private class ReCompileCall extends RegexExecution::Range, DataFlow::CfgNode {
      override CallNode node;

      ReCompileCall() { node.getFunction() = re_attr("compile").asCfgNode() }

      override DataFlow::Node getRegexNode() { result.asCfgNode() = node.getArg(0) }
      override Attribute getRegexMethod() { 
        exists (DataFlow::AttrRead reMethod |
          reMethod = re_exec_attr() and
          node.getFunction() = reMethod.getObject().getALocalSource().asCfgNode() and
          result = reMethod.asExpr().(Attribute)
        )
       }
    }

    /** 
     * A class for modeling expressions immediately executing a regular expression.
     * See `re_exec_attr()`  
    */
    private class DirectRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
      DataFlow::Node regexNode;
      Attribute regexMethod;

      DirectRegex() {
        // needs inheritance (?)
        this = re_exec_attr() and regexNode = this.getRegexNode() and regexMethod = this.getRegexMethod()
      }

      override DataFlow::Node getRegexNode() { result = regexNode }
      override Attribute getRegexMethod() { result = regexMethod }
    }

    /** 
     * A class for finding `ReCompileCall` whose `Attribute` is an instance of `DirectRegex`.
     * See `ReCompileCall`, `DirectRegex`, `re_exec_attr()`
    */
    private class CompiledRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
      DataFlow::Node regexNode;
      Attribute regexMethod;

      CompiledRegex() {
        exists(ReCompileCall compileCall |
          regexNode = compileCall.getRegexNode() and
          regexMethod = compileCall.getRegexMethod() and
          this = compileCall
        )
      }

      override DataFlow::Node getRegexNode() { result = regexNode }
      override Attribute getRegexMethod() { result = regexMethod }
    }
  }
}