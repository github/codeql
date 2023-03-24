/**
 * Modeling for `ActionCable`, which is a websocket gem that ships with Rails.
 * https://rubygems.org/gems/actioncable
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.frameworks.stdlib.Logger::Logger as StdlibLogger

/**
 * Modeling for `ActionCable`.
 */
module ActionCable {
  /**
   * `ActionCable::Connection::TaggedLoggerProxy`
   */
  module Logger {
    private class ActionCableLoggerInstantiation extends StdlibLogger::LoggerInstantiation {
      ActionCableLoggerInstantiation() {
        this =
          API::getTopLevelMember("ActionCable")
              .getMember("Connection")
              .getMember("TaggedLoggerProxy")
              .getAnInstantiation()
      }
    }
  }

  private DataFlow::ConstRef getActionCableChannelBase() {
    result = DataFlow::getConstant("ActionCable").getConstant("Channel").getConstant("Base")
  }

  /**
   * The data argument in an RPC endpoint method on a subclass of
   * `ActionCable::Channel::Base`, considered as a remote flow source.
   */
  class ActionCableChannelRpcParam extends RemoteFlowSource::Range {
    ActionCableChannelRpcParam() {
      exists(DataFlow::MethodNode m |
        // Any method on a subclass of `ActionCable::Channel::Base`
        // automatically becomes an RPC endpoint
        m = getActionCableChannelBase().getADescendentModule().getAnInstanceMethod() and
        // as long as it's not an instance method of
        // `ActionCable::Channel::Base` itself, which might exist in the
        // database
        not m = getActionCableChannelBase().asModule().getAnInstanceMethod() and
        // and as long as it's public
        m.isPublic() and
        // and is not called `subscribed` or `unsubscribed`.
        not m.getMethodName() = ["subscribed", "unsubscribed"]
      |
        // If the method takes a parameter, it contains data from the remote
        // request.
        this = m.getParameter(0)
      )
    }

    override string getSourceType() { result = "ActionCable channel RPC data" }
  }
}
