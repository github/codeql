import codeql.ruby.frameworks.stdlib.Logger::Logger
import codeql.ruby.frameworks.ActiveSupport::ActiveSupport::Logger
import codeql.ruby.DataFlow

query DataFlow::Node loggerLoggingCallInputs(LoggerLoggingCall c) { result = c.getAnInput() }
