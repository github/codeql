/**
 * Modeling for `ActionCable`, which is a websocket gem that ships with Rails.
 * https://rubygems.org/gems/actioncable
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
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
}
