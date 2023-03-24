/**
 * Modeling for `ActiveJob`, a framweork for declaring and enqueueing jobs that
 * ships with Rails.
 * https://rubygems.org/gems/activejob
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

/** Modeling for `ActiveJob`. */
module ActiveJob {
  /**
   * `ActiveJob::Serializers`
   */
  module Serializers {
    /**
     * A call to `ActiveJob::Serializers.deserialize`, which interprets part of
     * its argument as a Ruby constant.
     */
    class DeserializeCall extends DataFlow::CallNode, CodeExecution::Range {
      DeserializeCall() {
        this =
          API::getTopLevelMember("ActiveJob").getMember("Serializers").getAMethodCall("deserialize")
      }

      override DataFlow::Node getCode() { result = this.getArgument(0) }

      override predicate runsArbitraryCode() { none() }
    }
  }
}
