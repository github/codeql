/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * To add this framework to a new language, add a new file (usually called `InlineFlowTest.qll`)
 * with:
 * - `private import codeql.dataflow.test.InlineFlowTest`
 * - private imports of the libraries implementing `DataFlow::InputSig`, `TaintTracking::InputSig`,
 *   and `InlineExpectationsTest::InlineExpectationsTestSig`.
 * - An implementation of the signature `InputSig` defined below.
 * - An import of an appropriately instantiated `InlineFlowTestMake` module.
 *
 * To declare expectations, you can use the `$ hasTaintFlow` or `$ hasValueFlow` comments within the
 * test source files. For example, in the case of Ruby `test.rb` file:
 * ```rb
 * s = source(1)
 * sink(s); // $ hasValueFlow=1
 * t = "foo" + taint(2);
 * sink(t); // $ hasTaintFlow=2
 * ```
 *
 * If you are only interested in value flow, then instead of importing `DefaultFlowTest`, you can import
 * `ValueFlowTest<DefaultFlowConfig>`. Similarly, if you are only interested in taint flow, then instead of
 * importing `DefaultFlowTest`, you can import `TaintFlowTest<DefaultFlowConfig>`. In both cases
 * `DefaultFlowConfig` can be replaced by another implementation of `DataFlow::ConfigSig`.
 *
 * If you need more fine-grained tuning, consider implementing a test using `InlineExpectationsTest`.
 */

private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT
private import codeql.util.test.InlineExpectationsTest as IET
private import codeql.util.Location

signature module InputSig<LocationSig Location, DF::InputSig<Location> DataFlowLang> {
  predicate defaultSource(DataFlowLang::Node source);

  predicate defaultSink(DataFlowLang::Node source);

  bindingset[src, sink]
  string getArgString(DataFlowLang::Node src, DataFlowLang::Node sink);

  /** Holds if the given extension tuple `madId` should pretty-print as `model`. */
  predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model);
}

module InlineFlowTestMake<
  LocationSig Location, DF::InputSig<Location> DataFlowLang,
  TT::InputSig<Location, DataFlowLang> TaintTrackingLang, IET::InlineExpectationsTestSig Test,
  InputSig<Location, DataFlowLang> Impl>
{
  private module DataFlow = DF::DataFlowMake<Location, DataFlowLang>;

  private module TaintTracking = TT::TaintFlowMake<Location, DataFlowLang, TaintTrackingLang>;

  private module InlineExpectationsTest = IET::Make<Test>;

  private import ProvenancePathGraph

  module DefaultFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlowLang::Node source) { Impl::defaultSource(source) }

    predicate isSink(DataFlowLang::Node sink) { Impl::defaultSink(sink) }
  }

  private module NoFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlowLang::Node source) { none() }

    predicate isSink(DataFlowLang::Node sink) { none() }
  }

  bindingset[src, sink]
  signature string getArgStringSig(DataFlowLang::Node src, DataFlowLang::Node sink);

  private module DataFlowGlobal<DataFlow::ConfigSig Config> {
    private import DataFlow::Global<Config> as G
    import G

    module PathGraphNoInterpretModel = G::PathGraph;

    module PathGraph =
      ShowProvenance<Impl::interpretModelForTest/2, PathNode, PathGraphNoInterpretModel>;
  }

  private module TaintTrackingGlobal<DataFlow::ConfigSig Config> {
    private import TaintTracking::Global<Config> as G
    import G

    module PathGraphNoInterpretModel = G::PathGraph;

    module PathGraph =
      ShowProvenance<Impl::interpretModelForTest/2, PathNode, PathGraphNoInterpretModel>;
  }

  module FlowTestArgString<
    DataFlow::ConfigSig ValueFlowConfig, DataFlow::ConfigSig TaintFlowConfig,
    getArgStringSig/2 getArgString>
  {
    module ValueFlow = DataFlowGlobal<ValueFlowConfig>;

    module TaintFlow = TaintTrackingGlobal<TaintFlowConfig>;

    private predicate hasLocationInfo(DataFlowLang::Node node, Test::Location location) {
      exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
        node.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
        location.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      )
    }

    private module InlineTest implements InlineExpectationsTest::TestSig {
      string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

      predicate hasActualResult(Test::Location location, string element, string tag, string value) {
        tag = "hasValueFlow" and
        exists(DataFlowLang::Node src, DataFlowLang::Node sink | ValueFlow::flow(src, sink) |
          hasLocationInfo(sink, location) and
          element = sink.toString() and
          value = getArgString(src, sink)
        )
        or
        tag = "hasTaintFlow" and
        exists(DataFlowLang::Node src, DataFlowLang::Node sink |
          TaintFlow::flow(src, sink) and not ValueFlow::flow(src, sink)
        |
          hasLocationInfo(sink, location) and
          element = sink.toString() and
          value = getArgString(src, sink)
        )
      }
    }

    import InlineExpectationsTest::MakeTest<InlineTest>
    private import DataFlow::MergePathGraph<ValueFlow::PathNode, TaintFlow::PathNode, ValueFlow::PathGraphNoInterpretModel, TaintFlow::PathGraphNoInterpretModel> as Merged
    import Merged

    module PathGraph =
      ShowProvenance<Impl::interpretModelForTest/2, Merged::PathNode, Merged::PathGraph>;

    predicate flowPath(PathNode source, PathNode sink) {
      ValueFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) or
      TaintFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
    }
  }

  module FlowTest<DataFlow::ConfigSig ValueFlowConfig, DataFlow::ConfigSig TaintFlowConfig> {
    import FlowTestArgString<ValueFlowConfig, TaintFlowConfig, Impl::getArgString/2>
  }

  module DefaultFlowTest = FlowTest<DefaultFlowConfig, DefaultFlowConfig>;

  module ValueFlowTestArgString<DataFlow::ConfigSig ValueFlowConfig, getArgStringSig/2 getArgString>
  {
    import FlowTestArgString<ValueFlowConfig, NoFlowConfig, getArgString/2>
  }

  module ValueFlowTest<DataFlow::ConfigSig ValueFlowConfig> {
    import ValueFlowTestArgString<ValueFlowConfig, Impl::getArgString/2>
  }

  module TaintFlowTestArgString<DataFlow::ConfigSig TaintFlowConfig, getArgStringSig/2 getArgString>
  {
    import FlowTestArgString<NoFlowConfig, TaintFlowConfig, getArgString/2>
  }

  module TaintFlowTest<DataFlow::ConfigSig TaintFlowConfig> {
    import TaintFlowTestArgString<TaintFlowConfig, Impl::getArgString/2>
  }
}
