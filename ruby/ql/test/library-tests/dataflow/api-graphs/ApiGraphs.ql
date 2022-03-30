/**
 * Tests of the public API of API Graphs
 */

import codeql.ruby.ApiGraphs

query predicate classMethodCalls(API::Node node) {
  node = API::getTopLevelMember("M1").getMember("C1").getReturn("m")
}

query predicate instanceMethodCalls(API::Node node) {
  node = API::getTopLevelMember("M1").getMember("C1").getInstance().getReturn("m")
}
