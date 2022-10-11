import codeql.ruby.frameworks.ActionCable
import codeql.ruby.frameworks.stdlib.Logger

query predicate loggerInstantiations(Logger::LoggerInstantiation l) { any() }
