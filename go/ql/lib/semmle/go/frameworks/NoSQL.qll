/**
 * Provides classes for working with NoSQL-related concepts such as queries.
 */

import go

/** Provides classes for working with NoSql-related APIs. */
module NoSql {
  /**
   * A data-flow node whose value is interpreted as (part of) a NoSQL query.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `NoSQL::Query::Range` instead.
   */
  class Query extends DataFlow::Node instanceof Query::Range { }

  /** Provides classes for working with NoSql queries. */
  module Query {
    /**
     * A data-flow node whose value is interpreted as (part of) a NoSQL query.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `NoSQL::Query` instead.
     */
    abstract class Range extends DataFlow::Node { }

    private class DefaultQueryString extends Range {
      DefaultQueryString() {
        exists(DataFlow::ArgumentNode arg | sinkNode(arg, "nosql-injection") |
          this = arg.getACorrespondingSyntacticArgument()
        )
      }
    }
  }

  /**
   * Holds if taint flows from `pred` to `succ` through a MongoDB-specific API.
   */
  predicate isAdditionalMongoTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Taint an entry if the `Value` is tainted
    exists(Write w, DataFlow::Node base, Field f | w.writesField(base, f, pred) |
      base = succ.(DataFlow::PostUpdateNode).getPreUpdateNode() and
      base.getType().hasQualifiedName(package("go.mongodb.org/mongo-driver", "bson/primitive"), "E") and
      f.getName() = "Value"
    )
  }
}
